import 'package:shared_preferences/shared_preferences.dart';

class CoinService {
  static late SharedPreferences _prefs;
  static const String _coinsKey = 'user_coins';
  static const String _coinHistoryKey = 'coin_history';
  static const int _defaultCoins = 30;
  static const int _publishCost = 10;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey(_coinsKey)) {
      await _prefs.setInt(_coinsKey, _defaultCoins);
    }
  }

  static Future<int> getCoins() async {
    return _prefs.getInt(_coinsKey) ?? _defaultCoins;
  }

  static Future<void> setCoins(int coins) async {
    await _prefs.setInt(_coinsKey, coins);
    await _addCoinHistory('设置金币', coins, 0);
  }

  static Future<void> addCoins(int amount, {String reason = '充值'}) async {
    final currentCoins = await getCoins();
    await _prefs.setInt(_coinsKey, currentCoins + amount);
    await _addCoinHistory(reason, amount, 1);
  }

  static Future<bool> consumeCoins(int amount, {String reason = '发布动态'}) async {
    final currentCoins = await getCoins();
    if (currentCoins < amount) {
      return false;
    }
    await _prefs.setInt(_coinsKey, currentCoins - amount);
    await _addCoinHistory(reason, amount, -1);
    return true;
  }

  static Future<bool> publishPost() async {
    return consumeCoins(_publishCost, reason: '发布动态');
  }

  static Future<bool> canPublish() async {
    final coins = await getCoins();
    return coins >= _publishCost;
  }

  static int getPublishCost() => _publishCost;

  static Future<void> _addCoinHistory(String reason, int amount, int type) async {
    final history = await getCoinHistory();
    history.add({
      'timestamp': DateTime.now().toIso8601String(),
      'reason': reason,
      'amount': amount,
      'type': type,
    });
    if (history.length > 100) {
      history.removeAt(0);
    }
    final stringList = history
        .map((e) => '${e['timestamp']}|${e['reason']}|${e['amount']}|${e['type']}')
        .toList();
    await _prefs.setStringList(_coinHistoryKey, stringList);
  }

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

  static Future<void> clearCoinData() async {
    await _prefs.remove(_coinsKey);
    await _prefs.remove(_coinHistoryKey);
    await _prefs.setInt(_coinsKey, _defaultCoins);
  }
}
