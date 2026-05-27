import 'package:shared_preferences/shared_preferences.dart';

/// 改进的CoinService - 添加事务性保证和流支持
class CoinServiceImproved {
  static late SharedPreferences _prefs;
  static const String _coinsKey = 'user_coins';
  static const String _coinHistoryKey = 'coin_history';
  static const String _transactionLogKey = 'transaction_log';
  static const int _defaultCoins = 30; // 默认30金币
  static const int _publishCost = 10; // 发布一条动态消耗10金币

  // 金币变化流 - 用于实时更新UI
  static final _coinStreamController = _CoinStreamController();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // 初始化金币，如果没有则设置为默认值
    if (!_prefs.containsKey(_coinsKey)) {
      await _prefs.setInt(_coinsKey, _defaultCoins);
    }
    
    // 恢复未完成的交易
    await _recoverPendingTransactions();
  }

  /// 获取当前金币数
  static Future<int> getCoins() async {
    return _prefs.getInt(_coinsKey) ?? _defaultCoins;
  }

  /// 设置金币数
  static Future<void> setCoins(int coins) async {
    await _prefs.setInt(_coinsKey, coins);
    // 记录历史
    await _addCoinHistory('设置金币', coins, 0);
    // 发送流事件
    _coinStreamController.add(coins);
  }

  /// 增加金币 - 改进版本（带事务性）
  static Future<void> addCoins(int amount, {String reason = '充值'}) async {
    try {
      final currentCoins = await getCoins();
      final newCoins = currentCoins + amount;
      final timestamp = DateTime.now().toIso8601String();
      final transactionId = 'txn_add_${DateTime.now().millisecondsSinceEpoch}';

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
      await _addCoinHistory(reason, amount, 1); // 1 表示增加

      // 4. 标记交易为完成
      await _logTransaction(transactionId, 'completed', {
        'amount': amount,
        'reason': reason,
        'timestamp': timestamp,
        'oldCoins': currentCoins,
        'newCoins': newCoins,
      });

      // 5. 发送流事件
      _coinStreamController.add(newCoins);
    } catch (e) {
      print('增加金币失败: $e');
      rethrow;
    }
  }

  /// 消耗金币 - 改进版本（带事务性）
  static Future<bool> consumeCoins(int amount, {String reason = '发布动态'}) async {
    try {
      final currentCoins = await getCoins();
      if (currentCoins < amount) {
        return false; // 金币不足
      }

      final newCoins = currentCoins - amount;
      final timestamp = DateTime.now().toIso8601String();
      final transactionId = 'txn_consume_${DateTime.now().millisecondsSinceEpoch}';

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
      await _addCoinHistory(reason, amount, -1); // -1 表示消耗

      // 4. 标记交易为完成
      await _logTransaction(transactionId, 'completed', {
        'amount': amount,
        'reason': reason,
        'timestamp': timestamp,
        'oldCoins': currentCoins,
        'newCoins': newCoins,
      });

      // 5. 发送流事件
      _coinStreamController.add(newCoins);

      return true;
    } catch (e) {
      print('消费金币失败: $e');
      return false;
    }
  }

  /// 发布动态消耗金币
  static Future<bool> publishPost() async {
    return await consumeCoins(_publishCost, reason: '发布动态');
  }

  /// 检查是否有足够的金币发布
  static Future<bool> canPublish() async {
    final coins = await getCoins();
    return coins >= _publishCost;
  }

  /// 获取发布所需金币
  static int getPublishCost() {
    return _publishCost;
  }

  /// 添加金币历史记录
  static Future<void> _addCoinHistory(String reason, int amount, int type) async {
    final history = await getCoinHistory();
    final timestamp = DateTime.now().toIso8601String();
    history.add({
      'timestamp': timestamp,
      'reason': reason,
      'amount': amount,
      'type': type, // 1: 增加, -1: 消耗, 0: 其他
    });
    // 只保留最近100条记录
    if (history.length > 100) {
      history.removeAt(0);
    }
    await _prefs.setStringList(
      _coinHistoryKey,
      history.map((e) => '${e['timestamp']}|${e['reason']}|${e['amount']}|${e['type']}').toList(),
    );
  }

  /// 获取金币历史记录
  static Future<List<Map<String, dynamic>>> getCoinHistory() async {
    final historyList = _prefs.getStringList(_coinHistoryKey) ?? [];
    return historyList.map((item) {
      final parts = item.split('|');
      return {
        'timestamp': parts[0],
        'reason': parts[1],
        'amount': int.parse(parts[2]),
        'type': int.parse(parts[3]),
      };
    }).toList();
  }

  /// 记录交易日志 - 用于事务恢复
  static Future<void> _logTransaction(
    String transactionId,
    String status,
    Map<String, dynamic> data,
  ) async {
    final log = _prefs.getStringList(_transactionLogKey) ?? [];
    log.add(
      '$transactionId|$status|${DateTime.now().toIso8601String()}|${_encodeMap(data)}',
    );
    // 只保留最近1000条记录
    if (log.length > 1000) {
      log.removeAt(0);
    }
    await _prefs.setStringList(_transactionLogKey, log);
  }

  /// 恢复未完成的交易
  static Future<void> _recoverPendingTransactions() async {
    final log = _prefs.getStringList(_transactionLogKey) ?? [];
    
    for (final entry in log) {
      final parts = entry.split('|');
      if (parts.length >= 2 && parts[1] == 'pending') {
        print('发现未完成的交易: ${parts[0]}, 尝试恢复...');
        // 这里可以实现恢复逻辑
        // 例如：重新执行交易或标记为失败
      }
    }
  }

  /// 获取交易日志
  static Future<List<Map<String, dynamic>>> getTransactionLog() async {
    final log = _prefs.getStringList(_transactionLogKey) ?? [];
    return log.map((entry) {
      final parts = entry.split('|');
      return {
        'transactionId': parts[0],
        'status': parts[1],
        'timestamp': parts[2],
        'data': _decodeMap(parts.length > 3 ? parts[3] : ''),
      };
    }).toList();
  }

  /// 编码Map为字符串
  static String _encodeMap(Map<String, dynamic> map) {
    return map.entries.map((e) => '${e.key}:${e.value}').join(',');
  }

  /// 解码字符串为Map
  static Map<String, dynamic> _decodeMap(String encoded) {
    if (encoded.isEmpty) return {};
    final map = <String, dynamic>{};
    for (final pair in encoded.split(',')) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        map[parts[0]] = parts[1];
      }
    }
    return map;
  }

  /// 获取金币变化流
  static Stream<int> get coinStream => _coinStreamController.stream;

  /// 清除所有金币数据（注销登录）
  static Future<void> clearCoinData() async {
    await _prefs.remove(_coinsKey);
    await _prefs.remove(_coinHistoryKey);
    await _prefs.remove(_transactionLogKey);
    // 重新初始化为默认值
    await _prefs.setInt(_coinsKey, _defaultCoins);
    _coinStreamController.add(_defaultCoins);
  }

  /// 清理资源
  static Future<void> dispose() async {
    await _coinStreamController.close();
  }
}

/// 金币流控制器
class _CoinStreamController {
  final _controller = StreamController<int>.broadcast();

  Stream<int> get stream => _controller.stream;

  void add(int coins) {
    if (!_controller.isClosed) {
      _controller.add(coins);
    }
  }

  Future<void> close() => _controller.close();
}
