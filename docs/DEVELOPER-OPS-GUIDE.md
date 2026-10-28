# 👨‍💻 دليل عمل المبرمجين — Developer Operations Guide

> **الهدف:** ضمان استمرارية العمل وحماية أصول الشركة  
> **القاعدة الذهبية:** لو مبرمج مشي النهارده، واحد تاني يقدر يكمل بكره  
> **مُعد بواسطة:** WebSTDY

---

## جدول المحتويات

1. [الروتين اليومي للمبرمج](#1-الروتين-اليومي-للمبرمج)
2. [الملفات الحساسة — أيه يترفع وأيه لا](#2-الملفات-الحساسة)
3. [نظام تسليم المشاريع — Handoff Protocol](#3-نظام-تسليم-المشاريع)
4. [خزنة المشروع — Project Vault](#4-خزنة-المشروع)
5. [سيناريوهات الطوارئ](#5-سيناريوهات-الطوارئ)

---

## 1. الروتين اليومي للمبرمج

### بداية اليوم (أول 10 دقائق)

```
1. git pull origin develop          ← جيب آخر التحديثات
2. اقرأ docs/PROJECT-TASKS.md       ← شوف المهام المطلوبة منك
3. اقرأ آخر 5 أحداث في PROJECT-LOG  ← اعرف أيه اللي حصل
4. ابدأ شغلك على branch جديد:
   git checkout -b feat/F-001-patient-crud
```

### قواعد الـ Branching

```
أنواع الـ Branches:
  feat/F-001-[وصف]     ← ميزة جديدة
  fix/B-001-[وصف]      ← إصلاح bug
  hotfix/[وصف]         ← إصلاح عاجل في production
  refactor/[وصف]       ← إعادة هيكلة
  chore/[وصف]          ← مهام صيانة

مثال:
  feat/F-003-appointment-booking
  fix/B-007-payment-race-condition
  hotfix/login-crash
```

### أثناء اليوم

```
✅ اعمل commit كل ما تنهي وحدة منطقية:
   git add .
   git commit -m "feat(patients): add create patient API with validation"

✅ شغّل الاختبارات قبل كل commit:
   pnpm test

✅ حدّث PROJECT-TASKS.md لو فيه تغيير في حالة المهام

✅ سجّل أي قرار مهم في PROJECT-LOG.md
```

### صيغة الـ Commit Messages

```
type(scope): message

أمثلة:
  feat(auth): add JWT refresh token endpoint
  fix(payment): handle race condition in order creation
  refactor(patients): extract validation to shared utility
  test(auth): add integration tests for login flow
  docs(api): document notification endpoints
  chore(deps): update prisma to 6.2.0
  style(dashboard): fix chart alignment on mobile
  perf(products): add database index on category_id
```

### نهاية اليوم — إلزامي (آخر 15 دقيقة)

```bash
# 1. تأكد إن كل التغييرات محفوظة
git status

# 2. اعمل commit لأي شغل متبقي (حتى لو مش كامل)
git add .
git commit -m "wip(F-003): appointment form - 70% complete

Done:
- API endpoints (GET, POST)
- Database migration
- Basic form component

Remaining:
- Calendar picker integration
- Validation messages
- Tests"

# 3. ارفع الـ branch
git push origin feat/F-003-appointment-booking

# 4. حدّث ملف التتبع
#    - حدّث حالة مهامك في PROJECT-TASKS.md
#    - سجّل ملخص يومك في PROJECT-LOG.md
git add docs/PROJECT-TASKS.md docs/PROJECT-LOG.md
git commit -m "docs: update task status and daily log"
git push
```

### ⚠️ قاعدة الـ WIP Commit

> **لا تروح من الشغل وعندك كود مش مرفوع على GitHub أبدًا.**
> حتى لو الشغل مش كامل — اعمل `wip` commit واكتب فيه:
> - أيه اللي خلصته
> - أيه اللي فاضل
> - أي ملاحظات لمن يكمل

---

## 2. الملفات الحساسة

### 🔴 ملفات لا تُرفع أبدًا على GitHub

```gitignore
# ===========================
# 🔴 SECRETS & CREDENTIALS
# ===========================

# Environment files (فيها كلمات مرور وـ API keys)
.env
.env.local
.env.production
.env.staging
.env.*.local

# SSH Keys
*.pem
*.key
id_rsa
id_ed25519
*.ppk

# SSL Certificates
*.crt
*.cert
*.p12
*.pfx

# App Store / Play Store
*.keystore
*.jks
*.mobileprovision
*.p8
AuthKey_*.p8
GoogleService-Info.plist
google-services.json
service-account*.json
*.cer

# API Keys & Tokens (لو محفوظة في ملفات)
**/secrets/
**/credentials/
**/.credentials/

# ===========================
# 🔴 PROJECT SENSITIVE DATA
# ===========================

# بيانات المشروع الحساسة
docs/PROJECT-CONTEXT.md

# Database dumps
*.sql
*.dump
*.sqlite
*.db

# ===========================
# 🟡 GENERATED / TEMPORARY
# ===========================

# Dependencies
node_modules/
vendor/
.dart_tool/
Pods/

# Build outputs
.next/
dist/
build/
*.apk
*.ipa
*.aab

# IDE
.idea/
.vscode/settings.json
*.swp
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Test coverage
coverage/
.nyc_output/
```

### 📋 جدول تصنيف الملفات

| الملف | يترفع على GitHub؟ | السبب | أين يُحفظ؟ |
|-------|-------------------|-------|------------|
| `.env` | ❌ أبدًا | فيه passwords و API keys | الخزنة |
| `.env.example` | ✅ نعم | نموذج بدون قيم حقيقية | Git |
| `SSH keys (.pem)` | ❌ أبدًا | وصول للسيرفرات | الخزنة |
| `Keystore (Android)` | ❌ أبدًا | توقيع التطبيق — لو ضاع مفيش update | الخزنة |
| `AuthKey .p8 (Apple)` | ❌ أبدًا | وصول لـ App Store Connect | الخزنة |
| `google-services.json` | ❌ أبدًا | إعدادات Firebase | الخزنة |
| `GoogleService-Info.plist` | ❌ أبدًا | إعدادات Firebase iOS | الخزنة |
| `service-account.json` | ❌ أبدًا | وصول لـ Google APIs | الخزنة |
| `docs/PROJECT-CONTEXT.md` | ❌ أبدًا | بيانات السيرفرات والتطبيقات | الخزنة |
| `CLAUDE.md` | ✅ نعم | قواعد المشروع — مفيش بيانات حساسة | Git |
| `docs/PROJECT-TASKS.md` | ✅ نعم | تتبع المهام | Git |
| `docs/PROJECT-LOG.md` | ✅ نعم | سجل الأحداث | Git |
| `.claude/agents/*.md` | ✅ نعم | تعريفات الـ Agents | Git |
| Source code | ✅ نعم | كود المشروع | Git |
| Database migrations | ✅ نعم | هيكل قاعدة البيانات | Git |
| `*.sql` (data dumps) | ❌ أبدًا | بيانات حقيقية | الخزنة |

### ✅ .env.example — النموذج اللي يترفع

```env
# ===================================
# هذا نموذج فقط — لا تضع قيم حقيقية
# انسخه كـ .env واملأ القيم
# cp .env.example .env
# ===================================

# App
NODE_ENV=development
APP_URL=http://localhost:3000
APP_PORT=3000

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Auth
JWT_SECRET=generate-a-strong-secret-here
JWT_REFRESH_SECRET=generate-another-strong-secret
JWT_EXPIRY=15m

# Email (SendGrid/SMTP)
SMTP_HOST=
SMTP_PORT=
SMTP_USER=
SMTP_PASS=

# Payment (Stripe)
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_PUBLISHABLE_KEY=pk_test_...

# Storage (S3/Spaces)
S3_BUCKET=
S3_REGION=
S3_ACCESS_KEY=
S3_SECRET_KEY=

# Push Notifications (Firebase)
FIREBASE_PROJECT_ID=
# Note: Full Firebase config in google-services.json (get from vault)

# Error Tracking
SENTRY_DSN=
```

---

## 3. نظام تسليم المشاريع — Handoff Protocol

### متى يتم التسليم؟
- مبرمج هيسيب الشركة
- مبرمج هيتنقل لمشروع تاني
- عميل طلب التسليم
- الشركة عايزة backup لمبرمج ثاني

### ⚡ التسليم السريع (لو حد مشي فجأة)

لو المبرمج اتبع الروتين اليومي (push كل يوم + تحديث TASKS و LOG)،
فالمبرمج الجديد يقدر يبدأ فورًا:

```bash
# 1. Clone المشروع
git clone https://github.com/org/project.git
cd project

# 2. اقرأ الملفات الأساسية — بالترتيب ده
cat README.md               # نظرة عامة
cat CLAUDE.md                # القواعد والأوامر
cat docs/PROJECT-TASKS.md    # حالة المهام — أيه مكتمل وأيه فاضل
cat docs/PROJECT-LOG.md      # آخر الأحداث — أيه اللي كان بيحصل

# 3. اطلب الخزنة من المدير (PROJECT-CONTEXT + .env + keys)

# 4. ثبّت الـ dependencies
pnpm install  # أو npm install أو composer install

# 5. ثبّت الـ MCP servers
# (هيكونوا في .mcp.json لو كانوا --scope project)

# 6. ابدأ الشغل
claude
```

### 📦 التسليم المنظم (Planned Handoff)

لما يكون فيه وقت للتسليم، المبرمج القديم يعمل الآتي:

#### الخطوة 1: تنظيف الكود

```bash
# تأكد إن مفيش شغل مش مرفوع
git status

# اعمل merge لكل الـ branches الجاهزة
git checkout develop
git merge feat/F-003-appointment-booking

# احذف الـ branches اللي خلصت
git branch -d feat/F-001-patient-crud
git push origin --delete feat/F-001-patient-crud

# تأكد إن كل الاختبارات بتعدي
pnpm test
pnpm build
```

#### الخطوة 2: كتابة وثيقة التسليم

أنشئ ملف `docs/HANDOFF-[YYYY-MM-DD].md`:

```markdown
# 📋 وثيقة تسليم المشروع

**المشروع:** [اسم المشروع]
**المسلِّم:** [اسمك]
**التاريخ:** [YYYY-MM-DD]

---

## 1. حالة المشروع الحالية

### ✅ ميزات مكتملة وشغالة
- F-001: إدارة المرضى — مكتمل ومُختبر
- F-002: حجز المواعيد — مكتمل ومُختبر
- ...

### 🔄 ميزات قيد التنفيذ
- F-005: التقارير — 60% مكتمل
  - ✅ API endpoints جاهزة
  - ✅ Database queries جاهزة
  - ❌ فاضل: Charts UI + PDF export
  - الكود في branch: `feat/F-005-reports`
  - ملاحظات: استخدمت Recharts للـ charts

### ⏳ ميزات لم تبدأ بعد
- F-006: الإشعارات
- F-007: نظام الصلاحيات

---

## 2. البنية التقنية

### الهيكل العام
[شرح مبسط لبنية المشروع]

### الأنماط المهمة
- **Authentication**: JWT مع refresh tokens (انظر src/services/auth-service.ts)
- **API Pattern**: كل endpoint بيتبع نفس الـ structure (انظر src/app/api/patients/route.ts كمرجع)
- **Database**: Prisma ORM — كل schema changes عن طريق migrations
- **State Management**: React Query للـ server state

### قرارات تقنية مهمة
- اخترنا SSE بدل WebSocket للإشعارات — السبب: أبسط ومش محتاجين bi-directional
- الـ file uploads بتتخزن على S3 مش locally — السبب: scalability

---

## 3. الأشياء اللي لازم تنتبهلها

### ⚠️ نقاط حساسة
- الـ payment webhook (`/api/webhooks/stripe`) — لا تعدل بدون فهم كامل
- الـ cron job (`/scripts/cleanup-expired-sessions.ts`) — لازم يشتغل كل ساعة
- الـ database migration #15 — فيها data transformation، لا تعمل rollback

### 🐛 مشاكل معروفة (Known Issues)
- أحيانًا الـ calendar picker بيعلق على Safari (مسجل B-012)
- الـ PDF export بطيء لو التقرير أكتر من 1000 سطر

### 🔑 حسابات وأدوات
- Sentry: [رابط المشروع]
- Vercel/DigitalOcean: [رابط الـ dashboard]
- App Store Connect: [Team ID]

---

## 4. كيف تبدأ

```bash
# 1. Clone
git clone [URL]

# 2. اطلب من المدير:
#    - ملف .env (أو نسخة من الخزنة)
#    - docs/PROJECT-CONTEXT.md
#    - SSH keys للسيرفرات

# 3. Setup
cp .env.example .env
# املأ القيم من الملفات اللي استلمتها
pnpm install
npx prisma db push  # أو migrate
pnpm dev

# 4. شغّل الاختبارات
pnpm test
```

---

## 5. جهات الاتصال

| الشخص | الدور | للتواصل بخصوص |
|-------|-------|---------------|
| [اسم] | مدير المشروع | القرارات والأولويات |
| [اسم] | مصمم | التصميمات والـ Figma |
| [اسم] | العميل | المتطلبات والاعتماد |
```

#### الخطوة 3: جلسة التسليم (لو ممكن)

```
مدة الجلسة: ساعة إلى ساعتين

الأجندة:
1. (15 دقيقة) عرض عام للمشروع وتشغيله
2. (20 دقيقة) شرح البنية التقنية والملفات المهمة
3. (15 دقيقة) الميزات قيد التنفيذ — أيه فاضل وأيه الخطة
4. (10 دقائق) النقاط الحساسة والمشاكل المعروفة
5. (15 دقيقة) تسليم الـ credentials والـ access
6. (15 دقيقة) أسئلة
```

---

## 4. خزنة المشروع — Project Vault

### أيه هي؟
مكان آمن خارج GitHub بيتخزن فيه كل الملفات الحساسة اللي مش بترتفع على Git.

### الخيارات المتاحة

| الأداة | المميزات | التكلفة | الأنسب لـ |
|--------|---------|---------|----------|
| **1Password Teams** | مشاركة آمنة + API | مدفوع | فرق كبيرة |
| **Bitwarden** | open source + self-host | مجاني/مدفوع | أي حجم |
| **Google Drive (مشفر)** | بسيط ومتاح | مجاني | فرق صغيرة |
| **Private Git Repo** | version control | مجاني | أي حجم |
| **Doppler/Infisical** | متخصص في secrets | مدفوع | DevOps teams |

### 🏆 التوصية: Private Git Repo + تشفير

أبسط حل وأكثرهم تنظيمًا: repo خاص لكل الأصول الحساسة.

#### الإعداد

```bash
# 1. أنشئ repo خاص على GitHub/GitLab
# اسمه: company-vaults (أو project-name-vault)

# 2. الهيكل
company-vaults/
├── README.md                           # شرح عام
├── [project-name]/
│   ├── README.md                       # ملاحظات خاصة بالمشروع
│   ├── env/
│   │   ├── .env.development            # بيئة التطوير
│   │   ├── .env.staging                # بيئة الاختبار
│   │   └── .env.production             # بيئة الإنتاج
│   ├── ssh/
│   │   ├── production.pem              # SSH key للسيرفر
│   │   ├── staging.pem
│   │   └── README.md                   # أي سيرفر بأي key
│   ├── certificates/
│   │   ├── ssl/                        # شهادات SSL (لو مش auto)
│   │   ├── apple/                      # Apple certificates + p8
│   │   │   ├── AuthKey_XXXXX.p8
│   │   │   ├── distribution.cer
│   │   │   └── README.md              # Team ID, Key ID, etc.
│   │   └── android/                    # Android keystore
│   │       ├── release.keystore
│   │       └── README.md              # alias, passwords
│   ├── firebase/
│   │   ├── google-services.json        # Android
│   │   ├── GoogleService-Info.plist    # iOS
│   │   └── service-account.json        # Server SDK
│   ├── docs/
│   │   ├── PROJECT-CONTEXT.md          # بيانات المشروع الكاملة
│   │   ├── credentials-guide.md        # شرح كل credential وأين يُستخدم
│   │   └── HANDOFF-*.md                # وثائق التسليم السابقة
│   └── third-party/
│       ├── stripe-webhook-secret.txt
│       └── README.md                   # روابط dashboards + حسابات
```

#### قواعد الخزنة

```
1. الوصول محدود — بس المديرين والـ senior developers
2. كل تغيير بـ commit message واضح
3. لو credential اتغير → حدّث الخزنة فورًا
4. راجع الخزنة شهريًا — احذف credentials منتهية الصلاحية
5. لو مبرمج سابَ → غيّر كل الـ credentials اللي كان يقدر يوصلها
```

#### دليل الـ Credentials

أنشئ ملف `credentials-guide.md` في الخزنة:

```markdown
# 🔑 Credentials Guide — [Project Name]

## كيف تستخدم هذا الملف
عند بدء العمل على المشروع، اتبع الخطوات:
1. انسخ `env/.env.development` إلى `.env` في مجلد المشروع
2. انسخ ملفات Firebase للمسارات الصحيحة (انظر أدناه)
3. ضع SSH keys في `~/.ssh/` واعمل `chmod 600`

---

## Environment Variables

### DATABASE_URL
- **يُستخدم في:** الاتصال بقاعدة البيانات
- **أين تحصل عليه:** DigitalOcean Dashboard → Databases
- **بيئة التطوير:** استخدم local PostgreSQL
- **ملاحظة:** لا تستخدم production DB في التطوير أبدًا

### JWT_SECRET / JWT_REFRESH_SECRET
- **يُستخدم في:** توقيع tokens المصادقة
- **كيف تنشئ واحد جديد:** `openssl rand -hex 64`
- **⚠️ تحذير:** لو غيرته في production، كل المستخدمين هيتسجلوا خروج

### STRIPE_SECRET_KEY
- **يُستخدم في:** معالجة الدفع
- **أين تحصل عليه:** Stripe Dashboard → Developers → API Keys
- **بيئة التطوير:** استخدم sk_test_...
- **⚠️ تحذير:** لا تستخدم live key في التطوير أبدًا

---

## SSH Keys

### production.pem
- **السيرفر:** 167.172.xxx.xxx
- **المستخدم:** deploy
- **الاستخدام:**
  ```bash
  chmod 600 ~/.ssh/production.pem
  ssh -i ~/.ssh/production.pem deploy@167.172.xxx.xxx
  ```

---

## App Store / Play Store

### Apple
- **Team ID:** XXXXXXXXXX
- **Key ID (for push):** YYYYYYYYYY
- **AuthKey file:** certificates/apple/AuthKey_YYYYYYYYYY.p8
- **App Store Connect:** https://appstoreconnect.apple.com
- **Account:** [email — اطلبه من المدير]

### Android
- **Keystore:** certificates/android/release.keystore
- **Alias:** release-key
- **Keystore Password:** [اطلبه من المدير شفهيًا]
- **Key Password:** [اطلبه من المدير شفهيًا]
- **⚠️ تحذير:** لو الـ keystore ضاع، مش هتقدر ترفع update للتطبيق أبدًا!
```

---

## 5. سيناريوهات الطوارئ

### السيناريو 1: مبرمج مشي فجأة بدون تسليم

```
✅ لو كان بيتبع الروتين اليومي:
   1. آخر كود مرفوع على GitHub (أقصى خسارة = شغل يوم)
   2. PROJECT-TASKS.md فيه حالة كل المهام
   3. PROJECT-LOG.md فيه آخر الأحداث
   4. الـ wip commits فيها وصف لأيه فاضل

   → المبرمج الجديد يقدر يبدأ خلال ساعات

❌ لو ما كانش بيتبع الروتين:
   1. اطلب منه يرفع آخر كود (لو لسه ممكن)
   2. افحص آخر commits على GitHub
   3. شوف PROJECT-TASKS.md — آخر مهمة كان بيشتغل عليها
   4. هتحتاج وقت أطول لفهم الكود
```

### السيناريو 2: مبرمج مشي ومعاه credentials حساسة

```
فورًا — خلال 24 ساعة:

1. 🔑 غيّر كلمات مرور السيرفرات
   ssh deploy@server 'passwd'

2. 🔑 جدد SSH keys
   ssh-keygen -t ed25519 -f ~/.ssh/project_key_new
   # ارفع الـ public key الجديد على السيرفر
   # احذف الـ public key القديم

3. 🔑 جدد API keys من الـ dashboards:
   - Stripe: أنشئ key جديد واحذف القديم
   - Firebase: جدد الـ service account
   - SendGrid: جدد الـ API key
   - أي خدمة تانية

4. 🔑 جدد JWT secrets (⚠️ كل المستخدمين هيتسجلوا خروج)

5. 🔑 حدّث الخزنة بالـ credentials الجديدة

6. 🔑 حدّث .env على كل السيرفرات

7. 🔑 لو كان عنده access للـ GitHub repo:
   - Settings → Collaborators → Remove
   
8. 🔑 لو كان عنده access لـ App Store / Play Console:
   - اشيل حسابه
```

### السيناريو 3: الـ keystore ضاع (Android)

```
⚠️ خطير جدًا — لو ضاع الـ keystore:
   - مش هتقدر ترفع update للتطبيق على Google Play
   - هتحتاج تنشر تطبيق جديد بـ package name جديد
   - كل المستخدمين الحاليين مش هيقدروا يعملوا update

الحل الوقائي:
   ✅ الـ keystore في الخزنة دائمًا (مع backup)
   ✅ الـ passwords مسجلة شفهيًا مع المدير
   ✅ نسخة على Google Drive مشفرة
   ✅ فعّل Google Play App Signing (بيحفظ نسخة عند Google)
```

### السيناريو 4: السيرفر وقع والمبرمج مش متاح

```
مع PROJECT-CONTEXT.md والخزنة، أي حد يقدر:
1. يدخل السيرفر: ssh -i [key] deploy@[IP]
2. يشوف الـ logs: pm2 logs / docker logs
3. يعمل restart: pm2 restart app
4. يعمل rollback: git checkout [last-stable-tag]
```

---

## ✅ Checklist — لكل مشروع جديد

### عند بدء المشروع
- [ ] إنشاء repo على GitHub مع branch protection
- [ ] كتابة CLAUDE.md
- [ ] كتابة .env.example (بدون قيم حقيقية)
- [ ] إعداد .gitignore شامل
- [ ] إنشاء مجلد في الخزنة مع كل الـ credentials
- [ ] كتابة PROJECT-CONTEXT.md (في الخزنة)
- [ ] إنشاء PROJECT-TASKS.md + PROJECT-LOG.md
- [ ] تثبيت MCP servers كـ --scope project

### يوميًا
- [ ] كل مبرمج يعمل push قبل ما يمشي
- [ ] تحديث PROJECT-TASKS.md
- [ ] تسجيل الأحداث المهمة في PROJECT-LOG.md

### عند إضافة credential جديد
- [ ] إضافته في الخزنة
- [ ] إضافة المتغير في .env.example (بدون القيمة)
- [ ] توثيقه في credentials-guide.md
- [ ] إضافته في PROJECT-CONTEXT.md (بدون القيمة الفعلية)

### عند مغادرة مبرمج
- [ ] تسليم منظم (وثيقة + جلسة)
- [ ] تغيير كل الـ credentials اللي كان يوصلها
- [ ] إزالة الوصول من GitHub + dashboards
- [ ] تحديث الخزنة
- [ ] إبلاغ الفريق

### شهريًا
- [ ] مراجعة الخزنة — حذف credentials منتهية
- [ ] فحص npm audit / dependabot alerts
- [ ] التأكد إن الـ backups شغالة
- [ ] التأكد إن كل مبرمج عنده access صحيح (لا أكتر ولا أقل)

---

> **تذكّر:** الهدف مش إنك تمنع الناس من الشغل — الهدف إنك تضمن إن الشغل يقدر يكمل لو أي حاجة حصلت. النظام ده بيحمي الشركة والمبرمج والعميل.

---

## Phase 4 — DI codegen (injectable + build_runner)

Dorak uses `get_it` + `injectable`. The manual block in `lib/data/di/locator.dart` and the injectable-generated `lib/core/di/injection.config.dart` coexist until Phase 9.

### Regenerate `injection.config.dart` (and retrofit `.g.dart`)

Run on **macOS or Linux** — Windows Flutter cache ships only `frontend_server_aot.dart.snapshot`, so `build_runner` fails on this platform:

```
dart run build_runner build --delete-conflicting-outputs
```

Then flip on the import + call in `lib/core/di/injection.dart`:

```dart
import 'injection.config.dart';
...
await $initGetIt(gi);
```

Call `configureInjectableDependencies(getIt)` from `main.dart` after `setupLocator()`:

```dart
await setupLocator();
await configureInjectableDependencies(getIt);
```

Phase 8 moves each repository under `@LazySingleton(as: XxxRepository)` and deletes the matching manual block in `locator.dart` in the same PR.
