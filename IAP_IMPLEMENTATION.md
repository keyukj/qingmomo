# 内购功能完整实现文档

## 功能概述

本项目实现了完整的内购（In-App Purchase）功能，包括：
- 金币系统管理
- 内购产品配置
- 发布动态消耗金币
- 充值功能
- 金币历史记录

## 核心功能说明

### 1. 金币系统 (CoinService)

**文件**: `lib/services/coin_service.dart`

#### 主要功能：
- **初始化**: 新用户默认赠送 30 金币
- **查询**: 获取当前金币数
- **消耗**: 发布动态消耗 10 金币
- **充值**: 通过内购增加金币
- **历史**: 记录所有金币变动

#### 关键方法：
```dart
// 获取当前金币
int coins = await CoinService.getCoins();

// 发布动态（自动消耗10金币）
bool success = await CoinService.publishPost();

// 检查是否可以发布
bool canPublish = await CoinService.canPublish();

// 手动消耗金币
bool success = await CoinService.consumeCoins(10, reason: '发布动态');

// 增加金币
await CoinService.addCoins(80, reason: '充值 - com.qingmo.icon8');

// 获取金币历史
List<Map<String, dynamic>> history = await CoinService.getCoinHistory();
```

### 2. 内购服务 (IAPService)

**文件**: `lib/services/iap_service.dart`

#### 产品配置：
```dart
static const Map<String, int> productCoins = {
  'com.qingmo.icon8': 80,      // 8元 -> 80金币
  'com.qingmo.icon18': 180,    // 18元 -> 180金币
  'com.qingmo.icon38': 380,    // 38元 -> 380金币
  'com.qingmo.icon68': 680,    // 68元 -> 680金币
  'com.qingmo.icon128': 1280,  // 128元 -> 1280金币
  'com.qingmo.icon268': 2680,  // 268元 -> 2680金币
};
```

#### 关键方法：
```dart
// 初始化内购
await IAPService.init();

// 获取所有产品
List<ProductDetails> products = IAPService.getProducts();

// 购买产品
await IAPService.purchaseProduct('com.qingmo.icon8');

// 监听购买成功
IAPService.onPurchaseSuccess((purchaseDetails) {
  // 处理购买成功
});

// 恢复购买
await IAPService.restorePurchases();
```

## 使用流程

### 1. 发布动态流程

```
用户点击发布
  ↓
检查金币是否足够 (>= 10)
  ↓
  ├─ 不足 → 显示充值提示
  │
  └─ 足够 → 上传内容
       ↓
    消耗10金币
       ↓
    发布成功
```

### 2. 充值流程

```
用户点击充值
  ↓
显示充值套餐列表
  ↓
用户选择套餐
  ↓
调用系统内购
  ↓
  ├─ 购买成功 → 添加金币
  │
  └─ 购买失败 → 显示错误
```

## 文件结构

```
lib/
├── services/
│   ├── coin_service.dart          # 金币管理服务
│   ├── iap_service.dart           # 内购服务
│   ├── storage_service.dart       # 存储服务（已更新）
│   └── ...
├── screens/
│   ├── publish_screen.dart        # 发布页面（已更新）
│   ├── profile_screen.dart        # 个人资料页面（已更新）
│   ├── recharge_screen.dart       # 充值页面（新增）
│   ├── coin_history_screen.dart   # 金币历史页面（新增）
│   └── ...
└── main.dart                      # 主文件（已更新）
```

## 数据存储

### SharedPreferences 键值：
- `user_coins`: 当前金币数 (int)
- `coin_history`: 金币历史记录 (StringList)

### 金币历史格式：
```
timestamp|reason|amount|type
例如: 2024-01-15T10:30:00.000Z|发布动态|-10|-1
```

## 集成步骤

### 1. 添加依赖
```yaml
dependencies:
  in_app_purchase: ^0.8.0
```

### 2. 初始化服务
在 `main.dart` 中：
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await CoinService.init();
  await IAPService.init();
  runApp(const QingmoooApp());
}
```

### 3. iOS 配置

在 `ios/Runner/Info.plist` 中添加：
```xml
<key>SKAdNetworkItems</key>
<array>
  <!-- Apple 的 SKAdNetwork 标识符 -->
</array>
```

在 Xcode 中：
1. 选择 Runner 项目
2. 选择 Runner target
3. 进入 Signing & Capabilities
4. 添加 "In-App Purchase" capability

### 4. Android 配置

在 `android/app/build.gradle` 中确保：
```gradle
dependencies {
    implementation 'com.android.billingclient:billing:6.0.0'
}
```

### 5. App Store 配置

1. 登录 App Store Connect
2. 进入应用
3. 功能 → 应用内购买
4. 添加产品：
   - 产品ID: `com.qingmo.icon8` 等
   - 产品类型: 消耗型
   - 价格: 对应金额
   - 描述: 金币套餐

### 6. Google Play 配置

1. 登录 Google Play Console
2. 进入应用
3. 获利 → 产品 → 应用内产品
4. 创建产品：
   - SKU: `com.qingmo.icon8` 等
   - 产品类型: 消耗型
   - 价格: 对应金额

## 测试

### 本地测试

```dart
// 测试金币消耗
await CoinService.consumeCoins(10);
int coins = await CoinService.getCoins(); // 应该减少10

// 测试金币增加
await CoinService.addCoins(80);
coins = await CoinService.getCoins(); // 应该增加80

// 测试历史记录
List<Map<String, dynamic>> history = await CoinService.getCoinHistory();
print(history); // 应该包含所有操作记录
```

### 沙箱测试

**iOS**:
1. 在 Settings → App Store 中登录测试账户
2. 进行购买测试

**Android**:
1. 在 Google Play Console 中添加测试账户
2. 在设备上登录测试账户
3. 进行购买测试

## 错误处理

### 常见问题

1. **内购不可用**
   - 检查设备是否支持内购
   - 检查网络连接
   - 检查 App Store/Google Play 配置

2. **购买失败**
   - 检查产品ID是否正确
   - 检查产品是否已在 App Store/Google Play 中发布
   - 检查支付方式是否有效

3. **金币未到账**
   - 检查 `_handleSuccessfulPurchase` 是否被调用
   - 检查 `CoinService.addCoins` 是否成功
   - 检查 SharedPreferences 是否正常工作

## 安全建议

1. **服务器验证**: 生产环境应在服务器端验证购买凭证
2. **防止重复购买**: 实现购买去重机制
3. **加密存储**: 敏感数据应加密存储
4. **日志记录**: 记录所有金币变动用于审计

## 扩展功能

### 可选功能

1. **金币商城**: 用金币购买虚拟物品
2. **签到赠送**: 每日签到赠送金币
3. **任务系统**: 完成任务赚取金币
4. **排行榜**: 基于金币消耗的排行
5. **礼物系统**: 用金币送礼物给其他用户

### 实现示例

```dart
// 签到赠送
Future<void> dailyCheckIn() async {
  final lastCheckIn = await StorageService.getLastCheckInDate();
  final today = DateTime.now();
  
  if (lastCheckIn.day != today.day) {
    await CoinService.addCoins(5, reason: '每日签到');
    await StorageService.setLastCheckInDate(today);
  }
}

// 任务完成
Future<void> completeTask(String taskId, int reward) async {
  await CoinService.addCoins(reward, reason: '完成任务: $taskId');
}
```

## 监控和分析

### 关键指标

1. **充值转化率**: 充值用户 / 总用户
2. **平均充值金额**: 总充值金额 / 充值用户数
3. **金币消耗率**: 消耗金币 / 拥有金币
4. **发布频率**: 发布动态数 / 用户数

### 数据收集

```dart
// 记录充值事件
void _trackPurchase(String productId, int coins) {
  // 发送到分析服务
  // analytics.logEvent(
  //   name: 'purchase',
  //   parameters: {
  //     'product_id': productId,
  //     'coins': coins,
  //   },
  // );
}

// 记录消耗事件
void _trackConsume(int amount, String reason) {
  // 发送到分析服务
  // analytics.logEvent(
  //   name: 'coin_consume',
  //   parameters: {
  //     'amount': amount,
  //     'reason': reason,
  //   },
  // );
}
```

## 常见问题 (FAQ)

**Q: 如何重置用户金币？**
A: 调用 `CoinService.clearCoinData()` 重置为默认值。

**Q: 如何导出金币历史？**
A: 调用 `CoinService.getCoinHistory()` 获取历史记录，然后导出为 CSV 或 JSON。

**Q: 如何实现金币转账？**
A: 需要服务器支持，在服务器端验证后调用 `CoinService.consumeCoins` 和 `CoinService.addCoins`。

**Q: 如何处理网络异常导致的购买失败？**
A: 实现重试机制，调用 `IAPService.restorePurchases()` 恢复未完成的购买。

## 参考资源

- [Flutter In-App Purchase 文档](https://pub.dev/packages/in_app_purchase)
- [App Store 内购指南](https://developer.apple.com/app-store/in-app-purchase/)
- [Google Play 内购指南](https://developer.android.com/google-play/billing)
- [SharedPreferences 文档](https://pub.dev/packages/shared_preferences)

## 版本历史

- v1.0.0 (2024-01-15): 初始版本
  - 基础金币系统
  - 内购功能
  - 发布动态消耗金币
  - 充值页面
  - 金币历史记录
