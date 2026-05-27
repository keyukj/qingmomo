# 金币图标更新总结

## 更新内容

### 1. 新的金币图标设计
- **文件**: `lib/widgets/coin_icon.dart`
- **设计**: 圆形黄色硬币，中间带白色¥符号
- **特性**:
  - 支持自定义硬币颜色和符号颜色
  - 支持3D效果（阴影和高光）
  - 可配置大小

### 2. 更新的屏幕
以下屏幕已更新为使用新的 `CoinIcon` 组件：

#### a. `lib/screens/wallet_recharge_screen.dart`
- 金币余额卡片中的图标
- 充值套餐中的金币图标

#### b. `lib/screens/recharge_screen.dart`
- 当前金币显示中的图标
- 充值套餐中的金币图标

#### c. `lib/screens/publish_screen.dart`
- 发布屏幕顶部的金币余额显示

#### d. `lib/screens/profile_screen.dart`
- 个人资料页面的金币余额显示

### 3. 新的内购屏幕
- **文件**: `lib/screens/iap_screen.dart`
- **功能**: 使用真实的 IAP 产品ID进行充值
- **产品ID**:
  - `com.qingmo.icon8`: 8元 → 80金币
  - `com.qingmo.icon18`: 18元 → 180金币
  - `com.qingmo.icon38`: 38元 → 380金币
  - `com.qingmo.icon68`: 68元 → 680金币
  - `com.qingmo.icon128`: 128元 → 1280金币
  - `com.qingmo.icon268`: 268元 → 2680金币（热销）

### 4. IAP 服务更新
- **文件**: `lib/services/iap_service.dart`
- **更新**: 产品ID和金币数量已更新为正确的映射

### 5. 导航更新
- `profile_screen.dart` 中的充值按钮现在导航到新的 `IAPScreen`

## 金币图标使用示例

```dart
// 基础使用
const CoinIcon(
  size: 24,
  coinColor: Color(0xFFFFC107),
  symbolColor: Colors.white,
)

// 白色硬币（用于渐变背景）
const CoinIcon(
  size: 28,
  coinColor: Colors.white,
  symbolColor: Colors.white,
)

// 禁用3D效果
const CoinIcon(
  size: 20,
  coinColor: Color(0xFFFFC107),
  symbolColor: Colors.white,
  show3D: false,
)
```

## 颜色配置

- **硬币颜色**: `Color(0xFFFFC107)` (金黄色)
- **符号颜色**: `Colors.white` (白色)
- **3D阴影**: `Color(0xFFD4A500)` (深黄色)

## 测试建议

1. 在 iOS 17 Pro Max 模拟器中运行应用
2. 检查所有屏幕中的金币图标显示
3. 测试内购流程（需要配置 App Store Connect）
4. 验证金币余额更新

## 文件清单

### 新增文件
- `lib/widgets/coin_icon.dart` - 金币图标组件
- `lib/screens/iap_screen.dart` - 内购屏幕

### 修改文件
- `lib/screens/wallet_recharge_screen.dart`
- `lib/screens/recharge_screen.dart`
- `lib/screens/publish_screen.dart`
- `lib/screens/profile_screen.dart`
- `lib/services/iap_service.dart`
