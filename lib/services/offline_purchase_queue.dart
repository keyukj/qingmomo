import 'package:shared_preferences/shared_preferences.dart';

/// 离线购买队列 - 处理网络不稳定时的购买请求
class OfflinePurchaseQueue {
  static const String _queueKey = 'offline_purchase_queue';
  static const String _retryCountKey = 'purchase_retry_count';
  static const int _maxRetries = 5;
  static const int _retryDelaySeconds = 30;

  static late SharedPreferences _prefs;

  /// 初始化
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 添加离线购买请求
  static Future<void> addPurchaseRequest(String productId) async {
    try {
      final queue = _prefs.getStringList(_queueKey) ?? [];
      
      // 检查是否已存在相同的请求
      final exists = queue.any((item) => item.startsWith('$productId|'));
      if (exists) {
        print('购买请求已存在: $productId');
        return;
      }

      final request = _encodePurchaseRequest(
        productId: productId,
        timestamp: DateTime.now(),
        retryCount: 0,
      );
      
      queue.add(request);
      await _prefs.setStringList(_queueKey, queue);
      print('添加离线购买请求: $productId');
    } catch (e) {
      print('添加购买请求失败: $e');
    }
  }

  /// 获取待处理的购买请求
  static Future<List<PurchaseRequest>> getPendingRequests() async {
    try {
      final queue = _prefs.getStringList(_queueKey) ?? [];
      return queue.map((item) => _decodePurchaseRequest(item)).toList();
    } catch (e) {
      print('获取待处理请求失败: $e');
      return [];
    }
  }

  /// 获取特定产品的请求
  static Future<PurchaseRequest?> getRequest(String productId) async {
    try {
      final requests = await getPendingRequests();
      return requests.firstWhere(
        (req) => req.productId == productId,
        orElse: () => PurchaseRequest(
          productId: '',
          timestamp: DateTime.now(),
          retryCount: 0,
        ),
      );
    } catch (e) {
      print('获取请求失败: $e');
      return null;
    }
  }

  /// 更新请求的重试次数
  static Future<void> updateRetryCount(String productId, int retryCount) async {
    try {
      final queue = _prefs.getStringList(_queueKey) ?? [];
      final index = queue.indexWhere((item) => item.startsWith('$productId|'));
      
      if (index != -1) {
        final request = _decodePurchaseRequest(queue[index]);
        queue[index] = _encodePurchaseRequest(
          productId: request.productId,
          timestamp: request.timestamp,
          retryCount: retryCount,
        );
        await _prefs.setStringList(_queueKey, queue);
      }
    } catch (e) {
      print('更新重试次数失败: $e');
    }
  }

  /// 移除已处理的请求
  static Future<void> removePurchaseRequest(String productId) async {
    try {
      final queue = _prefs.getStringList(_queueKey) ?? [];
      queue.removeWhere((item) => item.startsWith('$productId|'));
      await _prefs.setStringList(_queueKey, queue);
      print('移除购买请求: $productId');
    } catch (e) {
      print('移除请求失败: $e');
    }
  }

  /// 清空队列
  static Future<void> clearQueue() async {
    try {
      await _prefs.remove(_queueKey);
      print('清空购买队列');
    } catch (e) {
      print('清空队列失败: $e');
    }
  }

  /// 处理离线队列 - 尝试处理所有待处理的请求
  static Future<void> processPendingQueue(
    Future<void> Function(String) purchaseFunction,
  ) async {
    try {
      final requests = await getPendingRequests();
      
      if (requests.isEmpty) {
        print('没有待处理的购买请求');
        return;
      }

      print('开始处理 ${requests.length} 个待处理的购买请求');

      for (final request in requests) {
        // 检查重试次数
        if (request.retryCount >= _maxRetries) {
          print('购买请求已达到最大重试次数: ${request.productId}');
          await removePurchaseRequest(request.productId);
          continue;
        }

        try {
          print('处理购买请求: ${request.productId} (重试 ${request.retryCount}/$_maxRetries)');
          await purchaseFunction(request.productId);
          await removePurchaseRequest(request.productId);
          print('购买请求处理成功: ${request.productId}');
        } catch (e) {
          print('处理购买请求失败: $e');
          // 增加重试次数
          await updateRetryCount(request.productId, request.retryCount + 1);
        }
      }
    } catch (e) {
      print('处理离线队列失败: $e');
    }
  }

  /// 获取队列统计信息
  static Future<QueueStats> getQueueStats() async {
    try {
      final requests = await getPendingRequests();
      
      int totalRequests = requests.length;
      int failedRequests = requests.where((r) => r.retryCount > 0).length;
      int maxRetryRequests = requests.where((r) => r.retryCount >= _maxRetries).length;

      return QueueStats(
        totalRequests: totalRequests,
        failedRequests: failedRequests,
        maxRetryRequests: maxRetryRequests,
        oldestRequestTime: requests.isNotEmpty
            ? requests.reduce((a, b) => a.timestamp.isBefore(b.timestamp) ? a : b).timestamp
            : null,
      );
    } catch (e) {
      print('获取队列统计信息失败: $e');
      return QueueStats(
        totalRequests: 0,
        failedRequests: 0,
        maxRetryRequests: 0,
        oldestRequestTime: null,
      );
    }
  }

  /// 编码购买请求
  static String _encodePurchaseRequest({
    required String productId,
    required DateTime timestamp,
    required int retryCount,
  }) {
    return '$productId|${timestamp.toIso8601String()}|$retryCount';
  }

  /// 解码购买请求
  static PurchaseRequest _decodePurchaseRequest(String encoded) {
    final parts = encoded.split('|');
    return PurchaseRequest(
      productId: parts[0],
      timestamp: DateTime.parse(parts[1]),
      retryCount: int.parse(parts[2]),
    );
  }
}

/// 购买请求模型
class PurchaseRequest {
  final String productId;
  final DateTime timestamp;
  final int retryCount;

  PurchaseRequest({
    required this.productId,
    required this.timestamp,
    required this.retryCount,
  });

  /// 是否应该重试
  bool shouldRetry() {
    return retryCount < OfflinePurchaseQueue._maxRetries;
  }

  /// 获取下次重试时间
  DateTime getNextRetryTime() {
    final delaySeconds = OfflinePurchaseQueue._retryDelaySeconds * (retryCount + 1);
    return timestamp.add(Duration(seconds: delaySeconds));
  }

  /// 是否已过期（超过24小时）
  bool isExpired() {
    final expiryTime = timestamp.add(const Duration(hours: 24));
    return DateTime.now().isAfter(expiryTime);
  }

  @override
  String toString() => 'PurchaseRequest(productId: $productId, retryCount: $retryCount)';
}

/// 队列统计信息
class QueueStats {
  final int totalRequests;
  final int failedRequests;
  final int maxRetryRequests;
  final DateTime? oldestRequestTime;

  QueueStats({
    required this.totalRequests,
    required this.failedRequests,
    required this.maxRetryRequests,
    this.oldestRequestTime,
  });

  bool get isEmpty => totalRequests == 0;
  bool get hasFailedRequests => failedRequests > 0;
  bool get hasMaxRetryRequests => maxRetryRequests > 0;

  @override
  String toString() => 'QueueStats(total: $totalRequests, failed: $failedRequests, maxRetry: $maxRetryRequests)';
}
