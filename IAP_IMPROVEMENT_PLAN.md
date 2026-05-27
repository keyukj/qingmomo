# 内购和消费逻辑改进方案

## 执行摘要

本文档分析了当前内购系统中的4个主要问题，并提供了详细的改进方案。这些改进将提高系统的可靠性、用户体验和数据一致性。

---

## 问题分析

### 1. IAPService 中的重复购买问题 ⚠️ 高优先级

**问题描述：**
```dart
// 当前实现 - 使用产品ID作为key
static final Set<String> _processedPurchases = {};

// 在 _handleSuccessfulPurchase 中
if (_processedPurchases.contains(productId)) {
    print('购买已处理过: $productId');
    return;
}
_processedPurchases.add(productId);
```

**根本原因：**
- 使用产品ID而非交易ID追踪已处理购买
- 同一产品可能被购买多次，但系统只记录产品ID
- 第二次购买同一产品时会被错误地拒绝

**影响：**
- 用户无法重复购买同一套餐
- 收入损失
- 用户体验差

**改进方案：**

```dart
// 改进后的实现
class IAPService {
  // 使用交易ID而非产品ID
  static final Set<String> _processedTransactions = {};
  
  // 添加交易历史记录
  static final List<Map<String, dynamic>> _transactionHistory = [];
  
  static Future<void> _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    final transactionId = purchaseDetails.purchaseID ?? 
                         '${purchaseDetails.productID}_${DateTime.now().millisecondsSinceEpoch}';
    
    // 检查交易ID而非产品ID
    if (_processedTransactions.contains(transactionId)) {
      print('交易已处理过: $transactionId');
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
      return;
    }

    final productId = purchaseDetails.productID;
    final coins = productCoins[productId];

    if (coins != null) {
      try {
        // 添加金币
        await CoinService.addCoins(coins, reason: '充值 - $productId');
        
        // 记录交易
        _transactionHistory.add({
          'transactionId': transactionId,
          'productId': productId,
          'coins': coins,
          'timestamp': DateTime.now().toIso8601String(),
          'status': 'completed',
        });
        
        print('购买成功: $productId, 获得 $coins 金币');

        // 标记为已处理
        _processedTransactions.add(transactionId);

        // 触发回调
        for (final callback in _purchaseCallbacks) {
          callback(purchaseDetails);
        }
      } catch (e) {
        print('添加金币失败: $e');
        return;
      }
    }

    // 金币添加成功后才完成购买
    if (purchaseDetails.pendingCompletePurchase) {
      _inAppPurchase.completePurchase(purchaseDetails);
    }
  }
}
```

---

### 2. PublishScreen 中的金币显示不更新问题 ⚠️ 中优先级

**问题描述：**
```dart
// 当前实现 - 只在initState加载一次
@override
void initState() {
  super.initState();
  _loadCoins();  // 只加载一次
}

// 用户充值后返回此页面，金币数不会自动刷新
```

**根本原因：**
- 没有监听页面生命周期事件
- 没有使用 `didChangeAppLifecycleState` 或 `RouteAware`
- 金币数据是静态的，不会响应其他页面的更新

**影响：**
- 用户充值后返回发布页面看不到新的金币数
- 需要手动刷新或重启应用
- 用户体验差

**改进方案：**

```dart
class _PublishScreenState extends State<PublishScreen> with WidgetsBindingObserver {
  int _currentCoins = 0;
  late StreamSubscription<int> _coinStreamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCoins();
    // 监听金币变化
    _setupCoinListener();
  }

  void _setupCoinListener() {
    // 创建一个全局的金币变化流
    // 在CoinService中添加StreamController
    _coinStreamSubscription = CoinService.coinStream.listen((coins) {
      if (mounted) {
        setState(() {
          _currentCoins = coins;
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 应用从后台返回时刷新金币
      _loadCoins();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _coinStreamSubscription.cancel();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCoins() async {
    final coins = await CoinService.getCoins();
    if (mounted) {
      setState(() {
        _currentCoins = coins;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... 其他代码保持不变
  }
}
```

**CoinService 中的改进：**

```dart
class CoinService {
  static late SharedPreferences _prefs;
  static final StreamController<int> _coinStreamController = StreamController<int>.broadcast();
  
  static Stream<int> get coinStream => _coinStreamController.stream;

  /// 增加金币
  static Future<void> addCoins(int amount, {String reason = '充值'}) async {
    final currentCoins = await getCoins();
    final newCoins = currentCoins + amount;
    await _prefs.setInt(_coinsKey, newCoins);
    await _addCoinHistory(reason, amount, 1);
    
    // 发送流事件
    _coinStreamController.add(newCoins);
  }

  /// 消耗金币
  static Future<bool> consumeCoins(int amount, {String reason = '发布动态'}) async {
    final currentCoins = await getCoins();
    if (currentCoins < amount) {
      return false;
    }
    final newCoins = currentCoins - amount;
    await _prefs.setInt(_coinsKey, newCoins);
    await _addCoinHistory(reason, amount, -1);
    
    // 发送流事件
    _coinStreamController.add(newCoins);
    return true;
  }

  /// 清理资源
  static Future<void> dispose() async {
    await _coinStreamController.close();
  }
}
```

---

### 3. CoinService 中的事务性问题 ⚠️ 高优先级

**问题描述：**
```dart
// 当前实现 - 非原子操作
static Future<bool> consumeCoins(int amount, {String reason = '发布动态'}) async {
  final currentCoins = await getCoins();
  if (currentCoins < amount) {
    return false;
  }
  final newCoins = currentCoins - amount;
  await _prefs.setInt(_coinsKey, newCoins);  // 如果这里崩溃...
  await _addCoinHistory(reason, amount, -1);  // ...历史记录不会被保存
  return true;
}
```

**根本原因：**
- 多个异步操作没有事务保证
- 如果应用在保存金币后但保存历史前崩溃，会导致数据不一致
- 没有回滚机制

**影响：**
- 数据不一致
- 用户金币数与历史记录不匹配
- 难以调试和恢复

**改进方案：**

```dart
class CoinService {
  static late SharedPreferences _prefs;
  static const String _transactionLogKey = 'transaction_log';
  
  /// 原子性的消费操作
  static Future<bool> consumeCoins(
    int amount, {
    String reason = '发布动态',
  }) async {
    try {
      final currentCoins = await getCoins();
      if (currentCoins < amount) {
        return false;
      }

      final newCoins = currentCoins - amount;
      final timestamp = DateTime.now().toIso8601String();
      final transactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';

      // 1. 先记录待处理的交易
      await _logTransaction(transactionId, 'pending', {
        'amount': amount,
        'reason': reason,
        'timestamp': timestamp,
        'oldCoins': currentCoins,
        'newCoins': newCoins,
      });

      // 2. 执行金币更新
      await _prefs.setInt(_coinsKey, newCoins);

      // 3. 添加历史记录
      await _addCoinHistory(reason, amount, -1);

      // 4. 标记交易为完成
      await _logTransaction(transactionId, 'completed', {
        'amount': amount,
        'reason': reason,
        'timestamp': timestamp,
        'oldCoins': currentCoins,
        'newCoins': newCoins,
      });

      return true;
    } catch (e) {
      print('消费金币失败: $e');
      return false;
    }
  }

  /// 记录交易日志
  static Future<void> _logTransaction(
    String transactionId,
    String status,
    Map<String, dynamic> data,
  ) async {
    final log = _prefs.getStringList(_transactionLogKey) ?? [];
    log.add(
      '$transactionId|$status|${DateTime.now().toIso8601String()}|${_encodeMap(data)}',
    );
    await _prefs.setStringList(_transactionLogKey, log);
  }

  /// 恢复未完成的交易
  static Future<void> recoverPendingTransactions() async {
    final log = _prefs.getStringList(_transactionLogKey) ?? [];
    
    for (final entry in log) {
      final parts = entry.split('|');
      if (parts.length >= 2 && parts[1] == 'pending') {
        print('发现未完成的交易: ${parts[0]}, 尝试恢复...');
        // 这里可以实现恢复逻辑
      }
    }
  }

  static String _encodeMap(Map<String, dynamic> map) {
    return map.entries.map((e) => '${e.key}:${e.value}').join(',');
  }
}
```

---

### 4. 缺失的功能 ⚠️ 中优先级

#### 4.1 购买历史记录查看功能

**当前状态：** ✅ 已实现 (coin_history_screen.dart)

但需要改进：
- 添加购买失败的重试机制
- 显示购买状态（待处理、已完成、已失败）
- 添加购买凭证验证

```dart
// 改进的历史记录结构
class CoinTransaction {
  final String id;
  final String type; // 'purchase', 'consume', 'refund'
  final int amount;
  final String reason;
  final DateTime timestamp;
  final String status; // 'pending', 'completed', 'failed'
  final String? productId;
  final String? transactionId;
  final String? receiptData;

  CoinTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.reason,
    required this.timestamp,
    required this.status,
    this.productId,
    this.transactionId,
    this.receiptData,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'amount': amount,
    'reason': reason,
    'timestamp': timestamp.toIso8601String(),
    'status': status,
    'productId': productId,
    'transactionId': transactionId,
    'receiptData': receiptData,
  };

  factory CoinTransaction.fromJson(Map<String, dynamic> json) => CoinTransaction(
    id: json['id'],
    type: json['type'],
    amount: json['amount'],
    reason: json['reason'],
    timestamp: DateTime.parse(json['timestamp']),
    status: json['status'],
    productId: json['productId'],
    transactionId: json['transactionId'],
    receiptData: json['receiptData'],
  );
}
```

#### 4.2 充值失败重试机制

**问题：** 当前没有处理充值失败后的重试

**改进方案：**

```dart
class IAPService {
  static final Queue<PurchaseDetails> _failedPurchases = Queue();
  static Timer? _retryTimer;

  static Future<void> _handlePurchaseError(PurchaseDetails purchaseDetails) async {
    print('购买失败: ${purchaseDetails.productID}');
    
    // 添加到失败队列
    _failedPurchases.add(purchaseDetails);
    
    // 启动重试机制
    _startRetryTimer();
    
    // 触发错误回调
    for (final callback in _errorCallbacks) {
      callback(purchaseDetails);
    }
  }

  static void _startRetryTimer() {
    if (_retryTimer != null) return;
    
    _retryTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
      if (_failedPurchases.isEmpty) {
        _retryTimer?.cancel();
        _retryTimer = null;
        return;
      }

      final purchase = _failedPurchases.first;
      try {
        // 尝试完成购买
        if (purchase.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchase);
          _failedPurchases.removeFirst();
        }
      } catch (e) {
        print('重试失败: $e');
      }
    });
  }

  static void _stopRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }
}
```

#### 4.3 离线购买队列

**问题：** 网络不稳定时，购买请求可能丢失

**改进方案：**

```dart
class OfflinePurchaseQueue {
  static const String _queueKey = 'offline_purchase_queue';
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 添加离线购买请求
  static Future<void> addPurchaseRequest(String productId) async {
    final queue = _prefs.getStringList(_queueKey) ?? [];
    queue.add('$productId|${DateTime.now().toIso8601String()}');
    await _prefs.setStringList(_queueKey, queue);
  }

  /// 获取待处理的购买请求
  static Future<List<String>> getPendingRequests() async {
    return _prefs.getStringList(_queueKey) ?? [];
  }

  /// 移除已处理的请求
  static Future<void> removePurchaseRequest(String productId) async {
    final queue = _prefs.getStringList(_queueKey) ?? [];
    queue.removeWhere((item) => item.startsWith('$productId|'));
    await _prefs.setStringList(_queueKey, queue);
  }

  /// 清空队列
  static Future<void> clearQueue() async {
    await _prefs.remove(_queueKey);
  }

  /// 处理离线队列
  static Future<void> processPendingQueue() async {
    final requests = await getPendingRequests();
    
    for (final request in requests) {
      final productId = request.split('|').first;
      try {
        await IAPService.purchaseProduct(productId);
        await removePurchaseRequest(productId);
      } catch (e) {
        print('处理离线购买失败: $e');
      }
    }
  }
}
```

---

## 改进优先级和实施计划

### 第一阶段（高优先级 - 立即实施）

1. **修复重复购买问题** (IAPService)
   - 使用交易ID而非产品ID
   - 添加交易历史记录
   - 预计工作量：2-3小时

2. **添加事务性保证** (CoinService)
   - 实现交易日志
   - 添加恢复机制
   - 预计工作量：3-4小时

### 第二阶段（中优先级 - 1-2周内）

3. **修复金币显示不更新** (PublishScreen)
   - 添加生命周期监听
   - 实现金币流
   - 预计工作量：2-3小时

4. **充值失败重试机制** (IAPService)
   - 实现失败队列
   - 添加重试定时器
   - 预计工作量：2-3小时

### 第三阶段（低优先级 - 1个月内）

5. **离线购买队列** (OfflinePurchaseQueue)
   - 实现队列存储
   - 添加处理逻辑
   - 预计工作量：2-3小时

---

## 实施检查清单

- [ ] 修复IAPService中的重复购买问题
- [ ] 添加交易ID追踪
- [ ] 实现CoinService事务日志
- [ ] 添加PublishScreen生命周期监听
- [ ] 实现金币变化流
- [ ] 添加充值失败重试机制
- [ ] 实现离线购买队列
- [ ] 添加单元测试
- [ ] 添加集成测试
- [ ] 进行压力测试
- [ ] 更新文档
- [ ] 发布更新

---

## 测试建议

### 单元测试

```dart
void main() {
  group('CoinService Tests', () {
    test('消费金币应该减少余额', () async {
      await CoinService.init();
      await CoinService.setCoins(100);
      
      final result = await CoinService.consumeCoins(30);
      
      expect(result, true);
      expect(await CoinService.getCoins(), 70);
    });

    test('金币不足时消费应该失败', () async {
      await CoinService.init();
      await CoinService.setCoins(10);
      
      final result = await CoinService.consumeCoins(30);
      
      expect(result, false);
      expect(await CoinService.getCoins(), 10);
    });
  });

  group('IAPService Tests', () {
    test('不应该重复处理同一交易', () async {
      // 测试交易ID去重
    });

    test('应该支持重复购买同一产品', () async {
      // 测试多次购买同一产品
    });
  });
}
```

### 集成测试

- 测试完整的充值流程
- 测试充值后金币显示更新
- 测试网络中断场景
- 测试应用崩溃恢复

---

## 安全考虑

1. **收据验证**
   - 在服务器端验证App Store/Google Play收据
   - 防止欺诈性购买

2. **金币操作日志**
   - 记录所有金币变化
   - 便于审计和问题排查

3. **交易加密**
   - 对敏感交易数据进行加密存储
   - 使用HTTPS传输

4. **速率限制**
   - 限制单位时间内的购买次数
   - 防止滥用

---

## 性能优化

1. **缓存优化**
   - 缓存产品信息
   - 减少API调用

2. **数据库优化**
   - 使用SQLite替代SharedPreferences存储大量数据
   - 添加索引提高查询速度

3. **内存优化**
   - 及时释放资源
   - 避免内存泄漏

---

## 总结

通过实施这些改进，系统将获得：

✅ **更高的可靠性** - 事务性保证和错误恢复
✅ **更好的用户体验** - 实时金币更新和失败重试
✅ **更强的安全性** - 交易日志和验证机制
✅ **更易维护** - 清晰的代码结构和完整的日志

预计总工作量：**12-16小时**
