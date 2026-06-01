import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qingmooo/services/iap_service.dart';
import 'package:qingmooo/services/coin_service.dart';
import 'package:qingmooo/widgets/coin_icon.dart';

class IAPScreen extends StatefulWidget {
  const IAPScreen({super.key});

  @override
  State<IAPScreen> createState() => _IAPScreenState();
}

class _IAPScreenState extends State<IAPScreen> {
  int _currentCoins = 0;
  String? _selectedPackageId;
  List<IAPPackage> _packages = [];
  bool _isLoading = true;
  bool _isPurchasing = false;
  StreamSubscription<String>? _startedSub;
  StreamSubscription<PurchaseDetails>? _successSub;
  StreamSubscription<String>? _errorSub;

  // IAP 产品ID列表
  static const List<String> _productIds = [
    'com.qingmo.icon8',
    'com.qingmo.icon18',
    'com.qingmo.icon38',
    'com.qingmo.icon68',
    'com.qingmo.icon128',
    'com.qingmo.icon268',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupPurchaseListener();
  }

  Future<void> _loadData() async {
    try {
      // 加载当前金币
      final coins = await CoinService.getCoins();
      
      // 重新加载产品信息，确保获取最新的产品列表
      await IAPService.loadProducts();
      
      // 获取 IAP 产品列表
      final products = IAPService.getProducts();
      
      // 构建套餐列表
      final packages = <IAPPackage>[];
      for (int i = 0; i < _productIds.length; i++) {
        final productId = _productIds[i];
        
        // 查找对应的产品
        dynamic product;
        try {
          product = products.firstWhere((p) => p.id == productId);
        } catch (e) {
          product = null;
        }
        
        if (product != null) {
          final coinAmount = IAPService.productCoins[productId] ?? 0;
          packages.add(
            IAPPackage(
              id: productId,
              price: product.price,
              coins: coinAmount,
              isHot: i == _productIds.length - 1,
            ),
          );
        }
      }
      
      if (mounted) {
        setState(() {
          _currentCoins = coins;
          _packages = packages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _setupPurchaseListener() {
    _startedSub = IAPService.purchaseStartedStream.listen((productId) {
      if (!mounted) return;
      setState(() {
        _isPurchasing = true;
        _selectedPackageId = productId;
      });
    });

    _successSub = IAPService.purchaseSuccessStream.listen((purchaseDetails) {
      if (!mounted) return;

      _loadData();
      final coins = IAPService.productCoins[purchaseDetails.productID] ?? 0;

      setState(() {
        _isPurchasing = false;
        _selectedPackageId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('成功充值 $coins 金币'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    });

    _errorSub = IAPService.purchaseErrorStream.listen((errorMessage) {
      if (!mounted) return;

      setState(() {
        _isPurchasing = false;
        _selectedPackageId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  Future<void> _purchasePackage(IAPPackage package) async {
    try {
      await IAPService.purchaseProduct(package.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('购买失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isPurchasing = false;
          _selectedPackageId = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _startedSub?.cancel();
    _successSub?.cancel();
    _errorSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFBFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '充值金币',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _packages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无充值套餐',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '请检查网络连接后重试',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          _loadData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF1DBB),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '重新加载',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 金币余额卡片
                      _buildBalanceCard(),
                      const SizedBox(height: 32),
                      // 充值套餐
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '选择充值套餐',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildPackagesList(),
                            if (kDebugMode && IAPService.useMockPurchase) ...[
                              const SizedBox(height: 12),
                              _buildMockModeHint(),
                            ],
                            const SizedBox(height: 24),
                            _buildInstructions(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF1DBB),
            Color(0xFFFFB099),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF1DBB).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const CoinIcon(
              size: 32,
              coinColor: Color(0xFFFFC107),
              symbolColor: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '当前金币',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_currentCoins',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesList() {
    return Column(
      children: List.generate(_packages.length, (index) {
        final package = _packages[index];
        final isSelected = _selectedPackageId == package.id;
        final isProcessing = _isPurchasing && isSelected;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: _isPurchasing ? null : () => _purchasePackage(package),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF1DBB)
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 左侧：金币图标和数量
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC107).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const CoinIcon(
                            size: 24,
                            coinColor: Color(0xFFFFC107),
                            symbolColor: Colors.white,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${package.coins}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 中间：产品信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${package.coins} 金币',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (package.isHot)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF1DBB),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '热销',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '充值套餐',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 右侧：价格和选中指示
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isProcessing)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFFF1DBB),
                              ),
                            ),
                          )
                        else
                          Text(
                            package.price,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFF1DBB),
                            ),
                          ),
                        const SizedBox(height: 4),
                        if (isSelected && !isProcessing)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF1DBB),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '已选择',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMockModeHint() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFB74D)),
      ),
      child: const Text(
        '当前为模拟器本地购买模式，无需登录 Apple 账号，点击即可测试充值',
        style: TextStyle(fontSize: 12, color: Color(0xFFE65100), height: 1.4),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '充值说明',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildInstructionItem('充值后金币立即到账'),
          _buildInstructionItem('金币可用于发布动态'),
          _buildInstructionItem('发布一条动态消耗 10 金币'),
          _buildInstructionItem('金币不可转账或提现'),
          _buildInstructionItem('如有问题，请联系客服'),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IAPPackage {
  final String id;
  final String price;
  final int coins;
  final bool isHot;

  IAPPackage({
    required this.id,
    required this.price,
    required this.coins,
    this.isHot = false,
  });
}
