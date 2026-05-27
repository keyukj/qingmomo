import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qingmooo/services/coin_service.dart';

class IAPService {
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
  // 改进：使用交易ID而非产品ID追踪已处理的购买，允许重复购买同一产品
  static final Set<String> _processedTransactions = {};

  /// 初始化内购
  static Future<bool> init() async {
    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      if (!_isAvailable) {
        print('内购不可用');
        return false;
      }

      // 监听购买更新
      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdate,
        onError: (error) {
          print('购买流错误: $error');
        },
      );

      // 获取产品信息
      await _loadProducts();
      return true;
    } catch (e) {
      print('初始化内购失败: $e');
      return false;
    }
  }

  /// 加载产品信息
  static Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(productIds.toSet());

      if (response.error != null) {
        print('查询产品失败: ${response.error}');
        
        // 在模拟器或测试环境中，使用模拟数据
        if (response.notFoundIDs.isNotEmpty && response.productDetails.isEmpty) {
          print('使用模拟产品数据（开发模式）');
          _products = _createMockProducts();
          return;
        }
        return;
      }

      _products = response.productDetails;
      print('成功加载 ${_products.length} 个产品');
    } catch (e) {
      print('加载产品失败: $e');
      // 异常时也使用模拟数据
      print('使用模拟产品数据（开发模式）');
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
        print('产品不存在: $productId');
        return;
      }

      // 处理模拟产品的特殊情况
      if (product is MockProductDetails) {
        // 在模拟器中直接模拟购买成功
        _simulatePurchase(productId);
        return;
      }

      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      // 使用 buyConsumable 因为金币是消耗品
      await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      print('购买失败: $e');
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
      verificationData: PurchaseVerificationData(
        localVerificationData: '',
        serverVerificationData: '',
        source: 'mock',
      ),
    );
    
    _handleSuccessfulPurchase(mockPurchase);
  }

  /// 处理购买更新
  static void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print('购买待处理: ${purchaseDetails.productID}');
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        print('购买错误: ${purchaseDetails.error}');
        // 错误时立即完成购买
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        // 只处理新购买，不处理恢复购买
        _handleSuccessfulPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        // 恢复购买时只记录，不重复添加金币
        print('购买已恢复: ${purchaseDetails.productID}');
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// 处理成功购买
  static Future<void> _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    final productId = purchaseDetails.productID;
    
    // 使用交易ID而非产品ID，允许重复购买同一产品
    final transactionId = purchaseDetails.purchaseID ?? 
                         '${productId}_${DateTime.now().millisecondsSinceEpoch}';
    
    // 检查是否已经处理过该交易
    if (_processedTransactions.contains(transactionId)) {
      print('交易已处理过: $transactionId');
      // 仍然需要完成购买
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
      return;
    }

    final coins = productCoins[productId];

    if (coins != null) {
      try {
        // 添加金币
        await CoinService.addCoins(coins, reason: '充值 - $productId');
        print('购买成功: $productId, 获得 $coins 金币');

        // 标记为已处理
        _processedTransactions.add(transactionId);

        // 触发回调
        for (final callback in _purchaseCallbacks) {
          callback(purchaseDetails);
        }
      } catch (e) {
        print('添加金币失败: $e');
        // 金币添加失败，不完成购买，用户可以重试
        return;
      }
    }

    // 金币添加成功后才完成购买
    if (purchaseDetails.pendingCompletePurchase) {
      _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  /// 注册购买成功回调
  static void onPurchaseSuccess(Function(PurchaseDetails) callback) {
    _purchaseCallbacks.add(callback);
  }

  /// 清除所有回调
  static void clearPurchaseCallbacks() {
    _purchaseCallbacks.clear();
  }

  /// 恢复购买
  static Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      print('购买已恢复');
    } catch (e) {
      print('恢复购买失败: $e');
    }
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
    _purchaseCallbacks.clear();
    _processedTransactions.clear();
  }

  /// 检查内购是否可用
  static bool isAvailable() {
    return _isAvailable;
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
