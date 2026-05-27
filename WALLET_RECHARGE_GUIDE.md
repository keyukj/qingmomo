# 🎨 钱包充值页面使用指南

## 📋 概述

全新设计的钱包充值页面，采用现代化 iOS 设计规范，提供精美的视觉体验和流畅的交互。

## ✨ 设计特点

### 视觉设计
- ✅ 白色背景，简洁清爽
- ✅ 主题色（粉红色 #FF1DBB）贯穿全页面
- ✅ 精心打磨的圆角（14-20px）
- ✅ 细腻的阴影效果
- ✅ 舒适的视觉比例和间距
- ✅ 贴近真实 iOS 设计规范

### 交互体验
- ✅ 套餐选中时的缩放动画
- ✅ 选中指示器（打勾图标）
- ✅ 热销标签突出显示
- ✅ 按钮状态反馈
- ✅ 充值成功提示

### 功能特性
- ✅ 9个充值选项（3x3 网格布局）
- ✅ 实时显示金币余额
- ✅ 充值金额与金币对应
- ✅ 充值确认对话框
- ✅ 充值说明和提示

## 🎯 充值套餐

| 价格 | 金币 | 说明 |
|------|------|------|
| ¥8 | 62 | 入门套餐 |
| ¥18 | 142 | 经济套餐 |
| ¥38 | 304 | 标准套餐 |
| ¥68 | 540 | 推荐套餐 |
| ¥98 | 770 | 优惠套餐 |
| ¥168 | 1350 | 高级套餐 |
| ¥268 | 2170 | 豪华套餐 |
| ¥398 | 3190 | 尊享套餐 |
| ¥888 | 7190 | 热销套餐 ⭐ |

## 📱 页面结构

```
┌─────────────────────────────────┐
│  ← 钱包充值                      │  ← AppBar
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────────┐│
│  │ 金币余额                    ││  ← 余额卡片
│  │ 💰 12345 可用金币           ││
│  └─────────────────────────────┘│
│                                 │
│  选择充值金额                   │
│  ┌──────┐ ┌──────┐ ┌──────┐   │
│  │ ¥8   │ │ ¥18  │ │ ¥38  │   │  ← 充值套餐网格
│  │ 62💰 │ │142💰 │ │304💰 │   │
│  └──────┘ └──────┘ └──────┘   │
│  ┌──────┐ ┌──────┐ ┌──────┐   │
│  │ ¥68  │ │ ¥98  │ │¥168  │   │
│  │540💰 │ │770💰 │ │1350💰│   │
│  └──────┘ └──────┘ └──────┘   │
│  ┌──────┐ ┌──────┐ ┌──────┐   │
│  │¥268  │ │¥398  │ │¥888⭐│   │
│  │2170💰│ │3190💰│ │7190💰│   │
│  └──────┘ └──────┘ └──────┘   │
│                                 │
│  ┌─────────────────────────────┐│
│  │    立即充值                 ││  ← 充值按钮
│  └─────────────────────────────┘│
│                                 │
│  充值说明                       │
│  ✓ 充值后金币立即到账           │
│  ✓ 金币可用于发布动态           │
│  ...                            │
│                                 │
└─────────────────────────────────┘
```

## 🚀 快速使用

### 1. 导入页面
```dart
import 'package:qingmooo/screens/wallet_recharge_screen.dart';
```

### 2. 打开页面
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const WalletRechargeScreen(),
  ),
);
```

### 3. 集成到个人资料页面
在 `profile_screen.dart` 中的金币卡片点击事件：
```dart
Future<void> _navigateToRecharge() async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const WalletRechargeScreen()),
  );
  
  if (mounted) {
    _loadUserData(); // 刷新金币
  }
}
```

## 🎨 设计细节

### 颜色方案
```dart
主题色:        Color(0xFFFF1DBB)  // 粉红色
辅助色:        Color(0xFFFFB099)  // 浅粉色
背景色:        Colors.white       // 白色
文字色:        Color(0xFF1A1A1A)  // 深灰色
辅助文字:      Color(0xFF999999)  // 浅灰色
```

### 圆角设计
```dart
AppBar:        0px (无圆角)
卡片:          16-20px
按钮:          14px
标签:          6-8px
```

### 间距设计
```dart
页面边距:      16px
卡片间距:      12px
元素间距:      8-12px
```

### 阴影设计
```dart
卡片阴影:      blurRadius: 8-12, offset: (0, 4)
按钮阴影:      blurRadius: 16, offset: (0, 8)
```

## 💡 交互细节

### 套餐选中动画
- 缩放比例: 95%（5% 缩小）
- 动画时长: 300ms
- 边框变色: 灰色 → 粉红色
- 阴影增强: 更明显的投影

### 按钮状态
- **未选中**: 半透明渐变，文字灰色
- **已选中**: 完整渐变，文字白色，有阴影

### 热销标签
- 仅在 ¥888 套餐显示
- 渐变背景，白色文字
- 位置: 卡片右上角

## 📝 代码示例

### 自定义充值套餐
```dart
final List<RechargePackage> _packages = [
  RechargePackage(id: '1', price: 8, coins: 62, bonus: 0),
  RechargePackage(id: '2', price: 18, coins: 142, bonus: 0),
  // ... 更多套餐
];
```

### 修改主题色
在 `_buildBalanceCard()` 中修改 `LinearGradient` 的颜色：
```dart
gradient: const LinearGradient(
  colors: [
    Color(0xFFYourColor1),
    Color(0xFFYourColor2),
  ],
),
```

### 自定义充值逻辑
在 `_confirmPurchase()` 中修改：
```dart
Future<void> _confirmPurchase(RechargePackage package) async {
  // 调用你的内购服务
  // await IAPService.purchaseProduct(package.id);
  
  // 或者调用金币服务
  await CoinService.addCoins(package.coins, reason: '充值 - ${package.price}元');
}
```

## 🔧 常见定制

### 1. 改变网格列数
```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,  // 改为 2 列
    // ...
  ),
)
```

### 2. 添加更多套餐
```dart
final List<RechargePackage> _packages = [
  // ... 现有套餐
  RechargePackage(id: '10', price: 1288, coins: 10000, bonus: 0, isHot: true),
];
```

### 3. 修改热销标签
```dart
if (package.isHot)
  Container(
    // ... 修改样式
    child: const Text('限时优惠'),  // 改为其他文字
  )
```

### 4. 改变动画效果
```dart
_animationController = AnimationController(
  duration: const Duration(milliseconds: 500),  // 改为 500ms
  vsync: this,
);
```

## 🎯 最佳实践

### 1. 性能优化
- 使用 `GridView.builder` 而不是 `GridView`
- 使用 `SingleChildScrollView` 而不是 `ListView`
- 避免在 `build` 中创建新对象

### 2. 用户体验
- 提供清晰的选中反馈
- 显示充值确认对话框
- 充值成功后刷新余额
- 提供充值说明和帮助

### 3. 可访问性
- 使用足够大的触摸区域（最小 44x44pt）
- 提供清晰的文字对比度
- 使用有意义的图标和标签

## 📱 响应式设计

页面在不同屏幕尺寸上的表现：

- **小屏幕 (< 375px)**: 3 列网格，间距 10px
- **中屏幕 (375-414px)**: 3 列网格，间距 12px
- **大屏幕 (> 414px)**: 3 列网格，间距 12px

## 🐛 常见问题

**Q: 如何修改充值后的逻辑？**
A: 修改 `_confirmPurchase()` 方法中的逻辑

**Q: 如何添加真实的内购支付？**
A: 在 `_confirmPurchase()` 中调用 `IAPService.purchaseProduct()`

**Q: 如何改变页面的主题色？**
A: 修改所有 `Color(0xFFFF1DBB)` 为你的主题色

**Q: 如何隐藏热销标签？**
A: 在 `RechargePackage` 中将 `isHot` 设为 `false`

## 📚 相关文件

- `lib/screens/wallet_recharge_screen.dart` - 钱包充值页面
- `lib/services/coin_service.dart` - 金币服务
- `lib/screens/profile_screen.dart` - 个人资料页面

## 🎉 总结

这个钱包充值页面提供了：
- ✅ 精美的视觉设计
- ✅ 流畅的交互体验
- ✅ 完整的功能实现
- ✅ 易于定制和扩展
- ✅ 遵循 iOS 设计规范

可以直接集成到项目中使用！
