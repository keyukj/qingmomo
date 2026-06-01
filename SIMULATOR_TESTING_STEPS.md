# iOS Simulator IAP Testing - Step by Step

## Prerequisites

### 1. Sandbox Account Setup
- [ ] Create a sandbox tester account in App Store Connect
- [ ] Go to: App Store Connect → Users and Access → Sandbox Testers
- [ ] Create new sandbox account with:
  - Email: (use a test email)
  - Password: (strong password)
  - Name: (any name)
- [ ] Verify the account is active

### 2. App Configuration
- [ ] Bundle ID matches App Store Connect
- [ ] Product IDs are configured in App Store Connect:
  - com.qingmo.icon8
  - com.qingmo.icon18
  - com.qingmo.icon38
  - com.qingmo.icon68
  - com.qingmo.icon128
  - com.qingmo.icon268
- [ ] All products are set to "Consumable" type
- [ ] All products are "Ready to Submit" or "Active"

### 3. Simulator Setup
- [ ] iOS simulator is running (iOS 15 or later)
- [ ] Simulator has internet connectivity
- [ ] Simulator is signed out of any Apple accounts

---

## Testing Procedure

### Phase 1: Initial Setup (5 minutes)

#### Step 1.1: Clean Build
```bash
cd /Users/admin/Desktop/白包历史app/轻陌/qingmooo
flutter clean
flutter pub get
flutter run
```

**Expected Result:**
- App builds successfully
- App launches on simulator
- No compilation errors

#### Step 1.2: Verify IAP Screen
1. Navigate to the IAP/Recharge screen
2. Look for the coin balance display
3. Look for 6 coin packages

**Expected Result:**
- Current coin balance is displayed (e.g., "0")
- 6 packages are visible:
  - 8 coins - ¥8.00
  - 18 coins - ¥18.00
  - 38 coins - ¥38.00
  - 68 coins - ¥68.00
  - 128 coins - ¥128.00
  - 268 coins - ¥268.00 (marked as "热销" - hot sale)

**If packages are not visible:**
- Check network connectivity
- Verify product IDs in App Store Connect
- Rebuild app: `flutter clean && flutter pub get && flutter run`

---

### Phase 2: First Purchase Test (10 minutes)

#### Step 2.1: Initiate Purchase
1. Tap on the 8 coins package (¥8.00)
2. Observe the UI changes

**Expected Result:**
- Loading spinner appears
- Package is highlighted with pink border
- "已选择" (Selected) badge appears

#### Step 2.2: Enter Sandbox Credentials
1. App Store login dialog appears
2. Enter sandbox account email
3. Enter sandbox account password
4. Tap "Sign In"

**Expected Result:**
- Dialog closes
- Loading spinner continues
- No error messages

#### Step 2.3: Wait for Completion
1. Wait for purchase to complete
2. Observe the UI for 60+ seconds

**Expected Result (Success):**
- Loading spinner disappears
- Green success message appears: "成功充值 80 金币"
- Coin balance increases by 80
- Package selection is cleared

**Expected Result (Timeout):**
- After 60 seconds, red error message appears: "购买超时，请重试"
- Loading spinner disappears
- Package selection is cleared

---

### Phase 3: Repeat Purchase Test (5 minutes)

#### Step 3.1: Purchase Same Package Again
1. Tap on the 8 coins package again
2. Repeat the purchase process

**Expected Result:**
- Same as Phase 2
- Coin balance increases by another 80
- No duplicate transaction errors

---

### Phase 4: Different Package Test (5 minutes)

#### Step 4.1: Purchase Different Package
1. Tap on the 268 coins package (¥268.00)
2. Repeat the purchase process

**Expected Result:**
- Loading spinner appears
- Enter sandbox credentials
- After completion, coin balance increases by 268
- Success message shows "成功充值 268 金币"

---

### Phase 5: Error Handling Test (5 minutes)

#### Step 5.1: Cancel Purchase
1. Tap on a package
2. When login dialog appears, tap "Cancel"

**Expected Result:**
- Dialog closes
- Loading spinner disappears
- No error message (or "购买已取消" message)
- Coin balance unchanged

#### Step 5.2: Wrong Credentials
1. Tap on a package
2. Enter wrong password
3. Tap "Sign In"

**Expected Result:**
- Error message appears: "密码错误" or similar
- Can retry with correct credentials
- Coin balance unchanged

---

## Verification Checklist

### After Each Purchase
- [ ] Loading spinner appeared
- [ ] Sandbox login dialog appeared
- [ ] After entering credentials, loading spinner continued
- [ ] Either success or timeout message appeared
- [ ] Coin balance updated correctly
- [ ] No duplicate transactions

### Final Verification
- [ ] All 6 packages can be purchased
- [ ] Coin balance increases correctly for each purchase
- [ ] Success messages are clear and visible
- [ ] Error messages are helpful
- [ ] No crashes or exceptions
- [ ] App remains responsive

---

## Troubleshooting

### Issue: "暂无充值套餐" (No packages)

**Cause:** Products not loading from App Store

**Solution:**
1. Check simulator internet: Open Safari, try google.com
2. Verify product IDs in App Store Connect
3. Rebuild app:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
4. Restart simulator:
   ```bash
   xcrun simctl shutdown all
   xcrun simctl erase all
   # Then reopen simulator
   ```

### Issue: Loading spinner never completes

**Cause:** Purchase stream not receiving updates

**Solution:**
1. Restart simulator
2. Rebuild app
3. Try a different sandbox account
4. Check if IAP service is initialized in main.dart

### Issue: "购买超时" (Purchase timeout) after 60 seconds

**Cause:** Purchase stream didn't receive completion event

**Solution:**
1. Verify sandbox account is active in App Store Connect
2. Check simulator internet connectivity
3. Try a different sandbox account
4. Increase timeout to 120 seconds in iap_service.dart:
   ```dart
   static const int _purchaseTimeoutSeconds = 120;
   ```

### Issue: "产品不存在" (Product not found)

**Cause:** Product ID not found in App Store

**Solution:**
1. Verify product IDs in App Store Connect
2. Make sure app bundle ID matches
3. Rebuild app
4. Check if products are "Ready to Submit" or "Active"

### Issue: App crashes during purchase

**Cause:** Unhandled exception

**Solution:**
1. Check console logs for error messages
2. Check if CoinService is initialized
3. Check if IAP service is initialized
4. Rebuild app: `flutter clean && flutter pub get && flutter run`

---

## Console Logging

To see detailed logs, add this to `iap_service.dart`:

```dart
// In _handlePurchaseUpdate()
print('🔔 Purchase update: ${purchaseDetails.productID}');
print('   Status: ${purchaseDetails.status}');
print('   Transaction ID: ${purchaseDetails.purchaseID}');

// In _handleSuccessfulPurchase()
print('✅ Processing purchase: $transactionId');
print('   Product: $productId');
print('   Coins: $coins');

// In purchaseProduct()
print('🛒 Starting purchase for: $productId');
print('   Transaction ID: $transactionId');
```

Then run with:
```bash
flutter run -v
```

---

## Expected Timeline

| Phase | Duration | Status |
|-------|----------|--------|
| Clean Build | 2-3 min | ✅ |
| Verify Screen | 1-2 min | ✅ |
| First Purchase | 5-10 min | ⏳ |
| Repeat Purchase | 3-5 min | ⏳ |
| Different Package | 3-5 min | ⏳ |
| Error Handling | 3-5 min | ⏳ |
| **Total** | **20-30 min** | ⏳ |

---

## Success Criteria

✅ All 6 packages display correctly
✅ First purchase completes successfully
✅ Coin balance increases correctly
✅ Repeat purchases work
✅ Different packages work
✅ Error handling works
✅ No crashes or exceptions
✅ App remains responsive

---

## Next Steps After Testing

1. **If all tests pass:**
   - Build release version: `flutter build ios --release`
   - Test on real iPad Air 11-inch (M3)
   - Submit to App Store

2. **If tests fail:**
   - Check SIMULATOR_IAP_DEBUGGING.md
   - Review console logs
   - Try troubleshooting steps above
   - Contact support if needed

---

**Test Date:** _______________
**Tester Name:** _______________
**Result:** ✅ Pass / ❌ Fail

**Notes:**
_________________________________
_________________________________
_________________________________

---

**Last Updated:** June 1, 2026
**Status:** Ready for Testing
