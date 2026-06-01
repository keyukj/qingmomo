# Deployment Guide - App Store Resubmission

## Overview

This guide walks you through building, testing, and submitting the fixed IAP app to the App Store.

---

## Phase 1: Pre-Deployment Verification

### Step 1: Verify All Fixes Are Applied

```bash
# Check that the key files have been modified
git diff lib/services/iap_service.dart
git diff lib/screens/iap_screen.dart
```

**Expected Changes**:
- ✅ Error callback system added
- ✅ Timeout mechanism added
- ✅ Callback registration flag added
- ✅ Race condition prevention added

### Step 2: Verify No Compilation Errors

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Check for errors
flutter analyze
```

**Expected Output**:
```
No issues found!
```

### Step 3: Verify Documentation

```bash
# Check that all documentation files exist
ls -la | grep IAP
ls -la | grep SUBMISSION
ls -la | grep DEPLOYMENT
```

**Expected Files**:
- ✅ IAP_FIXES_APPLIED.md
- ✅ IAP_TESTING_GUIDE.md
- ✅ IAP_QUICK_FIX_SUMMARY.md
- ✅ IAP_FLOW_DIAGRAM.md
- ✅ APP_STORE_RESUBMISSION_READY.md
- ✅ SUBMISSION_CHECKLIST.txt
- ✅ IMPLEMENTATION_VERIFICATION.md
- ✅ DEPLOYMENT_GUIDE.md

---

## Phase 2: Local Testing

### Step 1: Build for iOS

```bash
# Build release version
flutter build ios --release

# Expected output:
# ✅ Building for iOS...
# ✅ Xcode build done.
# ✅ Built /path/to/build/ios/iphoneos/Runner.app
```

### Step 2: Test on Simulator

```bash
# Run on simulator
flutter run -d "iPad Air (5th generation)" --release

# Or use Xcode
open ios/Runner.xcworkspace
# Select iPad Air simulator
# Product → Run
```

**Test Scenarios** (from IAP_TESTING_GUIDE.md):
- [ ] Successful purchase
- [ ] Error handling
- [ ] Timeout mechanism
- [ ] Repeated purchases
- [ ] Navigation during purchase
- [ ] Multiple screen visits
- [ ] Concurrent purchases
- [ ] App backgrounding
- [ ] Low memory conditions
- [ ] Coin persistence

### Step 3: Test on Real Device

```bash
# Connect iPad Air 11-inch (M3)
flutter devices

# Run on device
flutter run -d <device-id> --release
```

**Critical**: Test on the exact device used in App Store review (iPad Air 11-inch M3)

---

## Phase 3: TestFlight Deployment

### Step 1: Archive the App

```bash
# Using Xcode
open ios/Runner.xcworkspace

# Or using command line
flutter build ios --release
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/Runner.xcarchive \
  archive
```

### Step 2: Export for App Store

```bash
# In Xcode:
# 1. Window → Organizer
# 2. Select the archive
# 3. Click "Distribute App"
# 4. Select "App Store Connect"
# 5. Follow the wizard
```

### Step 3: Upload to TestFlight

```bash
# The archive will be automatically uploaded to App Store Connect
# Or use Transporter:
xcrun altool --upload-app \
  -f "path/to/app.ipa" \
  -t ios \
  -u "your-apple-id@example.com" \
  -p "your-app-specific-password"
```

### Step 4: Test on TestFlight

1. **Add Testers**:
   - Go to App Store Connect
   - Select your app
   - Go to TestFlight
   - Add internal testers (your team)

2. **Install on iPad Air 11-inch (M3)**:
   - Open TestFlight app
   - Install the build
   - Test all scenarios

3. **Verify**:
   - [ ] Purchase succeeds
   - [ ] Coins added
   - [ ] No freezes
   - [ ] Error handling works
   - [ ] Timeout works
   - [ ] No crashes

---

## Phase 4: App Store Submission

### Step 1: Prepare Submission

```bash
# Update version number in pubspec.yaml
version: 1.0.2+4

# Update version in Xcode
# ios/Runner.xcodeproj/project.pbxproj
# MARKETING_VERSION = 1.0.2
# CURRENT_PROJECT_VERSION = 4
```

### Step 2: Create App Store Build

```bash
# Build for App Store
flutter build ios --release

# Archive
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/Runner.xcarchive \
  archive
```

### Step 3: Submit to App Store

**Using Xcode**:
1. Window → Organizer
2. Select the archive
3. Click "Distribute App"
4. Select "App Store Connect"
5. Select "Upload"
6. Follow the wizard

**Using Transporter**:
```bash
xcrun altool --upload-app \
  -f "path/to/app.ipa" \
  -t ios \
  -u "your-apple-id@example.com" \
  -p "your-app-specific-password"
```

### Step 4: Fill in App Store Connect

1. **Go to App Store Connect**
2. **Select your app**
3. **Go to "App Store" tab**
4. **Fill in the following**:

**Version Information**:
- Version: 1.0.2
- Build: 4

**What's New in This Version**:
```
Fixed critical issue where app had no response after purchasing IAP products.

Changes made:
1. Fixed callback stacking that caused UI freezes
2. Added comprehensive error handling with user feedback
3. Implemented 30-second timeout for hung purchases
4. Improved transaction tracking to prevent race conditions
5. Added error callbacks for better user experience

The app now responds immediately after purchase with clear feedback:
- Success: Green snackbar with coin amount
- Error: Red snackbar with error message
- Timeout: Error notification after 30 seconds

Testing:
- Tested on iPad Air 11-inch (M3) - the device from review
- All purchase scenarios verified
- Error handling tested
- Performance verified
- No regressions detected
```

**Submission Information**:
- Compliance: Select appropriate options
- Content Rating: Fill in questionnaire
- Advertising: Select if applicable

### Step 5: Submit for Review

1. **Click "Submit for Review"**
2. **Select "Automatic Release" or "Manual Release"**
3. **Confirm submission**

**Expected Review Time**: 24-48 hours

---

## Phase 5: Post-Submission Monitoring

### Step 1: Monitor Review Status

```bash
# Check status in App Store Connect
# 1. Go to App Store Connect
# 2. Select your app
# 3. Go to "App Store" tab
# 4. Check "Version Release" section
```

**Status Progression**:
- Waiting for Review (1-2 hours)
- In Review (24-48 hours)
- Ready for Sale (approved)
- Rejected (if issues found)

### Step 2: If Approved

1. **Release to App Store**:
   - If manual release: Click "Release This Version"
   - If automatic: App automatically released

2. **Monitor Downloads**:
   - Check App Store Connect analytics
   - Monitor crash reports
   - Track user reviews

3. **Monitor Feedback**:
   - Check App Store reviews
   - Monitor crash logs
   - Track error rates

### Step 3: If Rejected

1. **Read Rejection Details**:
   - Go to App Store Connect
   - Check rejection reason
   - Review Apple's feedback

2. **Fix Issues**:
   - Identify the problem
   - Apply fix
   - Test thoroughly

3. **Resubmit**:
   - Increment build number
   - Rebuild and archive
   - Submit again

---

## Troubleshooting

### Build Issues

**Issue**: "Xcode build failed"
```bash
# Solution: Clean and rebuild
flutter clean
flutter pub get
flutter build ios --release
```

**Issue**: "Pod install failed"
```bash
# Solution: Update pods
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter build ios --release
```

### Submission Issues

**Issue**: "Invalid provisioning profile"
- Solution: Check Apple Developer account
- Verify provisioning profiles are valid
- Renew if expired

**Issue**: "App rejected for IAP issues"
- Solution: Review rejection details
- Check IAP configuration in App Store Connect
- Verify product IDs match
- Retest and resubmit

### Runtime Issues

**Issue**: "Purchase doesn't complete"
- Solution: Check network connectivity
- Verify App Store credentials
- Check device time is correct
- Review console logs

**Issue**: "Coins not added"
- Solution: Check CoinService.addCoins()
- Verify SharedPreferences working
- Check coin amounts in productCoins map
- Review transaction logs

---

## Rollback Plan

If critical issues arise after submission:

### Step 1: Identify Issue
```bash
# Check crash logs in App Store Connect
# Check user reviews
# Monitor error rates
```

### Step 2: Fix Issue
```bash
# Identify root cause
# Apply targeted fix
# Test thoroughly
```

### Step 3: Resubmit
```bash
# Increment build number
# Rebuild and archive
# Submit new version
```

---

## Success Criteria

✅ **Build**: Compiles without errors
✅ **Test**: All scenarios pass
✅ **TestFlight**: Works on real device
✅ **Submission**: Accepted by App Store
✅ **Approval**: App approved within 48 hours
✅ **Release**: App available on App Store
✅ **Monitoring**: No crash reports
✅ **Feedback**: Positive user reviews

---

## Checklist

### Pre-Deployment
- [ ] All fixes applied
- [ ] No compilation errors
- [ ] Documentation complete
- [ ] Version number updated

### Testing
- [ ] Local testing passed
- [ ] Simulator testing passed
- [ ] Real device testing passed
- [ ] TestFlight testing passed

### Submission
- [ ] App Store Connect updated
- [ ] Version information filled
- [ ] What's New filled
- [ ] Submission information complete

### Post-Submission
- [ ] Review status monitored
- [ ] Approval received
- [ ] App released
- [ ] Monitoring active

---

## Timeline

| Phase | Duration | Status |
|-------|----------|--------|
| Pre-Deployment | 30 min | ✅ Ready |
| Local Testing | 1-2 hours | ✅ Ready |
| TestFlight | 2-4 hours | ✅ Ready |
| Submission | 5 min | ✅ Ready |
| App Store Review | 24-48 hours | ⏳ Pending |
| Release | 5 min | ⏳ Pending |
| Monitoring | Ongoing | ⏳ Pending |

---

## Support

If you encounter issues:

1. **Check Documentation**:
   - IAP_TESTING_GUIDE.md
   - IAP_FIXES_APPLIED.md
   - IMPLEMENTATION_VERIFICATION.md

2. **Review Logs**:
   - Xcode console logs
   - App Store Connect logs
   - Device crash logs

3. **Contact Support**:
   - Apple Developer Support
   - Flutter community
   - Your development team

---

## Final Notes

- **Test thoroughly** before submission
- **Use the exact device** from the review (iPad Air 11-inch M3)
- **Monitor closely** after approval
- **Be ready to fix** any issues quickly
- **Keep documentation** for future reference

---

## Sign-Off

**Status**: ✅ READY FOR DEPLOYMENT

**Date**: May 31, 2026
**Version**: 1.0.2 (4)
**Build**: iOS Release

All systems are ready for App Store submission.

**Next Step**: Follow Phase 1 to begin deployment.
