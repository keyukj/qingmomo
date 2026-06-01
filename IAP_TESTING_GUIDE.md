# IAP Testing Guide - App Store Resubmission

## Pre-Testing Setup

1. **Build the app** with the latest fixes:
   ```bash
   flutter clean
   flutter pub get
   flutter build ios --release
   ```

2. **Test on iPad Air 11-inch (M3)** - the exact device used in App Store review

3. **Use TestFlight** for realistic testing environment

## Test Scenarios

### Scenario 1: Successful Purchase Flow ✅
**Objective**: Verify purchase completes and coins are added

**Steps**:
1. Open the app and navigate to IAP screen
2. Tap on a package (e.g., ¥8.00 package)
3. Complete the purchase in App Store
4. Verify:
   - ✅ Green success snackbar appears with "成功充值 X 金币"
   - ✅ Coin balance updates immediately
   - ✅ UI is responsive (no freezing)
   - ✅ Can navigate away and back

**Expected Result**: Purchase completes within 2-3 seconds, coins appear in balance

---

### Scenario 2: Error Handling - Network Failure ❌
**Objective**: Verify error feedback when network fails

**Steps**:
1. Enable Airplane Mode on iPad
2. Open IAP screen
3. Tap on a package
4. Verify:
   - ✅ Red error snackbar appears
   - ✅ Error message is clear and helpful
   - ✅ Selected package is deselected
   - ✅ App remains responsive

**Expected Result**: Error dialog appears within 2 seconds, app doesn't freeze

---

### Scenario 3: Purchase Timeout ⏱️
**Objective**: Verify timeout mechanism works

**Steps**:
1. Simulate slow network (use Network Link Conditioner or throttle in Xcode)
2. Set network to very slow (e.g., 1 Mbps)
3. Tap on a package
4. Wait for 30+ seconds
5. Verify:
   - ✅ After ~30 seconds, timeout error appears
   - ✅ Error message: "购买超时，请重试"
   - ✅ App remains responsive
   - ✅ Can retry purchase

**Expected Result**: Timeout error appears after 30 seconds, user can retry

---

### Scenario 4: Repeated Purchases 🔄
**Objective**: Verify same package can be purchased multiple times

**Steps**:
1. Purchase ¥8.00 package
2. Verify coins are added
3. Purchase ¥8.00 package again
4. Verify:
   - ✅ Second purchase succeeds
   - ✅ Coins are added again (not skipped)
   - ✅ No "already processed" errors
   - ✅ Both transactions appear in history

**Expected Result**: Both purchases succeed, coins added twice

---

### Scenario 5: Navigation During Purchase 🔀
**Objective**: Verify callbacks work after navigation

**Steps**:
1. Open IAP screen
2. Tap on a package
3. Immediately navigate away (tap back button)
4. Wait for purchase to complete
5. Navigate back to IAP screen
6. Verify:
   - ✅ Success snackbar appears
   - ✅ Coin balance is updated
   - ✅ No duplicate snackbars
   - ✅ No callback stacking issues

**Expected Result**: Single success notification, coins updated correctly

---

### Scenario 6: Multiple Screen Visits 🔁
**Objective**: Verify no callback stacking with repeated visits

**Steps**:
1. Open IAP screen
2. Close it (navigate away)
3. Open IAP screen again
4. Close it
5. Open IAP screen again (3rd time)
6. Purchase a package
7. Verify:
   - ✅ Only ONE success snackbar appears
   - ✅ No duplicate notifications
   - ✅ Coins added only once
   - ✅ No memory leaks

**Expected Result**: Single notification, no stacking, clean memory

---

### Scenario 7: Concurrent Purchase Attempts 🚀
**Objective**: Verify race condition prevention

**Steps**:
1. Open IAP screen
2. Tap on package A
3. Immediately tap on package B (before A completes)
4. Verify:
   - ✅ Only one purchase processes
   - ✅ Other is queued or rejected gracefully
   - ✅ No duplicate coin additions
   - ✅ Clear error message if applicable

**Expected Result**: Only one purchase succeeds, no race conditions

---

### Scenario 8: App Backgrounding 📱
**Objective**: Verify purchase completes even if app is backgrounded

**Steps**:
1. Open IAP screen
2. Tap on a package
3. Immediately press home button (background app)
4. Wait 5 seconds
5. Bring app back to foreground
6. Verify:
   - ✅ Success snackbar appears
   - ✅ Coin balance is updated
   - ✅ Purchase completed successfully
   - ✅ No errors or crashes

**Expected Result**: Purchase completes in background, notification shows on return

---

### Scenario 9: Low Memory Conditions 💾
**Objective**: Verify app handles memory pressure

**Steps**:
1. Open multiple apps to reduce available memory
2. Open IAP screen
3. Purchase a package
4. Verify:
   - ✅ Purchase still completes
   - ✅ No crashes
   - ✅ Coins are added
   - ✅ Error handling works

**Expected Result**: Purchase succeeds even under memory pressure

---

### Scenario 10: Coin Balance Verification 💰
**Objective**: Verify coins are correctly persisted

**Steps**:
1. Note current coin balance
2. Purchase a package (e.g., 80 coins)
3. Verify balance increases by 80
4. Close app completely
5. Reopen app
6. Verify:
   - ✅ Coin balance is still increased
   - ✅ Coins are persisted correctly
   - ✅ No rollback occurred

**Expected Result**: Coins persist after app restart

---

## Performance Metrics to Monitor

| Metric | Target | Acceptable |
|--------|--------|-----------|
| Purchase Response Time | < 2 seconds | < 5 seconds |
| Error Notification Time | < 2 seconds | < 3 seconds |
| Timeout Detection | ~30 seconds | 25-35 seconds |
| Memory Usage | < 50 MB increase | < 100 MB increase |
| CPU Usage | < 30% | < 50% |
| Frame Rate | 60 FPS | > 30 FPS |

## Debugging Tips

### If Purchase Hangs:
1. Check network connectivity
2. Verify App Store credentials
3. Check device time is correct
4. Review console logs for errors
5. Try on different network (WiFi vs cellular)

### If Coins Don't Appear:
1. Check CoinService.addCoins() is called
2. Verify SharedPreferences is working
3. Check coin amount in productCoins map
4. Verify transaction ID is unique

### If Callbacks Don't Fire:
1. Verify `_callbacksRegistered` flag is working
2. Check IAPService.onPurchaseSuccess() is called
3. Verify callbacks aren't cleared prematurely
4. Check for exceptions in callback code

### If App Crashes:
1. Check for null pointer exceptions
2. Verify mounted check before setState()
3. Check for memory leaks in callbacks
4. Review crash logs in Xcode

## Regression Testing

After fixes, verify these still work:

- [ ] Coin consumption for posting (10 coins per post)
- [ ] Coin history tracking
- [ ] Purchase restoration
- [ ] App startup with IAP service
- [ ] Other in-app features not affected

## Sign-Off Checklist

Before resubmitting to App Store:

- [ ] All 10 scenarios pass
- [ ] No crashes or freezes observed
- [ ] Performance metrics within acceptable range
- [ ] Coins correctly added and persisted
- [ ] Error messages are clear and helpful
- [ ] UI remains responsive throughout
- [ ] No memory leaks detected
- [ ] Tested on iPad Air 11-inch (M3)
- [ ] Tested on both WiFi and cellular
- [ ] Tested with slow network conditions
- [ ] Tested with app backgrounding
- [ ] Regression tests pass

## Submission Notes for App Store

Include in submission comments:

```
Fixed critical IAP issue where app had no response after purchasing.

Changes made:
1. Fixed callback stacking that caused UI freezes
2. Added comprehensive error handling with user feedback
3. Implemented 30-second timeout for hung purchases
4. Improved transaction tracking to prevent race conditions
5. Added error callbacks for better user experience

Testing:
- Tested on iPad Air 11-inch (M3) - the device from review
- All purchase scenarios verified
- Error handling tested
- Performance verified
- No regressions detected

The app now responds immediately after purchase with clear feedback.
```

## Contact Support

If issues persist after these fixes:
1. Check App Store Connect for rejection details
2. Review device logs in Xcode
3. Test with TestFlight on multiple devices
4. Consider contacting Apple Developer Support
