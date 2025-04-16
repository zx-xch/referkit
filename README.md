# 📦 ReferKit – iOS Affiliate Attribution SDK

**ReferKit** is a lightweight Swift SDK that enables iOS developers to track affiliate-driven installs and in-app purchases — without writing their own backend.

It integrates seamlessly with [Superwall](https://www.superwall.com/) and supports dynamic pricing attribution.

---

## ✨ Features

- ✅ Match installs to affiliate referral links
- ✅ Attribute in-app purchases to the correct affiliate
- ✅ Automatically pull real-time purchase price from Superwall
- ✅ Store and access matched affiliate code locally
- ✅ Easy integration via Swift Package Manager

---

## ⚡ Installation

### Swift Package Manager (SPM)

1. In Xcode, go to:
File → Add Packages...

2. Enter the URL of this repository:
https://github.com/zx-xch/referkit

3. Choose `main` or latest tagged version.

---

## 🛠️ Setup

### 1. **Configure the SDK**

Call this once, typically in your `AppDelegate` or `SceneDelegate`:

```swift
ReferKit.configure(apiKey: "YOUR_API_KEY")
```
### 2. **Match Affiliate on First Launch**
Call this once after app launch:

```swift
ReferKit.matchAffiliate { affiliateCode in
    print("Matched affiliate:", affiliateCode ?? "none")
}
```
### 3. **Track Purchases (Superwall Integration)**
Implement Superwall's SuperwallDelegate:

```swift
func didPurchaseProduct(_ product: StoreProduct, paywallInfo: PaywallInfo?) {
    ReferKit.trackPurchase(
        amount: product.price.doubleValue,
        currency: product.currencyCode,
        productId: product.id
    )
}
```
### **🧠 Methods**

```swift
ReferKit.configure(apiKey:)
```
Initializes the SDK with your app-specific API key.

```swift
ReferKit.matchAffiliate(completion:)
```
Attempts to match the current device to an affiliate click and caches the result.

```swift
ReferKit.trackPurchase(...)
```
Tracks a purchase event, attributing it to the affiliate if matched.

```swift
ReferKit.getAffiliateCode()
```
Returns the cached affiliate code, if one has been matched.

### **🧪 Testing**
Use test affiliate links (e.g. /track?ref=ZACH123&appId=xyz)

Confirm installs are matched using logs or the ReferKit backend

Simulate purchases using Superwall sandbox mode

### **🔐 Security & Privacy**
No use of IDFA or PII

Attribution is based on IP and device metadata only

Local data is stored in UserDefaults

### **📄 License**
MIT License

### **💬 Questions?**
Open an issue or contact us at support@referlink.io.
