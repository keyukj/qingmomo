# iOS Simulator IAP Timeout Debugging Guide

## Problem Summary
On iOS simulator, after entering sandbox account credentials, the app shows a loading spinner for 60 seconds then displays "purchase timeout" error.

## Root Cause Analysis

The timeout occurs because the `purchaseStream` listener is not receiving the purchase completion event from the simulator's IAP system. This can happen due to:

1. **Product Loading Issue**: Products might not be loaded correctly before purchase attempt
2. **Stream Listener Issue**: The purchase stream listener might not be properly registered
3. **Sandbox Account Issue**: Sandbox account credentials might not be properly configured
4. **Network Issue**: Simulator might have network connectivity issues with Apple's sandbox servers

## Debugging Steps

### Step 1: Verify Products Are Loading

**What to check:**
- Products should load when the IAP screen opens
- Products should reload when user taps purchase

**How to verify:**
1. Open the IAP screen
2. Check if you see the 6 coin packages (8, 18, 38, 68, 128, 268)
3. If you see "暂无充值套餐" (No packages), products are not loading

**If products are not loading:**
- Check network connectivity on simulator
- Try restarting the simulator
- Try rebuilding the app: `flutter clean && flutter pub get && flutter run`

### Step 2: Verify Sandbox Account Configuration

**What to check:**
- Sandbox account credentials are correct
- Sandbox account is properly configured in App Store Connect

**How to verify:**
1. Go to App Store Connect → Users and Access → Sandbox Testers
2. Verify your sandbox account exists and is active
3. Try using a different sandbox account
4. Make sure the account email and password are correct

**Common issues:**
- Sandbox account not created yet
- Sandbox account disabled
- Wrong password entered
- Account needs to be verified

### Step 3: Check Purchase Stream Listener

**What to check:**
- Purchase stream listener is registered
- Listener is receiving purchase updates

**How to verify:**
1. Add debug logging to `_handlePurchaseUpdate()` method
2. Tap purchase and check console output
3. You should see logs like:
   - "Purchase status: pending" (when user enters credentials)
   - "Purchase status: purchased" (when purchase completes)

**If listener is not receiving updates:**
- Restart the simulator
- Rebuild the app
- Check if IAP service is properly initialized in main.dart

### Step 4: Check Product Details

**What to check:**
- Product details are correctly retrieved from App Store
- Product IDs match the ones configured in App Store Connect

**How to verify:**
1. Check the product IDs in `iap_service.dart`:
   ```dart
   static const List<String> productIds = [
     'com.qingmo.icon8',
     'com.qingmo.icon18',
     'com.qingmo.icon38',
     'com.qingmo.icon68',
     'com.qingmo.icon128',
     'com.qingmo.icon268',
   ];
   ```

2. Verify these product IDs are configured in App Store Connect
3. Make sure the app bundle ID matches the one in App Store Connect

### Step 5: Check Network Connectivity

**What to check:**
- Simulator has internet access
- Simulator can reach Apple's sandbox servers

**How to verify:**
1. Open Safari on simulator
2. Try to access a website (e.g., google.com)
3. If Safari can't load pages, simulator has no internet

**If simulator has no internet:**
- Check host machine's internet connection
- Restart simulator
- Try a different WiFi network

### Step 6: Check Timeout Settings

**Current timeout:** 60 seconds

**If timeout is too short:**
- Increase `_purchaseTimeoutSeconds` in `iap_service.dart`
- Try 120 seconds for debugging

**If timeout is too long:**
- Decrease `_purchaseTimeoutSeconds`
- Try 30 seconds for faster feedback

## Testing Checklist

### Before Testing
- [ ] Simulator is running
- [ ] App is built and running
- [ ] Network connectivity is working
- [ ] Sandbox account is created and active

### During Testing
- [ ] IAP screen shows 6 coin packages
- [ ] Tapping a package shows loading spinner
- [ ] After entering sandbox credentials, loading spinner continues
- [ ] After 60 seconds, either:
  - [ ] Success message appears and coins increase, OR
  - [ ] Timeout error appears

### After Testing
- [ ] Check console logs for errors
- [ ] Check if coins were added to balance
- [ ] Check if purchase history was recorded

## Common Issues and Solutions

### Issue 1: "暂无充值套餐" (No packages)
**Cause:** Products not loading from App Store
**Solution:**
1. Check network connectivity
2. Verify product IDs in App Store Connect
3. Rebuild app: `flutter clean && flutter pub get && flutter run`

### Issue 2: Loading spinner appears but never completes
**Cause:** Purchase stream listener not receiving updates
**Solution:**
1. Restart simulator
2. Rebuild app
3. Check if IAP service is initialized in main.dart

### Issue 3: "购买超时" (Purchase timeout) error
**Cause:** Purchase stream listener didn't receive completion event within 60 seconds
**Solution:**
1. Check sandbox account configuration
2. Check network connectivity
3. Try a different sandbox account
4. Increase timeout to 120 seconds for debugging

### Issue 4: "产品不存在" (Product not found) error
**Cause:** Product ID not found in App Store
**Solution:**
1. Verify product IDs in App Store Connect
2. Make sure app bundle ID matches
3. Rebuild app

## Advanced Debugging

### Enable Detailed Logging

Add this to `iap_service.dart` to see detailed logs:

```dart
// In _handlePurchaseUpdate()
print('Purchase update: ${purchaseDetails.productID}, status: ${purchaseDetails.status}');

// In _handleSuccessfulPurchase()
print('Processing purchase: $transactionId');

// In purchaseProduct()
print('Starting purchase for: $productId');
```

### Check Purchase Stream

Add this to `iap_screen.dart` to verify stream is working:

```dart
// In _setupPurchaseListener()
print('Purchase listener registered');

// In onPurchaseSuccess callback
print('Purchase success callback triggered');

// In onPurchaseError callback
print('Purchase error callback triggered: $errorMessage');
```

### Monitor Processing Transactions

Add this to `iap_service.dart` to track transaction state:

```dart
// In purchaseProduct()
print('Processing transactions: $_processingTransactions');

// In _handleSuccessfulPurchase()
print('Processed transactions: $_processedTransactions');
```

## Testing on Real Device

If simulator testing continues to fail, test on a real iPad:

1. Connect iPad to Mac
2. Select iPad as build target in Xcode
3. Build and run: `flutter run`
4. Use same sandbox account for testing
5. Monitor console logs for errors

## Next Steps

1. **Verify products load** - Check if 6 packages appear on IAP screen
2. **Test purchase flow** - Tap a package and enter sandbox credentials
3. **Monitor console logs** - Check for any error messages
4. **Check coin balance** - Verify coins are added after successful purchase
5. **Verify purchase history** - Check if purchase is recorded

## Support

If issues persist:
1. Check Flutter and Dart versions: `flutter --version`
2. Check in_app_purchase package version: `flutter pub outdated`
3. Try updating packages: `flutter pub upgrade`
4. Check App Store Connect configuration
5. Contact Apple support for sandbox issues

---

**Last Updated:** June 1, 2026
**Status:** Ready for Testing
