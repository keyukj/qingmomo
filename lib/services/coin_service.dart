import 'package:shared_preferences/shared_preferences.dart';

class CoinService {
  static late SharedPreferences _prefs;
  static const String _coinsKey = 'user_coins';
  static const String _coinHistoryKey = 'coin_history';
  static const int _defaultCoins = 30; // 默认30金币
  static const int _publishCost = 10; // 发布一条动态消耗10金币

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // 初始化金币，如果没有则设置为默认值
    if (!_prefs.containsKey(_coinsKey)) {
      await _prefs.setInt(_coinsKey, _defaultCoins);
    }
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
  }

  /// 增加金币
  static Future<void> addCoins(int amount, {String reason = '充值'}) async {
    final currentCoins = await getCoins();
    final newCoins = currentCoins + amount;
    await _prefs.setInt(_coinsKey, newCoins);
    await _addCoinHistory(reason, amount, 1); // 1 表示增加
  }

  /// 消耗金币
  static Future<bool> consumeCoins(int amount, {String reason = '发布动态'}) async {
    final currentCoins = await getCoins();
    if (currentCoins < amount) {
      return false; // 金币不足
    }
    final newCoins = currentCoins - amount;
    await _prefs.setInt(_coinsKey, newCoins);
    await _addCoinHistory(reason, amount, -1); // -1 表示消耗
    return true;
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
    // 转换为字符串列表存储
    final stringList = history.map((e) => 
      '${e['timestamp']}|${e['reason']}|${e['amount']}|${e['type']}'
    ).toList();
    await _prefs.setStringList(_coinHistoryKey, stringList);
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

  /// 清除所有金币数据（注销登录）
  static Future<void> clearCoinData() async {
    await _prefs.remove(_coinsKey);
    await _prefs.remove(_coinHistoryKey);
    // 重新初始化为默认值
    await _prefs.setInt(_coinsKey, _defaultCoins);
  }
}
