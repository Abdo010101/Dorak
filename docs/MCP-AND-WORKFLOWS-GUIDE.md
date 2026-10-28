# 🔌 دليل الـ MCP Servers + مسارات العمل الكاملة

---

## الجزء الأول: MCP Servers الموصى بها لتطوير البرمجيات

> الـ MCP (Model Context Protocol) بيوصّل Claude Code بأدوات خارجية.
> بدله، Claude بيشتغل معزول. معاه، بيقدر يتعامل مع GitHub و الـ database
> والـ browser وغيرها مباشرة.

### كيفية التثبيت العامة

```bash
# إضافة MCP server
claude mcp add [name] -- [command]

# ثلاث مستويات:
--scope user      # متاح في كل المشاريع (شخصي)
--scope local     # للمشروع الحالي فقط (شخصي) — الافتراضي
--scope project   # يتحفظ في .mcp.json ويتشارك مع الفريق عبر Git
```

---

### 1. 🎭 Playwright MCP — اختبار المتصفح والـ UI

**إيه هو:** بيدي Claude متصفح حقيقي يقدر يتصفح فيه، يضغط أزرار، يملأ forms، ياخد screenshots، ويفحص العناصر.

**هيفيدك في:**
- اختبار الـ UI تلقائيًا بدون ما تكتب test scripts
- التأكد إن الـ forms شغالة
- فحص الـ responsive design
- اكتشاف الـ bugs البصرية
- عمل E2E testing بدون Cypress أو Playwright يدوي

**التثبيت:**
```bash
claude mcp add playwright --scope project -- npx -y @playwright/mcp --headless
```

**مثال عملي:**
```
افتح http://localhost:3000/login
وجرب تسجيل دخول بإيميل خطأ
وتأكد إن رسالة الخطأ ظاهرة
وبعدين سجل دخول ببيانات صحيحة وتأكد إنك وصلت للـ dashboard
```

---

### 2. 🐙 GitHub MCP — إدارة الـ Repository

**إيه هو:** بيوصّل Claude بـ GitHub مباشرة — يقرأ Issues، يعمل PRs، يبحث في الكود عبر الـ repos.

**هيفيدك في:**
- قراءة Issue وتنفيذها مباشرة
- إنشاء Pull Request بعد إنهاء الشغل
- البحث في كود مشاريعك التانية
- مراجعة PRs من الفريق
- قراءة الـ CI/CD status

**التثبيت:**
```bash
claude mcp add github --scope user -- npx -y @modelcontextprotocol/server-github
# هيطلب GitHub token
```

**مثال عملي:**
```
اقرأ Issue #42 من الـ repo
ونفذها
وبعد ما تخلص اعمل PR مع وصف كامل لكل التغييرات
```

---

### 3. 📚 Context7 MCP — توثيق المكتبات المحدّث

**إيه هو:** بيجيب أحدث documentation لأي مكتبة مباشرة من الـ source، عشان Claude ما يستخدمش methods قديمة أو deprecated.

**هيفيدك في:**
- الحصول على أحدث API reference لـ Next.js, React, Prisma, أي مكتبة
- تجنب الأخطاء الناتجة عن تغيير APIs بين الإصدارات
- التعامل مع مكتبات جديدة ما كانتش في training data

**التثبيت:**
```bash
claude mcp add context7 --scope project -- npx -y @upstash/context7-mcp
```

**مثال عملي:**
```
استخدم context7 عشان تجيبلي أحدث طريقة لعمل
server actions في Next.js 15 مع Prisma
```

---

### 4. 🗄️ PostgreSQL MCP — إدارة قاعدة البيانات

**إيه هو:** بيخلي Claude يتعامل مع الـ database مباشرة — يعمل queries، يفحص الـ schema، يحلل الأداء.

**هيفيدك في:**
- فحص بيانات حقيقية أثناء التطوير
- تحليل أداء الـ queries (EXPLAIN)
- فهم الـ schema الموجود قبل ما تكتب كود
- تصحيح مشاكل البيانات

**التثبيت:**
```bash
claude mcp add postgres --scope local -- npx -y @modelcontextprotocol/server-postgres \
  "postgresql://user:pass@localhost:5432/mydb"
```

**مثال عملي:**
```
افحص schema جدول users
واعملي query يجيب الـ users اللي ما سجلوش دخول من 30 يوم
وقولي لو فيه index ناقص
```

> ⚠️ **استخدمه مع قاعدة بيانات التطوير فقط — مش الـ production!**

---

### 5. 🎨 Figma MCP — ربط التصميم بالكود

**إيه هو:** بيقرأ ملفات Figma مباشرة — design tokens, component properties, screenshots لأي frame.

**هيفيدك في:**
- تحويل التصميم لكود دقيق (pixel-perfect)
- استخراج الألوان والـ spacing والـ typography من التصميم
- فهم الـ component structure من Figma
- تقليل الـ back-and-forth مع المصممين

**التثبيت:**
```bash
claude mcp add figma --scope user -- npx -y figma-developer-mcp \
  --figma-api-key YOUR_KEY
```

**مثال عملي:**
```
افتح ملف Figma اللي فيه تصميم صفحة الـ dashboard
واستخرج الألوان والـ spacing المستخدمين
وابني الـ components زي ما في التصميم بالظبط
```

---

### 6. 🔍 Sentry MCP — تتبع الأخطاء

**إيه هو:** بيوصّل Claude بـ Sentry عشان يشوف الأخطاء الحقيقية اللي بتحصل في الـ production.

**هيفيدك في:**
- قراءة الـ errors مباشرة من Sentry
- فهم الـ stack trace وتحديد السبب
- إصلاح الـ bugs بناءً على بيانات حقيقية
- تحديد أولويات الإصلاح

**التثبيت:**
```bash
claude mcp add sentry --scope project -- npx -y @sentry/mcp-server \
  --token YOUR_SENTRY_TOKEN
```

**مثال عملي:**
```
اعرضلي أكتر 5 errors بتحصل في الأسبوع ده
واقترح إصلاح لأعلى واحد
```

---

### 7. 🧠 Sequential Thinking MCP — تفكير منظم

**إيه هو:** بيخلي Claude يفكر بشكل منهجي — يحلل المشكلة خطوة بخطوة، يراجع قراراته، ويستكشف بدائل.

**هيفيدك في:**
- القرارات المعمارية المعقدة
- تحليل المشاكل الصعبة (debugging)
- تخطيط الميزات الكبيرة
- المقارنة بين خيارات تقنية

**التثبيت:**
```bash
claude mcp add sequential-thinking --scope user -- \
  npx -y @modelcontextprotocol/server-sequential-thinking
```

**مثال عملي:**
```
فكر بشكل منهجي: أيه أفضل طريقة لعمل real-time notifications
في مشروع Next.js مع PostgreSQL؟
قارن بين WebSocket و SSE و Polling
```

---

### 8. 📋 Linear / Jira MCP — إدارة المهام

**إيه هو:** بيوصّل Claude بأداة إدارة المهام — يقرأ tickets، يحدث حالتها، ينشئ مهام جديدة.

**هيفيدك في:**
- قراءة تفاصيل المهمة وتنفيذها مباشرة
- تحديث حالة المهمة بعد الإنجاز
- إنشاء sub-tasks تلقائيًا
- ربط الكود بالمهام

**التثبيت (Linear):**
```bash
claude mcp add linear --scope project -- npx -y @linear/mcp-server
```

**التثبيت (Jira):**
```bash
claude mcp add jira --scope project -- npx -y @anthropic/mcp-server-jira
```

---

### 9. 📂 Supabase MCP — Backend-as-a-Service

**إيه هو:** بيتعامل مع Supabase مباشرة — tables, auth, storage, edge functions.

**هيفيدك في:**
- إدارة الـ database من غير ما تفتح Supabase Dashboard
- إنشاء tables و RLS policies
- إدارة الـ auth والـ storage
- مشاريع Supabase زي Khatmtna

**التثبيت:**
```bash
claude mcp add supabase --scope project -- \
  npx -y @anthropic/mcp-server-supabase \
  --supabase-url https://xxx.supabase.co \
  --supabase-key YOUR_SERVICE_KEY
```

---

### 🏆 التوصية: ابدأ بالـ 4 دول

| الأولوية | MCP | السبب |
|----------|-----|-------|
| 1 | **Playwright** | اختبارات UI تلقائية — أهم حاجة لمنع الـ regressions |
| 2 | **Context7** | توثيق محدث — يمنع أخطاء APIs القديمة |
| 3 | **GitHub** | إدارة الـ repo من غير ما تخرج من الـ terminal |
| 4 | **PostgreSQL** | فهم وفحص الـ database مباشرة |

**أضفهم كلهم مرة واحدة:**
```bash
claude mcp add playwright --scope project -- npx -y @playwright/mcp --headless
claude mcp add context7 --scope project -- npx -y @upstash/context7-mcp
claude mcp add github --scope user -- npx -y @modelcontextprotocol/server-github
claude mcp add postgres --scope local -- npx -y @modelcontextprotocol/server-postgres "YOUR_DB_URL"
```

---
---

## الجزء الثاني: مسارات العمل الكاملة

---

## المسار الأول: مشروع جديد من الصفر 🆕

### السيناريو
العميل طلب تطبيق ويب لإدارة العيادات — حجز مواعيد، ملفات مرضى، إشعارات.
Tech stack: Next.js 15, TypeScript, Prisma, PostgreSQL, Tailwind.

---

### المرحلة 1: التأسيس (أنت يدويًا)

```bash
# 1. أنشئ المشروع
npx create-next-app@latest clinic-app --typescript --tailwind --app --src-dir
cd clinic-app

# 2. أنشئ هيكل الـ agents
mkdir -p .claude/agents .claude/commands docs

# 3. انسخ ملفات الـ agents kit
cp -r path/to/agents-kit-v2/.claude/agents/* .claude/agents/
cp -r path/to/agents-kit-v2/.claude/commands/* .claude/commands/
cp path/to/agents-kit-v2/docs/* docs/

# 4. ثبّت الـ MCP servers
claude mcp add playwright --scope project -- npx -y @playwright/mcp --headless
claude mcp add context7 --scope project -- npx -y @upstash/context7-mcp

# 5. أنشئ الـ Git repo
git init && git add . && git commit -m "chore: initial setup"
```

### المرحلة 2: كتابة CLAUDE.md

```bash
claude
# > اكتب CLAUDE.md للمشروع ده: تطبيق إدارة عيادات بـ Next.js 15, Prisma, PostgreSQL
# > راجع النموذج في الدليل الشامل (multi-agent-guide.md)
```

### المرحلة 3: ملء PROJECT-CONTEXT.md

```bash
# افتح docs/PROJECT-CONTEXT.md وعدّله يدويًا:
# - اسم المشروع
# - بيانات السيرفر (لو عندك)
# - بيانات الـ database
# - الخدمات الخارجية (Stripe, Firebase, etc.)
```

### المرحلة 4: بناء الميزة الأولى (مع الـ Orchestrator)

```bash
claude

# الأمر:
/project:build-feature نظام إدارة المرضى مع:
- إضافة مريض جديد (الاسم، الرقم القومي، رقم التليفون، تاريخ الميلاد)
- عرض قائمة المرضى مع بحث وفلترة
- عرض ملف المريض الكامل
- تعديل بيانات المريض
- CRUD API كامل مع validation
```

**ماذا سيحدث:**

```
🎯 Orchestrator:
   ├── يقرأ CLAUDE.md + PROJECT-CONTEXT.md + PROJECT-TASKS.md
   ├── ينشئ Feature F-001 في PROJECT-TASKS.md
   ├── يسجل 🚀 START في PROJECT-LOG.md
   │
   ├── 🏗️ Architect
   │   ├── يصمم: database schema (patients table)
   │   ├── يصمم: API endpoints (GET/POST/PUT/DELETE /api/patients)
   │   ├── يحدد: هيكل الملفات
   │   └── يحفظ: docs/architecture/patients-design.md
   │   ✅ → يحدث TASKS + LOG
   │
   ├── 🎨 UI/UX Designer
   │   ├── يصمم: PatientCard, PatientForm, PatientList components
   │   ├── يحدد: states (loading, error, empty)
   │   ├── يحدد: responsive behavior
   │   └── يحفظ: docs/ui/patients-ui-specs.md
   │   ✅ → يحدث TASKS + LOG
   │
   ├── 💻 Full-Stack Dev
   │   ├── 🗄️ Database: migration لجدول patients
   │   ├── 📝 Types: Patient interface
   │   ├── ⚙️ Backend: service + API routes + validation
   │   ├── 🧪 Backend Tests: unit + integration → تعدي ✅
   │   ├── 🖥️ Frontend: components + pages + hooks
   │   └── 🧪 Full Tests: كلها تعدي ✅
   │   ✅ → يحدث TASKS + LOG
   │
   ├── 🔒 Security Auditor
   │   ├── يفحص: input validation, SQL injection, auth
   │   └── تقرير: ✅ لا مشاكل critical
   │   ✅ → يحدث TASKS + LOG
   │
   └── 🧪 QA Tester
       ├── يشغل كل الاختبارات
       ├── يكتب اختبارات ناقصة
       └── تقرير: ✅ PASS
       ✅ → يحدث TASKS + LOG

📋 Orchestrator: يحدث الملخص النهائي ويسلّمك
```

### المرحلة 5: الميزة الثانية والثالثة...

```bash
# كرر نفس الأمر لكل ميزة
/project:build-feature نظام حجز المواعيد مع:
- اختيار المريض والدكتور والموعد
- عرض المواعيد في تقويم
- تأكيد وإلغاء المواعيد
- إرسال تذكير بالإيميل قبل الموعد بيوم
```

### المرحلة 6: التجهيز للـ Production

```bash
# بعد إنهاء كل الميزات:
Use the orchestrator to prepare for production:
1. Run full security audit on all code
2. Run full QA suite
3. Check all environment variables are documented
4. Verify the build passes
5. Update PROJECT-CONTEXT.md with production server details
6. Create deployment checklist
```

---
---

## المسار الثاني: مشروع قائم — إصلاحات وإضافات 🔧

### السيناريو
عندك مشروع Laravel + Vue.js شغال من سنة. العميل عايز:
- إصلاح bug في الدفع (أحيانًا الدفع بينجح لكن الـ order ما بيتسجلش)
- إضافة ميزة: تقارير مبيعات شهرية بـ charts
- تحسين: سرعة تحميل صفحة المنتجات

---

### المرحلة 1: التأسيس (مرة واحدة بس)

```bash
cd existing-project

# 1. أنشئ هيكل الـ agents
mkdir -p .claude/agents .claude/commands docs

# 2. انسخ ملفات الـ agents
cp -r path/to/agents-kit-v2/.claude/agents/* .claude/agents/
cp -r path/to/agents-kit-v2/.claude/commands/* .claude/commands/

# 3. ثبّت MCP servers
claude mcp add playwright --scope project -- npx -y @playwright/mcp --headless
claude mcp add context7 --scope project -- npx -y @upstash/context7-mcp
```

### المرحلة 2: كتابة CLAUDE.md للمشروع القائم

```bash
claude

# الأمر:
اقرأ هيكل المشروع ده وافهم الـ tech stack والـ patterns المستخدمة
واكتب CLAUDE.md شامل يتضمن:
- الـ Tech Stack
- أوامر الـ Build/Test/Lint
- هيكل المجلدات
- القواعد والـ conventions الموجودة
- أي naming patterns تلاحظها
```

### المرحلة 3: ملء PROJECT-CONTEXT.md + PROJECT-TASKS.md

```bash
# docs/PROJECT-CONTEXT.md — بيانات السيرفر والـ database وكل حاجة
# docs/PROJECT-TASKS.md — سجّل المهام المطلوبة:
#   F-001: إصلاح bug الدفع (🔴 أولوية عالية)
#   F-002: تقارير المبيعات (🟡 متوسطة)
#   F-003: تحسين سرعة المنتجات (🟢 منخفضة)
```

### المرحلة 4: إصلاح الـ Bug (أولوية عالية)

```bash
claude

# الأمر:
Use the orchestrator to fix this bug:

Bug: أحيانًا الدفع بـ Stripe بينجح لكن الـ order ما بيتسجلش في الـ database.
المريض بيتخصم منه فلوس لكن الـ order مش موجود في النظام.

Steps:
1. حلل كود الدفع وافهم الـ flow
2. حدد السبب الجذري (race condition? missing error handling?)
3. اكتب failing test يعيد إنتاج المشكلة
4. أصلح المشكلة
5. تأكد إن الـ test بيعدي
6. شغّل كل الاختبارات عشان تتأكد مفيش regression
7. اعمل security review لكود الدفع
```

**ماذا سيحدث:**

```
🎯 Orchestrator:
   ├── يقرأ الملفات الأساسية
   ├── يسجل B-001 في PROJECT-TASKS.md  
   ├── يسجل 🚀 في LOG
   │
   ├── 💻 Full-Stack Dev (للتحقيق والإصلاح)
   │   ├── Grep "stripe\|payment\|order" لفهم الـ flow
   │   ├── يقرأ PaymentController + OrderService
   │   ├── يكتشف: الـ order creation مش في transaction مع الـ payment
   │   │   (لو الـ payment نجح والـ DB write فشل → فلوس اتخصمت بدون order)
   │   ├── يكتب failing test
   │   ├── يصلح: يلف الـ payment + order في transaction
   │   ├── يضيف: webhook handler كـ fallback
   │   ├── يشغل الاختبارات → ✅
   │   └── يرجع تقرير بالسبب والإصلاح
   │   ✅ → يحدث TASKS + LOG
   │
   ├── 🔒 Security Auditor
   │   ├── يراجع كود الدفع بالكامل
   │   ├── يتأكد من: webhook signature verification
   │   ├── يتأكد من: idempotency keys
   │   └── تقرير: ✅ أو 🔴 (لو لقى مشاكل إضافية)
   │   ✅ → يحدث LOG
   │
   └── 🧪 QA Tester
       ├── يشغل كل الاختبارات
       ├── يختبر: payment success → order created
       ├── يختبر: payment fails → no order
       ├── يختبر: DB fails after payment → webhook catches it
       └── ✅ PASS
       ✅ → يحدث TASKS (B-001 ✅) + LOG
```

### المرحلة 5: إضافة ميزة التقارير

```bash
/project:build-feature تقارير مبيعات شهرية مع:
- صفحة dashboard فيها charts (bar chart للمبيعات اليومية، pie chart للمنتجات)
- فلترة بالتاريخ والمنتج والفئة
- تصدير PDF
- API endpoint يرجع البيانات aggregated
- الـ charts تشتغل responsive
ملاحظة: المشروع Laravel + Vue.js — التزم بالـ patterns الموجودة
```

### المرحلة 6: تحسين الأداء

```bash
Use the orchestrator to optimize the products page:

المشكلة: صفحة المنتجات بطيئة — بتاخد 4+ ثواني
المطلوب: تحت 1 ثانية

Steps:
1. حلل الصفحة الحالية وحدد الـ bottlenecks
   (database queries? large images? too many API calls?)
2. صمم الحل
3. نفذ التحسينات
4. قيس الأداء قبل وبعد
5. تأكد إن مفيش regression
```

---
---

## ملخص المقارنة بين المسارين

| | مشروع جديد 🆕 | مشروع قائم 🔧 |
|---|---|---|
| **أول خطوة** | إنشاء المشروع + كتابة CLAUDE.md | فهم المشروع + كتابة CLAUDE.md |
| **الـ Architect** | يصمم من الصفر | يحلل الموجود ويصمم الإضافة |
| **الـ Full-Stack** | يبني بحرية | يلتزم بالـ patterns الموجودة |
| **الـ Security** | فحص أساسي | فحص مركّز على الأجزاء المتغيرة |
| **الـ QA** | يكتب اختبارات من الصفر | يتأكد من عدم كسر الموجود |
| **الخطر الأكبر** | Over-engineering | كسر ميزة موجودة |
| **القاعدة الأهم** | ابدأ بسيط وكبّر | افهم أولاً، غيّر بحذر |
