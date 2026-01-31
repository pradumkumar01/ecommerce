# 🚀 ShopHub Deployment Checklist

**Complete checklist for preparing ShopHub for production deployment across all platforms.**

---

## Pre-Deployment Phase

### Code Quality
- [ ] Run `flutter analyze` - All code issues resolved
- [ ] Run `dart format lib/` - Code formatted consistently
- [ ] Review console for warnings and errors
- [ ] Check null safety compliance
- [ ] Test all screens manually
- [ ] Test theme switching (light/dark)
- [ ] Test navigation flows
- [ ] Test form validation
- [ ] Test error handling

### Documentation
- [ ] Update version number in pubspec.yaml
- [ ] Update README.md with latest features
- [ ] Update CHANGELOG.md with new features
- [ ] Document all breaking changes
- [ ] Review inline code comments
- [ ] Update API documentation

### Testing
- [ ] Run all unit tests: `flutter test`
- [ ] Run all widget tests
- [ ] Manual end-to-end testing
- [ ] Test on minimum supported OS version
- [ ] Test on latest OS version
- [ ] Test on various screen sizes
- [ ] Test slow network conditions
- [ ] Test offline functionality
- [ ] Test app lifecycle (pause/resume)

### Performance
- [ ] Profile app with DevTools
- [ ] Check frame rates (60 FPS target)
- [ ] Monitor memory usage
- [ ] Check app launch time
- [ ] Optimize images
- [ ] Verify no memory leaks
- [ ] Test with large data sets

### Security
- [ ] Remove debug prints
- [ ] Remove test/dummy data
- [ ] Verify API endpoints are production
- [ ] Check authentication logic
- [ ] Verify no hardcoded secrets
- [ ] Enable ProGuard for Android
- [ ] Review permissions in manifests
- [ ] Implement certificate pinning (if needed)
- [ ] Verify HTTPS usage

### Configuration
- [ ] Update app version: `1.0.0`
- [ ] Update build number
- [ ] Update app name (if needed)
- [ ] Verify app icon is set
- [ ] Verify splash screen is set
- [ ] Update package name (if needed)
- [ ] Set correct privacy policy URL
- [ ] Set correct terms of service URL

---

## Android Deployment

### Build Configuration

```yaml
# Update pubspec.yaml
version: 1.0.0+1

# android/app/build.gradle.kts
android {
    compileSdk 34
    
    defaultConfig {
        applicationId "com.yourdomain.ecommerce"
        minSdkVersion 21      # Minimum Android 5.0
        targetSdkVersion 34   # Latest Android version
        versionCode 1
        versionName "1.0.0"
    }
}
```

### Pre-Release Checklist

- [ ] Update `android/app/build.gradle.kts`
  - [ ] Set correct applicationId
  - [ ] Update versionCode and versionName
  - [ ] Verify minSdkVersion (minimum 21)
  - [ ] Verify targetSdkVersion (latest)

- [ ] Update `android/app/src/main/AndroidManifest.xml`
  - [ ] Verify app label
  - [ ] Remove debuggable flag
  - [ ] Add required permissions only
  - [ ] Verify intent filters

- [ ] Update `android/app/src/main/kotlin/com/yourdomain/MainActivity.kt`
  - [ ] Ensure correct class name
  - [ ] Verify all platform channels

- [ ] Create signing configuration
  ```bash
  # Generate keystore (one time)
  keytool -genkey -v -keystore ~/ecommerce-keystore.jks \
    -keyalg RSA -keysize 2048 -validity 10000 -alias ecommerce
  ```

- [ ] Create `android/key.properties`
  ```properties
  storePassword=your_store_password
  keyPassword=your_key_password
  keyAlias=ecommerce
  storeFile=/absolute/path/to/ecommerce-keystore.jks
  ```

### Build Release APK

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/apk/release/app-release.apk
```

### Build Release AAB (Google Play)

```bash
# Build App Bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### Google Play Setup

- [ ] Create Google Play Developer account
- [ ] Create app listing
- [ ] Add app icon (512x512)
- [ ] Add screenshots (4+ images)
- [ ] Write compelling description
- [ ] Set content rating questionnaire
- [ ] Set privacy policy
- [ ] Set app category
- [ ] Set target audience
- [ ] Review all store listing details

### Google Play Release

- [ ] Upload AAB to Internal Testing track
- [ ] Test on internal testing devices
- [ ] Upload to Closed Testing track
- [ ] Invite beta testers
- [ ] Collect feedback (min 7 days)
- [ ] Upload to Production
- [ ] Review and publish
- [ ] Monitor crash reports
- [ ] Monitor ratings and reviews

---

## iOS Deployment

### Build Configuration

```yaml
# Update ios/Podfile
platform :ios, '12.0'  # Minimum iOS 12.0
```

### Pre-Release Checklist

- [ ] Update `ios/Runner/Info.plist`
  - [ ] Verify bundle identifier
  - [ ] Update version number
  - [ ] Update build number
  - [ ] Remove debug settings
  - [ ] Add required permissions descriptions

- [ ] Update `ios/Runner.xcodeproj`
  - [ ] Set correct Team ID
  - [ ] Set correct bundle identifier
  - [ ] Set correct version
  - [ ] Set correct build number
  - [ ] Enable signing

- [ ] Create app icon
  - [ ] Use AppIcon set generator
  - [ ] Verify all sizes
  - [ ] Update in Xcode

- [ ] Create launch image/splash screen
  - [ ] Create LaunchScreen.storyboard
  - [ ] Add to all resolutions

- [ ] Set up certificates and profiles
  ```bash
  # Use Xcode to generate certificates
  # In Xcode: Xcode > Settings > Accounts > Manage Certificates
  ```

### Build Release

```bash
# Build iOS release
flutter build ios --release

# Output: build/ios/iphoneos/Runner.app
```

### Archive and Upload

```bash
# Archive using Xcode
flutter build ios --release

# Then in Xcode:
# 1. Product > Archive
# 2. Organizer > Distribute App
# 3. Select App Store Connect
# 4. Upload
```

### App Store Setup

- [ ] Create Apple Developer account
- [ ] Create app on App Store Connect
- [ ] Add app information
- [ ] Upload screenshots (2+, for each device)
- [ ] Write compelling description
- [ ] Set privacy policy URL
- [ ] Set support URL
- [ ] Set category
- [ ] Add keywords
- [ ] Set rating

### App Store Review

- [ ] Submit for review
- [ ] Monitor review status
- [ ] Respond to any review issues
- [ ] Add release notes
- [ ] Set release date
- [ ] Monitor crash reports

---

## Web Deployment

### Build Configuration

```bash
# Build web release
flutter build web --release

# Output: build/web/
```

### Pre-Release Checklist

- [ ] Optimize for web
  - [ ] Update `web/index.html`
  - [ ] Add SEO meta tags
  - [ ] Add manifest
  - [ ] Enable service worker

- [ ] Test on various browsers
  - [ ] Chrome
  - [ ] Firefox
  - [ ] Safari
  - [ ] Edge

- [ ] Verify responsive design
  - [ ] Mobile (320px - 480px)
  - [ ] Tablet (768px - 1024px)
  - [ ] Desktop (1920px+)

- [ ] Performance optimization
  - [ ] Minify assets
  - [ ] Enable gzip compression
  - [ ] Set cache headers

### Deployment Options

#### Option 1: Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Initialize Firebase
firebase init hosting

# Deploy
firebase deploy --only hosting
```

#### Option 2: Netlify

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy
netlify deploy --prod --dir build/web
```

#### Option 3: AWS S3 + CloudFront

```bash
# Upload to S3
aws s3 sync build/web s3://your-bucket-name --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation --distribution-id YOUR_ID --paths "/*"
```

---

## Windows Desktop Deployment

### Build Configuration

```bash
# Build Windows release
flutter build windows --release

# Output: build/windows/runner/Release/
```

### Pre-Release Checklist

- [ ] Update version in `windows/runner/runner.rc`
- [ ] Create installer (MSIX)
- [ ] Sign executable
- [ ] Test on Windows 10 and 11
- [ ] Verify all DLLs included

### Create MSIX Installer

```bash
# Create MSIX package
flutter pub get
flutter build windows --release --msix

# Output: build/windows/x64/runner/Release/ecommerce-1.0.0+1.msix
```

---

## macOS Desktop Deployment

### Build Configuration

```bash
# Build macOS release
flutter build macos --release

# Output: build/macos/Build/Products/Release/ecommerce.app
```

### Pre-Release Checklist

- [ ] Code sign application
- [ ] Create DMG installer
- [ ] Notarize with Apple
- [ ] Test on Intel and Apple Silicon

### Notarization (Required for App Store)

```bash
# Create DMG
hdiutil create -volname ecommerce -srcfolder build/macos/Build/Products/Release/ecommerce.app -ov -format UDZO ecommerce.dmg

# Notarize
xcrun altool --notarize-app --type osx --file ecommerce.dmg \
  --primary-bundle-id com.yourdomain.ecommerce \
  --username your-apple-id --password your-password
```

---

## Linux Desktop Deployment

### Build Configuration

```bash
# Build Linux release
flutter build linux --release

# Output: build/linux/x64/release/bundle/
```

### Pre-Release Checklist

- [ ] Create AppImage
- [ ] Create Snap package
- [ ] Create DEB package
- [ ] Test on various Linux distributions

### Create AppImage

```bash
# Install linuxdeploy
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

# Create AppImage
./linuxdeploy-x86_64.AppImage --appdir AppDir -e build/linux/x64/release/bundle/ecommerce
```

---

## Post-Deployment Phase

### Monitoring

- [ ] Set up crash reporting (Firebase Crashlytics)
- [ ] Monitor app analytics
- [ ] Monitor user feedback
- [ ] Monitor ratings and reviews
- [ ] Monitor download numbers
- [ ] Monitor user retention

### Support

- [ ] Create support email
- [ ] Set up help desk (if needed)
- [ ] Create FAQ document
- [ ] Respond to user feedback
- [ ] Address critical bugs immediately

### Updates

- [ ] Monitor for bugs
- [ ] Plan next version features
- [ ] Create maintenance schedule
- [ ] Plan security updates
- [ ] Keep dependencies updated

---

## Release Notes Template

```markdown
# Version 1.0.0 Release Notes

## 🎉 New Features
- Feature 1 description
- Feature 2 description
- Feature 3 description

## 🐛 Bug Fixes
- Bug 1 fixed
- Bug 2 fixed

## 🚀 Performance Improvements
- Improvement 1
- Improvement 2

## ⚠️ Breaking Changes
- Change 1 (if any)

## 🙏 Thank You
Thank you for using ShopHub!
```

---

## Version Numbering

Use Semantic Versioning: `MAJOR.MINOR.PATCH+BUILD`

Examples:
- `1.0.0+1` - First release
- `1.1.0+2` - New features added
- `1.1.1+3` - Bug fix
- `2.0.0+4` - Major changes/breaking changes

---

## Essential Checklists

### Before Every Release
- [ ] Update version number
- [ ] Run all tests
- [ ] Check performance
- [ ] Review security
- [ ] Test on actual devices
- [ ] Write release notes
- [ ] Update documentation

### Release Week
- [ ] Notify stakeholders
- [ ] Prepare support team
- [ ] Monitor social media
- [ ] Be ready for urgent issues
- [ ] Have rollback plan

### After Release
- [ ] Monitor crash reports
- [ ] Read user reviews
- [ ] Track download numbers
- [ ] Collect analytics
- [ ] Plan next version
- [ ] Celebrate! 🎉

---

## Common Issues & Solutions

### Issue: Build fails with gradle error
**Solution**: 
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter build apk --release
```

### Issue: App crashes on startup
**Solution**:
- Check logcat: `flutter logs`
- Verify all dependencies installed
- Check main.dart onInit() methods
- Verify API endpoints correct

### Issue: High crash rate after release
**Solution**:
- Roll back to previous version if needed
- Fix issue immediately
- Test thoroughly before re-release
- Monitor crash reports closely

### Issue: Poor ratings
**Solution**:
- Respond to negative reviews
- Fix reported issues quickly
- Release updates with fixes
- Monitor user feedback

---

## Resources

- [Flutter Build Docs](https://flutter.dev/docs/deployment)
- [Android App Release](https://developer.android.com/distribute)
- [iOS App Distribution](https://developer.apple.com/distribute)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)

---

## Deployment Metrics

Track these metrics for each release:

| Metric | Target | Current |
|--------|--------|---------|
| Crash Rate | < 0.5% | _____ |
| User Rating | > 4.0 ⭐ | _____ |
| Download Count | Growth trend | _____ |
| User Retention (Day 1) | > 40% | _____ |
| User Retention (Day 7) | > 15% | _____ |
| Avg Session Duration | > 5 min | _____ |

---

**Ready for production deployment! 🚀**

Follow this checklist to ensure a smooth release. When in doubt, be conservative and test more thoroughly.
