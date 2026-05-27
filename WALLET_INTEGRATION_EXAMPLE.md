# 🔗 钱包充值页面集成示例

## 快速集成

### 1. 在个人资料页面中使用

修改 `lib/screens/profile_screen.dart` 中的充值导航：

```dart
import 'package:qingmooo/screens/wallet_recharge_screen.dart';

// 在 _navigateToRecharge 方法中
Future<void> _navigateToRecharge() async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const WalletRechargeScreen(),
    ),
  );
  
  if (mounted) {
    _loadUserData(); // 刷新金币余额
  }
}
```

### 2. 在发布页面中使用

修改 `lib/screens/publish_screen.dart` 中的充值入口：

```dart
import 'package:qingmooo/screens/wallet_recharge_screen.dart';

// 在金币不足时显示充值入口
void _showInsufficientCoinsDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      // ... 对话框内容
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WalletRechargeScreen(),
              ),
            );
          },
          child: const Text('去充值'),
        ),
      ],
    ),
  );
}
```

### 3. 在主菜单中添加入口

在 `lib/screens/profile_screen.dart` 的菜单中添加钱包选项：

```dart
final menuItems = [
  {'icon': Icons.account_balance_wallet, 'color': const Color(0xFF000000), 'title': '我的钱包', 'hasArrow': true},
  // ... 其他菜单项
];

// 在 _buildMenuItem 中处理点击
if (title == '我的钱包') {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const WalletRechargeScreen()),
  );
}
```

## 完整示例代码

### 示例 1: 从个人资料页面打开

```dart
// profile_screen.dart
import 'package:qingmooo/screens/wallet_recharge_screen.dart';

class _ProfileScreenState extends State<ProfileScreen> {
  // ... 其他代码
  
  Future<void> _navigateToRecharge() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WalletRechargeScreen(),
      ),
    );
    
    // 返回后刷新金币
    if (mounted) {
      _loadUserData();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... AppBar 等
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 金币卡片 - 点击打开钱包充值
            GestureDetector(
              onTap: _navigateToRecharge,
              child: _buildCoinCard(),
            ),
            // ... 其他内容
          ],
        ),
      ),
    );
  }
}
```

### 示例 2: 从发布页面打开

```dart
// publish_screen.dart
import 'package:qingmooo/screens/wallet_recharge_screen.dart';

class _PublishScreenState extends State<PublishScreen> {
  // ... 其他代码
  
  void _showInsufficientCoinsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('金币不足'),
        content: Text('发布动态需要10金币，您当前有$_currentCoins金币。请先充值。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 打开钱包充值页面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WalletRechargeScreen(),
                ),
              );
            },
            child: const Text('去充值'),
          ),
        ],
      ),
    );
  }
}
```

### 示例 3: 自定义充值页面

```dart
// 创建自定义的钱包充值页面
class CustomWalletRechargeScreen extends WalletRechargeScreen {
  const CustomWalletRechargeScreen({super.key});
  
  @override
  State<CustomWalletRechargeScreen> createState() => _CustomWalletRechargeScreenState();
}

class _CustomWalletRechargeScreenState extends State<CustomWalletRechargeScreen> {
  // 自定义充值套餐
  @override
  void initState() {
    super.initState();
    // 修改充值套餐
    _packages = [
      RechargePackage(id: '1', price: 6, coins: 50, bonus: 0),
      RechargePackage(id: '2', price: 12, coins: 120, bonus: 0),
      // ... 更多自定义套餐
    ];
  }
}
```

## 高级用法

### 1. 监听充值完成

```dart
// 在充值页面返回时获取结果
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const WalletRechargeScreen(),
  ),
);

if (result == true) {
  // 充值成功，刷新数据
  _loadUserData();
}
```

### 2. 自定义充值逻辑

修改 `wallet_recharge_screen.dart` 中的 `_confirmPurchase` 方法：

```dart
Future<void> _confirmPurchase(RechargePackage package) async {
  try {
    // 调用真实的内购服务
    await IAPService.purchaseProduct('com.qingmo.icon${package.price}');
    
    // 或者调用自定义的支付服务
    // await PaymentService.pay(package.price);
    
    // 充值成功后添加金币
    await CoinService.addCoins(
      package.coins,
      reason: '充值 - ${package.price}元',
    );
    
    // 刷新金币
    await _loadCoins();
    
    // 显示成功提示
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('成功充值 ${package.coins} 金币'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    // 处理错误
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('充值失败: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

### 3. 添加分析追踪

```dart
void _selectPackage(String packageId) {
  setState(() {
    _selectedPackageId = packageId;
  });
  
  // 追踪用户选择
  // analytics.logEvent(
  //   name: 'recharge_package_selected',
  //   parameters: {
  //     'package_id': packageId,
  //     'price': _packages.firstWhere((p) => p.id == packageId).price,
  //   },
  // );
}

void _purchase() {
  // 追踪用户点击充值
  // analytics.logEvent(
  //   name: 'recharge_button_clicked',
  //   parameters: {
  //     'package_id': _selectedPackageId,
  //   },
  // );
}
```

## 样式定制

### 1. 改变主题色

```dart
// 在 wallet_recharge_screen.dart 中
const Color primaryColor = Color(0xFFFF1DBB);
const Color secondaryColor = Color(0xFFFFB099);

// 然后在所有地方使用这些常量
gradient: LinearGradient(
  colors: [primaryColor, secondaryColor],
),
```

### 2. 改变字体

```dart
// 在 _buildBalanceCard 中
Text(
  '$_currentCoins',
  style: const TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    fontFamily: 'YourCustomFont',  // 使用自定义字体
  ),
)
```

### 3. 改变布局

```dart
// 改为 2 列网格
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,  // 改为 2 列
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
)
```

## 测试

### 单元测试

```dart
void main() {
  group('WalletRechargeScreen', () {
    testWidgets('显示金币余额', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WalletRechargeScreen(),
        ),
      );
      
      expect(find.text('金币余额'), findsOneWidget);
    });
    
    testWidgets('选中套餐后启用充值按钮', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WalletRechargeScreen(),
        ),
      );
      
      // 点击第一个套餐
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      
      // 验证充值按钮已启用
      expect(find.text('立即充值'), findsOneWidget);
    });
  });
}
```

### 集成测试

```dart
void main() {
  group('钱包充值流程', () {
    testWidgets('完整的充值流程', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      // 打开个人资料页面
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      
      // 点击金币卡片打开钱包
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      
      // 验证钱包页面已打开
      expect(find.text('钱包充值'), findsOneWidget);
      
      // 选择套餐
      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pumpAndSettle();
      
      // 点击充值按钮
      await tester.tap(find.text('立即充值'));
      await tester.pumpAndSettle();
      
      // 验证确认对话框
      expect(find.text('确认充值'), findsOneWidget);
    });
  });
}
```

## 常见问题

**Q: 如何在充值后自动返回？**
A: 在 `_confirmPurchase` 中添加 `Navigator.pop(context, true);`

**Q: 如何禁用某个套餐？**
A: 在 `_buildPackageCard` 中添加条件判断

**Q: 如何添加优惠券功能？**
A: 在 `RechargePackage` 中添加 `discount` 字段

**Q: 如何支持多种支付方式？**
A: 在 `_confirmPurchase` 中添加支付方式选择

## 总结

这个集成示例展示了如何：
- ✅ 在不同页面中打开钱包充值
- ✅ 处理充值完成后的逻辑
- ✅ 自定义充值页面
- ✅ 添加分析追踪
- ✅ 进行测试验证

可以根据实际需求进行调整和扩展！
