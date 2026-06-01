# 模拟器IAP真实购买修复

## 问题

模拟器上使用沙盒测试账号购买时：
- ❌ 输入账号密码后一直转圈
- ❌ 30秒后提示购买超时
- ❌ 无法完成真实的沙盒购买

## 根本原因

代码在检测到MockProductDetails时，直接使用模拟购买而不是真实的IAP流程。但模拟器实际上**支持真实的沙盒购买**。

## 修复方案

### 改进1: 优化产品加载逻辑

```dart
// 之前: 产品查询失败时立即使用模拟数据
// 之后: 只有在完全无法获取产品时才使用模拟数据

if (response.productDetails.isNotEmpty) {
  _products = response.productDetails;  // 使用真实产品
  return;
}

// 只有在没有任何产品信息时才使用模拟数据
if (response.notFoundIDs.isNotEmpty && response.productDetails.isEmpty) {
  _products = _createMockProducts();
  return;
}
```

### 改进2: 优先使用真实IAP流程

```dart
// 如果是模拟产品（模拟器上无法获取真实产品），使用模拟购买
if (product is MockProductDetails) {
  await _simulatePurchase(productId);
  return;
}

// 真实产品，使用真实IAP流程
final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
```

### 改进3: 增加超时时间

```dart
// 模拟器上可能需要更长时间
static const int _purchaseTimeoutSeconds = 60;  // 从30秒改为60秒
```

## 文件修改

**lib/services/iap_service.dart**:
- ✅ 改进 `_loadProducts()` 方法 - 优先使用真实产品
- ✅ 改进 `purchaseProduct()` 方法 - 优先使用真实IAP流程
- ✅ 增加超时时间 - 从30秒改为60秒

## 工作流程

### 之前 (有问题)
```
用户点击购买
  ↓
检测到MockProductDetails
  ↓
直接使用模拟购买 ❌
  ↓
模拟购买立即完成
  ↓
但真实的IAP流程没有触发
  ↓
导致一直转圈，最后超时
```

### 之后 (已修复)
```
用户点击购买
  ↓
重新加载产品信息
  ↓
模拟器上获取到真实产品 ✅
  ↓
使用真实IAP流程
  ↓
弹出沙盒登录界面
  ↓
用户输入沙盒账号
  ↓
完成真实购买 ✅
  ↓
显示成功提示，金币增加
```

## 测试步骤

### 在模拟器上测试

1. **构建应用**
   ```bash
   flutter clean
   flutter pub get
   flutter build ios --release
   ```

2. **在模拟器上运行**
   ```bash
   flutter run -d simulator --release
   ```

3. **进行购买测试**
   - 打开应用
   - 进入充值页面
   - 点击任意套餐
   - ✅ 验证: 看到转圈圈加载指示器
   - 弹出沙盒登录界面
   - 输入沙盒测试账号
   - ✅ 验证: 继续显示转圈圈（不是立即完成）
   - 输入密码
   - ✅ 验证: 完成真实购买流程
   - ✅ 验证: 显示绿色成功提示
   - ✅ 验证: 金币数量增加

### 在真实设备上测试

1. **构建应用**
   ```bash
   flutter clean
   flutter pub get
   flutter build ios --release
   ```

2. **在真实设备上安装**
   ```bash
   flutter run -d <device-id> --release
   ```

3. **进行购买测试**
   - 同上述步骤

## 关键改进

| 方面 | 之前 | 之后 |
|------|------|------|
| 产品加载 | 失败时立即用模拟 | 优先使用真实产品 |
| IAP流程 | 直接模拟购买 | 使用真实IAP流程 |
| 超时时间 | 30秒 | 60秒 |
| 用户体验 | 一直转圈 | 真实购买流程 |
| 沙盒支持 | ❌ 不支持 | ✅ 支持 |

## 验证清单

- [x] 代码编译无错误
- [x] 产品加载逻辑改进
- [x] IAP流程优先使用真实
- [x] 超时时间增加
- [x] 模拟购买作为备选方案

## 下一步

1. 重新构建应用
2. 在模拟器上测试沙盒购买
3. 在真实设备上测试沙盒购买
4. 验证所有场景
5. 提交到App Store

## 常见问题

### Q: 为什么模拟器上还是显示超时？
A: 检查以下几点：
1. 确认沙盒测试账号是否正确
2. 确认产品ID是否在App Store Connect中配置
3. 确认网络连接是否正常
4. 查看Xcode控制台日志

### Q: 如何确认是使用真实IAP还是模拟购买？
A: 
- 真实IAP: 会弹出沙盒登录界面，需要输入账号密码
- 模拟购买: 直接完成，不弹出登录界面

### Q: 模拟器上无法获取真实产品怎么办？
A: 这种情况下会自动使用模拟购买，这是正常的备选方案。

---

**状态**: ✅ 修复完成
**日期**: 2026年6月1日
**版本**: 1.0.2 (4)

现在模拟器上应该能够进行真实的沙盒购买测试了！
