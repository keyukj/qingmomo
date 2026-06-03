import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qingmooo/services/coin_service.dart';

class IAPService {
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;

  static const Map<String, int> productCoins = {
    'com.qingmo.icon8': 80,
    'com.qingmo.icon18': 180,
    'com.qingmo.icon38': 380,
    'com.qingmo.icon68': 680,
    'com.qingmo.icon128': 1280,
    'com.qingmo.icon268': 2680,
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
  static bool _useMockPurchase = false;
  static List<ProductDetails> _products = [];
  static final Set<String> _processedTransactions = {};
  static final Set<String> _pendingProductIds = {};
  static final Map<String, Timer> _purchaseTimeoutTimers = {};

  static final StreamController<String> _purchaseStartedController =
      StreamController<String>.broadcast();
  static final StreamController<PurchaseDetails> _purchaseSuccessController =
      StreamController<PurchaseDetails>.broadcast();
  static final StreamController<String> _purchaseErrorController =
      StreamController<String>.broadcast();

  static Stream<String> get purchaseStartedStream =>
      _purchaseStartedController.stream;
  static Stream<PurchaseDetails> get purchaseSuccessStream =>
      _purchaseSuccessController.stream;
  static Stream<String> get purchaseErrorStream =>
      _purchaseErrorController.stream;

  static int get _purchaseTimeoutSeconds => kDebugMode ? 120 : 60;

  static bool get useMockPurchase => _useMockPurchase;

  static Future<bool> _detectUseMockPurchase() async {
    if (!kDebugMode || kIsWeb || !Platform.isIOS) return false;
    try {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      return !iosInfo.isPhysicalDevice;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> init() async {
    try {
      _useMockPurchase = await _detectUseMockPurchase();
      _isAvailable = await _inAppPurchase.isAvailable();

      if (!_isAvailable && !_useMockPurchase) {
        _notifyError('内购不可用');
        return false;
      }

      if (_isAvailable) {
        await _subscription?.cancel();
        _subscription = _inAppPurchase.purchaseStream.listen(
          _handlePurchaseUpdate,
          onError: (error) => _notifyError('购买流错误: $error'),
        );
      }

      await loadProducts();

      if (_isAvailable && !_useMockPurchase) {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await _restorePendingPurchases();
      }

      return _useMockPurchase || _isAvailable;
    } catch (e) {
      _notifyError('初始化内购失败: $e');
      return false;
    }
  }

  static Future<void> _restorePendingPurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (_) {}
  }

  static Future<void> loadProducts() async {
    if (_useMockPurchase) {
      _products = _createMockProducts();
      return;
    }

    try {
      final response =
          await _inAppPurchase.queryProductDetails(productIds.toSet());
      _products = response.productDetails;
    } catch (_) {
      _products = [];
    }
  }

  static List<ProductDetails> _createMockProducts() {
    const mockPrices = {
      'com.qingmo.icon8': '¥8.00',
      'com.qingmo.icon18': '¥18.00',
      'com.qingmo.icon38': '¥38.00',
      'com.qingmo.icon68': '¥68.00',
      'com.qingmo.icon128': '¥128.00',
      'com.qingmo.icon268': '¥268.00',
    };

    return productIds.map((id) {
      return ProductDetails(
        id: id,
        title: '$id 金币套餐',
        description: '购买金币套餐',
        price: mockPrices[id] ?? '¥0.00',
        rawPrice: 0,
        currencyCode: 'CNY',
        currencySymbol: '¥',
      );
    }).toList();
  }

  static List<ProductDetails> getProducts() => _products;

  static ProductDetails? getProduct(String productId) {
    for (final product in _products) {
      if (product.id == productId) return product;
    }
    return null;
  }

  static Future<void> purchaseProduct(String productId) async {
    if (_pendingProductIds.contains(productId)) {
      _notifyError('正在处理上一笔购买，请稍候');
      return;
    }

    try {
      if (!_useMockPurchase) {
        await loadProducts();
      }

      final product = getProduct(productId);
      if (product == null) {
        _notifyError('产品不存在，请稍后重试');
        return;
      }

      _pendingProductIds.add(productId);
      _notifyPurchaseStarted(productId);

      if (_useMockPurchase) {
        await _simulatePurchase(productId);
        return;
      }

      _setPurchaseTimeout(productId);

      final started = await _inAppPurchase.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
        autoConsume: true,
      );

      if (!started) {
        _clearPendingPurchase(productId);
        _notifyError('无法发起购买，请稍后重试');
      }
    } catch (e) {
      _clearPendingPurchase(productId);
      _notifyError('购买失败: $e');
    }
  }

  static Future<void> _simulatePurchase(String productId) async {
    final mockPurchase = PurchaseDetails(
      productID: productId,
      purchaseID: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      transactionDate: DateTime.now().toIso8601String(),
      status: PurchaseStatus.purchased,
      verificationData: PurchaseVerificationData(
        localVerificationData: '',
        serverVerificationData: '',
        source: 'mock',
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 800));
    await _deliverPurchase(mockPurchase);
  }

  static void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      final productId = purchaseDetails.productID;

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _setPurchaseTimeout(productId);
          break;
        case PurchaseStatus.canceled:
          _clearPendingPurchase(productId);
          _notifyError('已取消购买');
          _finishTransaction(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _clearPendingPurchase(productId);
          final message = purchaseDetails.error?.message ?? '未知错误';
          _notifyError(
            message.toLowerCase().contains('cancel') ? '已取消购买' : '购买错误: $message',
          );
          _finishTransaction(purchaseDetails);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _deliverPurchase(purchaseDetails);
          break;
      }
    }
  }

  static Future<void> _deliverPurchase(PurchaseDetails purchaseDetails) async {
    final productId = purchaseDetails.productID;
    final transactionId = purchaseDetails.purchaseID ??
        '${productId}_${DateTime.now().millisecondsSinceEpoch}';

    if (_processedTransactions.contains(transactionId)) {
      _clearPendingPurchase(productId);
      await _finishTransaction(purchaseDetails);
      return;
    }

    final coins = productCoins[productId];
    if (coins == null) {
      _clearPendingPurchase(productId);
      _notifyError('产品配置错误');
      await _finishTransaction(purchaseDetails);
      return;
    }

    try {
      await CoinService.addCoins(coins, reason: '充值 - $productId');
      _processedTransactions.add(transactionId);
      if (!_purchaseSuccessController.isClosed) {
        _purchaseSuccessController.add(purchaseDetails);
      }
    } catch (e) {
      _notifyError('充值失败: $e');
      return;
    } finally {
      _clearPendingPurchase(productId);
    }

    await _finishTransaction(purchaseDetails);
  }

  static Future<void> _finishTransaction(PurchaseDetails purchaseDetails) async {
    if (!purchaseDetails.pendingCompletePurchase) return;
    try {
      await _inAppPurchase.completePurchase(purchaseDetails);
    } catch (e) {
      _notifyError('完成购买失败: $e');
    }
  }

  static void _setPurchaseTimeout(String productId) {
    _purchaseTimeoutTimers[productId]?.cancel();
    _purchaseTimeoutTimers[productId] = Timer(
      Duration(seconds: _purchaseTimeoutSeconds),
      () {
        if (_pendingProductIds.contains(productId)) {
          _clearPendingPurchase(productId);
          _notifyError('购买超时，请重试');
        }
      },
    );
  }

  static void _clearPendingPurchase(String productId) {
    _pendingProductIds.remove(productId);
    _purchaseTimeoutTimers.remove(productId)?.cancel();
  }

  static void _notifyPurchaseStarted(String productId) {
    if (!_purchaseStartedController.isClosed) {
      _purchaseStartedController.add(productId);
    }
  }

  static void _notifyError(String message) {
    if (!_purchaseErrorController.isClosed) {
      _purchaseErrorController.add(message);
    }
  }

  static Future<void> restorePurchases() async {
    await _restorePendingPurchases();
  }

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

  static Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _processedTransactions.clear();
    _pendingProductIds.clear();
    for (final timer in _purchaseTimeoutTimers.values) {
      timer.cancel();
    }
    _purchaseTimeoutTimers.clear();
    await _purchaseStartedController.close();
    await _purchaseSuccessController.close();
    await _purchaseErrorController.close();
  }

  static bool isAvailable() => _isAvailable || _useMockPurchase;
}
