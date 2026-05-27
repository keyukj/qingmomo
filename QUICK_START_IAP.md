# 内购功能快速开始指南

## 已实现的功能

✅ **金币系统**
- 新用户默认 30 金币
- 发布动态消耗 10 金币
- 金币充值功能
- 金币历史记录

✅ **内购配置**
- 6 个充值套餐（8元、18元、38元、68元、128元、268元）
- 充值金额与金币一一对应
- 自动添加金币到账

✅ **UI 集成**
- 发布页面显示当前金币
- 发布前检查金币是否足够
- 个人资料页面显示金币卡片
- 充值页面展示所有套餐

## 文件清单

### 新增文件
```
lib/services/
├── coin_service.dart          # 金币管理服务
└── iap_service.dart           # 内购服务

lib/screens/
├── recharge_screen.dart       # 充值页面
└── coin_history_screen.dart   # 金币历史页面（可选）
```

### 修改文件
```
lib/
├── main.dart                  # 添加初始化
├── services/storage_service.dart  # 更新清除逻辑
└── screens/
    ├── publish_screen.dart    # 添加金币消耗逻辑
    └── profile_screen.dart    # 添加金币卡片和充值入口
```

## 快速集成步骤

### 1. 添加依赖
```bash
flutter pub add in_app_purchase
```

或在 `pubspec.yaml` 中添加：
```yaml
dependencies:
  in_app_purchase: ^0.8.0
```

### 2. iOS 配置

**在 Xcode 中：**
1. 打开 `ios/Runner.xcworkspace`
2. 选择 Runner 项目
3. 选择 Runner target
4. 进入 Signing & Capabilities
5. 点击 "+ Capability"
6. 搜索并添加 "In-App Purchase"

**在 `ios/Runner/Info.plist` 中添加：**
```xml
<key>SKAdNetworkItems</key>
<array/>
```

### 3. Android 配置

**在 `android/app/build.gradle` 中确保有：**
```gradle
dependencies {
    implementation 'com.android.billingclient:billing:6.0.0'
}
```

### 4. App Store 配置

1. 登录 [App Store Connect](https://appstoreconnect.apple.com)
2. 选择你的应用
3. 进入 **功能** → **应用内购买**
4. 点击 **+** 添加产品

添加以下 6 个产品：

| 产品ID | 价格 | 金币 | 描述 |
|--------|------|------|------|
| com.qingmo.icon8 | ¥8 | 80 | 8元金币套餐 |
| com.qingmo.icon18 | ¥18 | 180 | 18元金币套餐 |
| com.qingmo.icon38 | ¥38 | 380 | 38元金币套餐 |
| com.qingmo.icon68 | ¥68 | 680 | 68元金币套餐 |
| com.qingmo.icon128 | ¥128 | 1280 | 128元金币套餐 |
| com.qingmo.icon268 | ¥268 | 2680 | 268元金币套餐 |

**配置步骤：**
1. 产品类型选择 **消耗型**
2. 输入产品ID（如 `com.qingmo.icon8`）
3. 设置价格为对应金额
4. 填写描述
5. 保存并提交审核

### 5. Google Play 配置

1. 登录 [Google Play Console](https://play.google.com/console)
2. 选择你的应用
3. 进入 **获利** → **产品** → **应用内产品**
4. 点击 **创建产品**

添加相同的 6 个产品（SKU 和 App Store 保持一致）

**配置步骤：**
1. 产品类型选择 **消耗型**
2. 输入 SKU（如 `com.qingmo.icon8`）
3. 设置价格为对应金额
4. 填写描述
5. 保存并激活

## 测试

### 本地测试（不需要真实支付）

```dart
// 测试金币消耗
await CoinService.consumeCoins(10);

// 测试金币增加
await CoinService.addCoins(80);

// 检查金币
int coins = await CoinService.getCoins();
print('当前金币: $coins');
```

### iOS 沙箱测试

1. 在 Settings → App Store 中登录测试账户
2. 打开应用
3. 进入充值页面
4. 选择套餐进行购买
5. 系统会提示输入密码（使用测试账户密码）
6. 购买完成后金币自动到账

### Android 沙箱测试

1. 在 Google Play Console 中添加测试账户
2. 在设备上登录测试账户
3. 打开应用
4. 进入充值页面
5. 选择套餐进行购买
6. 购买完成后金币自动到账

## 功能使用

### 发布动态流程

```
用户点击发布
  ↓
系统检查金币 (需要 >= 10)
  ↓
  ├─ 不足 → 显示充值提示
  │
  └─ 足够 → 上传内容
       ↓
    消耗 10 金币
       ↓
    发布成功
```

### 充值流程

```
用户点击个人资料页的金币卡片
  ↓
进入充值页面
  ↓
选择充值套餐
  ↓
调用系统内购
  ↓
  ├─ 购买成功 → 金币到账
  │
  └─ 购买失败 → 显示错误信息
```

## 常见问题

**Q: 如何查看金币历史？**
A: 可以导入 `coin_history_screen.dart` 并在个人资料页面添加入口。

**Q: 如何修改发布消耗的金币数？**
A: 在 `CoinService` 中修改 `_publishCost` 常量。

**Q: 如何修改新用户初始金币？**
A: 在 `CoinService` 中修改 `_defaultCoins` 常量。

**Q: 如何修改充值套餐？**
A: 在 `IAPService` 中修改 `productCoins` 和 `productIds`。

**Q: 购买失败怎么办？**
A: 检查：
1. 产品ID是否正确
2. 产品是否已在 App Store/Google Play 中发布
3. 网络连接是否正常
4. 支付方式是否有效

## 生产环境建议

1. **服务器验证**: 在服务器端验证购买凭证
2. **防止重复**: 实现购买去重机制
3. **加密存储**: 敏感数据应加密存储
4. **日志记录**: 记录所有金币变动用于审计
5. **错误处理**: 完善的错误处理和重试机制

## 相关文档

- 详细文档: `IAP_IMPLEMENTATION.md`
- Flutter 内购文档: https://pub.dev/packages/in_app_purchase
- App Store 指南: https://developer.apple.com/app-store/in-app-purchase/
- Google Play 指南: https://developer.android.com/google-play/billing

## 支持

如有问题，请参考：
1. `IAP_IMPLEMENTATION.md` 中的常见问题部分
2. 官方文档和指南
3. 检查日志输出中的错误信息
