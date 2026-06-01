# IAP Purchase Flow - Before & After

## BEFORE (Broken) ❌

```
┌─────────────────────────────────────────────────────────────┐
│                    User Opens IAP Screen                     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  _setupPurchaseListener()      │
        │  - Registers callback          │
        │  - Called in initState()       │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  User Taps Purchase Button     │
        │  - Sends purchase request      │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  App Store Processes Purchase  │
        │  - Validates payment           │
        │  - Completes transaction       │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  purchaseStream Listener       │
        │  - Receives purchase details   │
        │  - Calls _handlePurchaseUpdate │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  _handleSuccessfulPurchase()   │
        │  - Adds coins to balance       │
        │  - Triggers callback           │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  Callback Fires                │
        │  - Updates UI                  │
        │  - Shows snackbar              │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  User Navigates Away           │
        │  - dispose() called            │
        │  - clearPurchaseCallbacks()    │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  User Opens IAP Screen Again   │
        │  - initState() called again    │
        │  - _setupPurchaseListener()    │
        │  - REGISTERS ANOTHER CALLBACK! │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  Now 2 Callbacks Registered    │
        │  - Each purchase fires both    │
        │  - UI updates conflict         │
        │  - APP FREEZES! 🔴             │
        └────────────────────────────────┘
```

### Problems:
- ❌ Callbacks stack up on each visit
- ❌ Multiple callbacks fire simultaneously
- ❌ UI rebuild conflicts cause freeze
- ❌ No error handling
- ❌ No user feedback on errors
- ❌ No timeout mechanism

---

## AFTER (Fixed) ✅

```
┌─────────────────────────────────────────────────────────────┐
│                    User Opens IAP Screen                     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  _setupPurchaseListener()      │
        │  - Check _callbacksRegistered  │
        │  - If true: SKIP (prevent      │
        │    duplicate registration)     │
        │  - If false: Register once     │
        │  - Set _callbacksRegistered=   │
        │    true                        │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  Register Callbacks:           │
        │  - onPurchaseSuccess()         │
        │  - onPurchaseError()           │
        │  (Only once per screen)        │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  User Taps Purchase Button     │
        │  - Sends purchase request      │
        │  - Add to _processingTrans     │
        │  - Set 30-second timeout       │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  App Store Processes Purchase  │
        │  - Validates payment           │
        │  - Completes transaction       │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  purchaseStream Listener       │
        │  - Receives purchase details   │
        │  - Calls _handlePurchaseUpdate │
        │  - Check if already processing │
        │  - Prevent race conditions     │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  _handleSuccessfulPurchase()   │
        │  - Try: Add coins to balance   │
        │  - Catch: Call _notifyError()  │
        │  - Trigger callback            │
        │  - Remove from _processing     │
        └────────────────────────────────┘
                         │
                    ┌────┴────┐
                    │          │
                    ▼          ▼
        ┌──────────────────┐  ┌──────────────────┐
        │  SUCCESS PATH    │  │  ERROR PATH      │
        │  - Callback      │  │  - _notifyError()│
        │    fires once    │  │  - Error callback│
        │  - Shows green   │  │    fires         │
        │    snackbar      │  │  - Shows red     │
        │  - Updates coins │  │    snackbar      │
        │  - UI responsive │  │  - User sees     │
        │  - No freeze! ✅ │  │    error msg ✅  │
        └──────────────────┘  └──────────────────┘
                    │          │
                    └────┬─────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  User Navigates Away           │
        │  - dispose() called            │
        │  - clearAllCallbacks()         │
        │  - _callbacksRegistered=false  │
        │  - Clean up resources          │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  User Opens IAP Screen Again   │
        │  - initState() called again    │
        │  - _setupPurchaseListener()    │
        │  - Check _callbacksRegistered  │
        │  - It's false, so register     │
        │  - Set to true                 │
        │  - NO STACKING! ✅             │
        └────────────────────────────────┘
```

### Improvements:
- ✅ Callbacks registered only once
- ✅ Single callback fires per purchase
- ✅ No UI conflicts
- ✅ Comprehensive error handling
- ✅ User feedback on all outcomes
- ✅ 30-second timeout for hung purchases
- ✅ Race condition prevention
- ✅ App remains responsive

---

## Error Handling Flow

```
┌─────────────────────────────────────┐
│  Purchase Initiated                 │
└────────────┬────────────────────────┘
             │
             ▼
    ┌────────────────────┐
    │  Timeout Timer     │
    │  (30 seconds)      │
    └────────┬───────────┘
             │
    ┌────────┴──────────────────────────┐
    │                                   │
    ▼                                   ▼
┌──────────────────┐          ┌──────────────────┐
│  Purchase        │          │  Timeout         │
│  Completes       │          │  Expires         │
│  (< 30 sec)      │          │  (30 sec)        │
└────────┬─────────┘          └────────┬─────────┘
         │                             │
    ┌────┴──────────────────┐      ┌──┴──────────────┐
    │                       │      │                 │
    ▼                       ▼      ▼                 ▼
┌─────────┐          ┌──────────┐ ┌──────────────┐
│ SUCCESS │          │  ERROR   │ │ TIMEOUT      │
│         │          │          │ │              │
│ Coins   │          │ Network  │ │ Purchase     │
│ Added   │          │ Error    │ │ Hung         │
│         │          │ Invalid  │ │              │
│ Green   │          │ Product  │ │ Red          │
│ Snackbar│          │          │ │ Snackbar     │
│         │          │ Red      │ │              │
│ ✅      │          │ Snackbar │ │ ✅           │
└─────────┘          │          │ └──────────────┘
                     │ ✅       │
                     └──────────┘
```

---

## Transaction Tracking

```
Purchase Request
    │
    ▼
Add to _processingTransactions
    │
    ▼
Check if already processing
    │
    ├─ YES → Skip (prevent race condition)
    │
    └─ NO → Continue
         │
         ▼
    Add coins to balance
         │
    ┌────┴────┐
    │          │
    ▼          ▼
SUCCESS    ERROR
    │          │
    ▼          ▼
Add to      Remove from
_processed  _processing
Transactions
    │          │
    ▼          ▼
Remove from  Return
_processing  (user can retry)
    │
    ▼
Trigger callback
    │
    ▼
Complete purchase
```

---

## Key Differences

| Aspect | Before | After |
|--------|--------|-------|
| **Callback Registration** | Every visit | Once per screen |
| **Concurrent Callbacks** | Multiple | Single |
| **Error Handling** | Silent | User feedback |
| **Timeout** | None | 30 seconds |
| **Race Conditions** | Possible | Prevented |
| **User Feedback** | None | Immediate |
| **App Responsiveness** | Freezes | Responsive |
| **Error Messages** | None | Clear & helpful |

---

## Timeline Comparison

### Before (Broken)
```
0s   - User taps purchase
1s   - Request sent
2s   - [FREEZE - No feedback]
5s   - [Still frozen]
10s  - [Still frozen]
15s  - [Still frozen]
20s  - [Still frozen]
25s  - [Still frozen]
30s  - [Still frozen]
...  - [Eventually times out or completes silently]
```

### After (Fixed)
```
0s   - User taps purchase
1s   - Request sent
2s   - ✅ Success snackbar appears
       ✅ Coins updated
       ✅ App responsive
       
OR

0s   - User taps purchase
1s   - Request sent
2s   - ❌ Error snackbar appears
       ❌ Clear error message
       ❌ User can retry
       
OR

0s   - User taps purchase
1s   - Request sent
...
30s  - ⏱️ Timeout snackbar appears
       ⏱️ "购买超时，请重试"
       ⏱️ User can retry
```

---

## Summary

The fix transforms the IAP experience from:
- **Broken**: App freezes, no feedback, user confused
- **Fixed**: App responsive, clear feedback, user informed

All issues are now resolved and the app is ready for App Store resubmission.
