import 'dart:async';
import 'dart:collection';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qingmooo/services/coin_service.dart';

/// 改进的IAP服务 - 修复重复购买问题和添加重试机制
class IAPServiceImproved {
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  static late StreamSubscription<List<PurchaseDetails>> _subscription;

  // 内购产品ID和对应的金币数
  static const Map<String, int> productCoins = {
    'com.qingmo.icon8': 80,      // 8元 -> 80金币
    'com.qingmo.icon18': 180,    // 18元 -> 180金币
    'com.qingmo.icon38': 380,    // 38元 -> 380金币
    'com.qingmo.icon68': 680,    // 68元 -> 680金币
    'com.qingmo.icon128': 1280,  // 128元 -> 1280金币
    'com.qingmo.icon268': 2680,  // 268元 -> 2680金币
  };

  static const List<String> productIds = [
    'com.qingmo.icon8',
    'com.qingmo.icon18',
    'com.qingmo.icon38',
    'com.qingmo.icon68',
    'com.qingmo.icon128',
    'com.qingmo.icon268',
  ];

  static bool _isAvailable = false;
  static List<dynamic> _products = [];
  static final List<Function(PurchaseDetails)> _purchaseCallbacks = [];
  static final List<Function(PurchaseDetails)> _errorCallbacks = [];
  
  // 改进：使用交易ID而非产品ID追踪已处理的购买
  static final Set<String> _processedTransactions = {};
  
  // 交易历史记录
  static final List<Map<String, dynamic>> _transactionHistory = [];
  
  // 失败购买队列 - 用于重试
  static final Queue<PurchaseDetails> _failedPurchases = Queue();
  static Timer? _retryTimer;

  /// 初始化内购
  static Future<bool> init() async {
    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      if (!_isAvailable) {
        _log('内购不可用');
        return false;
      }

      // 监听购买更新
      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdate,
        onError: (error) {
          _log('购买流错误: $error');
        },
      );

      // 获取产品信息
      await _loadProducts();
      
      // 恢复未完成的购买
      await _restoreUncompletedPurchases();
      
      return true;
    } catch (e) {
      _log('初始化内购失败: $e');
      return false;
    }
  }

  /// 加载产品信息
  static Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(productIds.toSet());

      if (response.error != null) {
        _log('查询产品失败: ${response.error}');
        
        // 在模拟器或测试环境中，使用模拟数据
        if (response.notFoundIDs.isNotEmpty && response.productDetails.isEmpty) {
          _log('使用模拟产品数据（开发模式）');
          _products = _createMockProducts();
          return;
        }
        return;
      }

      _products = response.productDetails;
      _log('成功加载 ${_products.length} 个产品');
    } catch (e) {
      _log('加载产品失败: $e');
      // 异常时也使用模拟数据
      _log('使用模拟产品数据（开发模式）');
      _products = _createMockProducts();
    }
  }

  /// 创建模拟产品数据（用于开发和测试）
  static List<dynamic> _createMockProducts() {
    final mockPrices = {
      'com.qingmo.icon8': '¥8.00',
      'com.qingmo.icon18': '¥18.00',
      'com.qingmo.icon38': '¥38.00',
      'com.qingmo.icon68': '¥68.00',
      'com.qingmo.icon128': '¥128.00',
      'com.qingmo.icon268': '¥268.00',
    };

    return productIds.map((id) {
      return MockProductDetails(
        id: id,
        title: '$id 金币套餐',
        description: '购买金币套餐',
        price: mockPrices[id] ?? '¥0.00',
      );
    }).toList();
  }

  /// 获取所有产品
  static List<dynamic> getProducts() {
    return _products;
  }

  /// 获取产品信息
  static dynamic getProduct(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// 购买产品（消耗品）
  static Future<void> purchaseProduct(String productId) async {
    try {
      final product = getProduct(productId);
      if (product == null) {
        _log('产品不存在: $productId');
        return;
      }

      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      
      // 处理模拟产品的特殊情况
      if (product is MockProductDetails) {
        // 在模拟器中直接模拟购买成功
        _simulatePurchase(productId);
      } else {
        // 使用 buyConsumable 因为金币是消耗品
        await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      _log('购买失败: $e');
    }
  }

  /// 模拟购买（用于开发和测试）
  static void _simulatePurchase(String productId) {
    final transactionId = 'mock_${DateTime.now().millisecondsSinceEpoch}';
    final mockPurchase = PurchaseDetails(
      productID: productId,
      purchaseID: transactionId,
      transactionDate: DateTime.now().toIso8601String(),
      status: PurchaseStatus.purchased,
      pendingCompletePurchase: false,
    );
    
    _handleSuccessfulPurchase(mockPurchase);
  }

  /// 处理购买更新
  static void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _log('购买待处理: ${purchaseDetails.productID}');
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        _log('购买错误: ${purchaseDetails.error}');
        _handlePurchaseError(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        // 只处理新购买，不处理恢复购买
        _handleSuccessfulPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        // 恢复购买时只记录，不重复添加金币
        _log('购买已恢复: ${purchaseDetails.productID}');
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// 处理成功购买 - 改进版本
  static Future<void> _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    // 使用交易ID而非产品ID
    final transactionId = purchaseDetails.purchaseID ?? 
                         '${purchaseDetails.productID}_${DateTime.now().millisecondsSinceEpoch}';
    
    // 检查交易ID而非产品ID - 这样允许重复购买同一产品
    if (_processedTransactions.contains(transactionId)) {
      _log('交易已处理过: $transactionId');
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
        _recordTransaction(transactionId, productId, coins, 'completed');
        
        _log('购买成功: $productId, 获得 $coins 金币');

        // 标记为已处理
        _processedTransactions.add(transactionId);

        // 触发回调
        for (final callback in _purchaseCallbacks) {
          callback(purchaseDetails);
        }
      } catch (e) {
        _log('添加金币失败: $e');
        // 金币添加失败，记录为失败状态
        _recordTransaction(transactionId, productId, coins, 'failed');
        return;
      }
    }

    // 金币添加成功后才完成购买
    if (purchaseDetails.pendingCompletePurchase) {
      _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  /// 处理购买错误
  static Future<void> _handlePurchaseError(PurchaseDetails purchaseDetails) async {
    _log('购买失败: ${purchaseDetails.productID}');
    
    // 添加到失败队列
    _failedPurchases.add(purchaseDetails);
    
    // 启动重试机制
    _startRetryTimer();
    
    // 触发错误回调
    for (final callback in _errorCallbacks) {
      callback(purchaseDetails);
    }
  }

  /// 启动重试定时器
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
        _log('尝试重试购买: ${purchase.productID}');
        // 尝试完成购买
        if (purchase.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchase);
          _failedPurchases.removeFirst();
          _log('重试成功: ${purchase.productID}');
        }
      } catch (e) {
        _log('重试失败: $e');
      }
    });
  }

  /// 停止重试定时器
  static void _stopRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  /// 恢复未完成的购买
  static Future<void> _restoreUncompletedPurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      _log('购买已恢复');
    } catch (e) {
      _log('恢复购买失败: $e');
    }
  }

  /// 记录交易
  static void _recordTransaction(
    String transactionId,
    String productId,
    int coins,
    String status,
  ) {
    _transactionHistory.add({
      'transactionId': transactionId,
      'productId': productId,
      'coins': coins,
      'timestamp': DateTime.now().toIso8601String(),
      'status': status,
    });
  }

  /// 获取交易历史
  static List<Map<String, dynamic>> getTransactionHistory() {
    return List.unmodifiable(_transactionHistory);
  }

  /// 获取失败的购买列表
  static List<PurchaseDetails> getFailedPurchases() {
    return _failedPurchases.toList();
  }

  /// 注册购买成功回调
  static void onPurchaseSuccess(Function(PurchaseDetails) callback) {
    _purchaseCallbacks.add(callback);
  }

  /// 注册购买错误回调
  static void onPurchaseError(Function(PurchaseDetails) callback) {
    _errorCallbacks.add(callback);
  }

  /// 清除所有回调
  static void clearPurchaseCallbacks() {
    _purchaseCallbacks.clear();
    _errorCallbacks.clear();
  }

  /// 获取产品价格和金币
  static Map<String, dynamic>? getProductInfo(String productId) {
    final product = getProduct(productId);
    if (product == null) return null;

    return {
      'id': productId,
      'title': product.title,
      'price': product.price,
      'coins': productCoins[productId],
      'description': product.description,
    };
  }

  /// 清理资源
  static Future<void> dispose() async {
    await _subscription.cancel();
    _stopRetryTimer();
    _purchaseCallbacks.clear();
    _errorCallbacks.clear();
    _processedTransactions.clear();
    _transactionHistory.clear();
    _failedPurchases.clear();
  }

  /// 检查内购是否可用
  static bool isAvailable() {
    return _isAvailable;
  }

  /// 日志输出
  static void _log(String message) {
    // 在生产环境中应该使用专业的日志框架
    print('[IAPService] $message');
  }
}

/// 模拟产品详情类（用于开发和测试）
class MockProductDetails {
  final String id;
  final String title;
  final String description;
  final String price;

  MockProductDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });
}
