# 🔧 Project Context: [اسم المشروع]

> هذا الملف يحتوي على كل المعلومات المهمة اللازمة للعمل على المشروع.  
> **⚠️ هذا الملف لا يُرفع على Git** — أضفه في `.gitignore`.  
> يقرأه الـ Orchestrator وكل الـ Agents عند بدء أي عمل.

---

## 📌 معلومات المشروع الأساسية

| المفتاح | القيمة |
|---------|--------|
| اسم المشروع | [Project Name] |
| الـ Repository | [https://github.com/org/repo] |
| الـ Branch الرئيسي | `main` |
| الـ Branch للتطوير | `develop` |
| الإصدار الحالي | `1.0.0` |
| آخر تحديث | [YYYY-MM-DD] |

---

## 🖥️ السيرفرات

### Production Server
| المفتاح | القيمة |
|---------|--------|
| المزود | [DigitalOcean / AWS / Hetzner / etc.] |
| IP | [xxx.xxx.xxx.xxx] |
| OS | [Ubuntu 24.04 LTS] |
| User | [deploy] |
| SSH Port | [22] |
| SSH Key Path | [~/.ssh/project_key] |
| Web Server | [Nginx / Apache] |
| مسار التطبيق | [/var/www/app] |
| الدومين | [https://example.com] |
| SSL | [Let's Encrypt / Cloudflare] |

### Staging Server
| المفتاح | القيمة |
|---------|--------|
| IP | [xxx.xxx.xxx.xxx] |
| User | [deploy] |
| SSH Key Path | [~/.ssh/project_key_staging] |
| مسار التطبيق | [/var/www/app-staging] |
| الدومين | [https://staging.example.com] |

### أوامر الـ SSH
```bash
# Production
ssh -i ~/.ssh/project_key deploy@PROD_IP

# Staging
ssh -i ~/.ssh/project_key_staging deploy@STAGING_IP
```

---

## 🗄️ قواعد البيانات

### Production Database
| المفتاح | القيمة |
|---------|--------|
| النوع | [PostgreSQL 16 / MySQL 8] |
| Host | [localhost / xxx.xxx.xxx.xxx] |
| Port | [5432 / 3306] |
| Database | [app_production] |
| User | [app_user] |
| الـ Backup | [يومي — مسار: /backups/db/] |

### Staging Database
| المفتاح | القيمة |
|---------|--------|
| النوع | [PostgreSQL 16] |
| Host | [localhost] |
| Database | [app_staging] |
| User | [app_user] |

> **⚠️ كلمات المرور في ملف `.env` فقط — لا تكتبها هنا أبدًا.**

---

## 📱 التطبيقات (Mobile Apps)

### iOS App
| المفتاح | القيمة |
|---------|--------|
| Bundle ID | [com.company.appname] |
| App Store ID | [1234567890] |
| Apple Developer Account | [email@example.com] |
| Team ID | [ABCDEF1234] |
| الإصدار الحالي (Store) | [1.0.0] |
| Build Number الحالي | [1] |
| الحالة | [Live / In Review / Ready for Sale] |
| Certificates Path | [~/.appstore/certificates/] |
| Provisioning Profile | [~/Library/MobileDevice/Provisioning Profiles/] |
| App Store Connect | [https://appstoreconnect.apple.com] |

### Android App
| المفتاح | القيمة |
|---------|--------|
| Package Name | [com.company.appname] |
| Google Play Console | [https://play.google.com/console] |
| الإصدار الحالي (Store) | [1.0.0] |
| Version Code الحالي | [1] |
| الحالة | [Published / In Review / Draft] |
| Keystore Path | [~/.android/release.keystore] |
| Keystore Alias | [release-key] |
| Service Account JSON | [~/.gcloud/play-service-account.json] |

### أوامر البناء
```bash
# iOS
cd ios && pod install
npx react-native run-ios --configuration Release
# أو
flutter build ios --release

# Android
npx react-native run-android --variant=release
# أو
flutter build apk --release
flutter build appbundle --release
```

---

## 🔑 الخدمات الخارجية (Third-Party Services)

> **⚠️ لا تكتب API Keys أو Secrets هنا — استخدم `.env` فقط.**  
> سجّل هنا أسماء الخدمات وروابطها ومعلومات الحساب (بدون كلمات مرور).

| الخدمة | الغرض | Dashboard URL | الحساب | ملاحظات |
|--------|-------|---------------|--------|---------|
| [Stripe] | الدفع | [https://dashboard.stripe.com] | [email] | ENV: STRIPE_SECRET_KEY |
| [SendGrid] | الإيميلات | [https://app.sendgrid.com] | [email] | ENV: SENDGRID_API_KEY |
| [Cloudflare] | DNS + CDN | [https://dash.cloudflare.com] | [email] | - |
| [Sentry] | Error tracking | [https://sentry.io] | [email] | ENV: SENTRY_DSN |
| [Firebase] | Push Notifications | [https://console.firebase.google.com] | [email] | ENV: FIREBASE_CONFIG |
| [S3/Spaces] | File storage | [console url] | [email] | ENV: S3_BUCKET |

---

## 🌐 الدومينات و DNS

| الدومين | المسجّل | DNS Provider | SSL | انتهاء الصلاحية |
|---------|---------|-------------|-----|-----------------|
| [example.com] | [Namecheap] | [Cloudflare] | [Auto] | [YYYY-MM-DD] |
| [api.example.com] | [same] | [Cloudflare] | [Auto] | [same] |

---

## 🚀 أوامر الـ Deployment

### Production
```bash
# الطريقة 1: SSH مباشر
ssh -i ~/.ssh/project_key deploy@PROD_IP << 'EOF'
  cd /var/www/app
  git pull origin main
  npm install --production
  npm run build
  pm2 restart app
EOF

# الطريقة 2: CI/CD (لو موجود)
# يتم تلقائيًا عند push على branch main
```

### Staging
```bash
ssh -i ~/.ssh/project_key_staging deploy@STAGING_IP << 'EOF'
  cd /var/www/app-staging
  git pull origin develop
  npm install
  npm run build
  pm2 restart app-staging
EOF
```

### App Store Release
```bash
# iOS: بعد البناء
xcrun altool --upload-app -f "build/App.ipa" -t ios -u "email" -p "@keychain:AC_PASSWORD"

# Android: بعد البناء
# رفع AAB على Google Play Console يدويًا أو باستخدام fastlane
```

---

## 📋 Environment Variables المطلوبة

> هذه قائمة بكل المتغيرات المطلوبة في `.env` — **بدون القيم الفعلية**.

```env
# App
NODE_ENV=production
APP_URL=https://example.com
APP_PORT=3000

# Database
DATABASE_URL=postgresql://user:pass@host:5432/db

# Authentication
JWT_SECRET=
JWT_REFRESH_SECRET=
JWT_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d

# Email
SMTP_HOST=
SMTP_PORT=
SMTP_USER=
SMTP_PASS=

# Storage
S3_BUCKET=
S3_REGION=
S3_ACCESS_KEY=
S3_SECRET_KEY=

# Payment
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=

# Push Notifications
FIREBASE_PROJECT_ID=
FIREBASE_PRIVATE_KEY=
FIREBASE_CLIENT_EMAIL=

# Error Tracking
SENTRY_DSN=
```

---

## 📝 ملاحظات مهمة

- [أي ملاحظات خاصة بالمشروع]
- [قيود أو اعتبارات]
- [أشياء يجب تذكرها]

---

> **آخر تحديث:** [YYYY-MM-DD] بواسطة [الاسم]
