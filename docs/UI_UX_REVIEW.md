# تقرير مراجعة UI/UX الشاملة
## تطبيق نظام الحضور والانصراف — Flutter Mobile
**تاريخ المراجعة:** 2026-04-06
**المراجع:** UI/UX Agent
**نطاق المراجعة:** جميع الصفحات والـ components

---

## ملخص تنفيذي (Executive Summary)

التطبيق يمتلك بنية تصميمية واضحة ومتسقة بشكل عام. الـ Design Tokens محددة جيداً في `AppTheme`، وفريق العمل استخدم Tajawal كـ font مناسب للعربية. مع ذلك، تم رصد **29 مشكلة** موزعة على مستويات الخطورة الأربعة، أبرزها:

- **مشاكل RTL حرجة**: اتجاه الأسهم معكوس في عدة صفحات
- **صفحة الإشعارات غير مكتملة**: تعمل على بيانات وهمية مُضمّنة في الكود
- **تحقق كلمة المرور غير مفعّل**: زر "حفظ" في تغيير كلمة المرور لا يتحقق من البيانات
- **غياب Directionality wrapper** في معظم الصفحات مع وجودها في CheckoutWorkLogForm فقط
- **حالات فارغة (Empty States) ناقصة** في عدة أماكن

**الحالة الإجمالية للتطبيق:** جيدة مع مشاكل تحتاج معالجة قبل الإطلاق للمستخدمين.

---

## مؤشر الخطورة

| الرمز | المستوى | التعريف |
|-------|---------|---------|
| P0 | Critical | يكسر التجربة أو يُخفي وظيفة أساسية |
| P1 | High | يؤثر سلباً على الاستخدام اليومي |
| P2 | Medium | يضعف تجربة المستخدم لكنه قابل للتجاوز |
| P3 | Low | تحسين جمالي أو طبقة polish |

---

## القسم الأول: المشاكل الحرجة (P0 — Critical)

---

### [P0-01] RTL: اتجاه أسهم التنقل بالتاريخ معكوس
**الصفحة:** `team_attendance_page.dart`
**الموقع:** `_buildDateSelector` — الـ Row الذي يحتوي على زري `chevron_left` و `chevron_right`

**الوصف:**
في واجهة RTL العربية، السهم الأيسر `chevron_left` هو الذي يجب أن يأخذ المستخدم إلى اليوم التالي (للأمام في الزمن)، والسهم الأيمن `chevron_right` يأخذه لليوم السابق. الكود الحالي يفعل العكس تماماً:
- `chevron_left` يُضيف يوماً (يمضي للأمام)
- `chevron_right` يطرح يوماً (يرجع للخلف)

هذا صحيح منطقياً في LTR، لكنه مرتبك بصرياً في RTL لأن المستخدم العربي يتوقع أن اليوم السابق يكون على اليمين.

**السلوك الحالي:** الضغط على `>` (يمين) يرجع ليوم الأمس
**الإصلاح المقترح:** استخدم `Icons.chevron_right` للتنقل للأمام (اليوم التالي) و `Icons.chevron_left` للتنقل للخلف، أو استخدم `Icon(Icons.chevron_right)` مع `Directionality` wrapper بحيث يستوعب Flutter عكس الاتجاه تلقائياً. الحل الأبسط: استبدل `chevron_left` بـ `chevron_right` والعكس، مع تبادل دوال الـ `onPressed`.

---

### [P0-02] RTL: أسهم قوائم الإعدادات في الاتجاه الخطأ
**الصفحة:** `profile_page.dart`
**الموقع:** دالة `_buildSettingsRow`، السطر 571

```dart
const Icon(Icons.chevron_left, color: AppTheme.textSecondary),
```

**الوصف:**
في RTL، مؤشر "الضغط للدخول" على عناصر القائمة يجب أن يكون `chevron_right` (يشير للأمام في اتجاه القراءة). استخدام `chevron_left` يعطي انطباعاً بأن الزر يرجع للخلف لا للأمام.

**الإصلاح المقترح:**
```dart
// بدلاً من:
const Icon(Icons.chevron_left, color: AppTheme.textSecondary)
// استخدم:
const Icon(Icons.chevron_right, color: AppTheme.textSecondary)
```
أو استخدم `Icons.arrow_forward_ios` مع `Directionality` يضمن انعكاسه تلقائياً.

---

### [P0-03] صفحة الإشعارات غير مكتملة وتعمل ببيانات وهمية
**الصفحة:** `notifications_page.dart`
**الموقع:** دالة `_buildNotificationsList`، السطر 30

**الوصف:**
الصفحة تعرض 3 إشعارات ثابتة مُعرَّفة مباشرة في الكود (hardcoded):
```dart
final notifications = <_NotificationItem>[
  _NotificationItem(title: 'تم الموافقة على إجازتك', ...),
  ...
];
```
كما أن زر "قراءة الكل" لا يفعل شيئاً:
```dart
onPressed: () {
  // Mark all as read
},
```
وتعليق `// TODO: Replace with actual notifications from API` موجود ومتروك.

**التأثير:** المستخدم يرى إشعارات وهمية لا علاقة لها بحالته الفعلية، وقراءة الإشعارات لا تعمل.

**الإصلاح المقترح:**
ربط الصفحة بـ BLoC حقيقي يجلب الإشعارات من الـ API. في حال لم يكن الـ API جاهزاً، إخفاء الصفحة أو إظهار empty state واضح أفضل من عرض بيانات مزيفة.

---

### [P0-04] تغيير كلمة المرور: لا يوجد تحقق من المدخلات
**الصفحة:** `profile_page.dart`
**الموقع:** دالة `_showChangePasswordDialog`، السطر 665

**الوصف:**
زر "حفظ" في dialog تغيير كلمة المرور يُغلق الـ dialog مباشرة ويعرض SnackBar نجاح بدون:
1. التحقق من تطابق كلمة المرور الجديدة مع التأكيد
2. التحقق من طول كلمة المرور
3. الاتصال بأي API لتغيير كلمة المرور فعلياً

```dart
onPressed: () {
  Navigator.pop(context);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح'), ...),
  );
},
```

**التأثير:** المستخدم يعتقد أن كلمة مروره تغيّرت بينما لم يحدث شيء، وهذا يُشكّل ثغرة في أمن المستخدم.

---

## القسم الثاني: المشاكل العالية (P1 — High)

---

### [P1-01] غياب Directionality Wrapper في معظم الصفحات
**الصفحات المتأثرة:** جميع الصفحات عدا `checkout_work_log_form.dart`

**الوصف:**
`checkout_work_log_form.dart` يستخدم `Directionality(textDirection: TextDirection.rtl, ...)` بشكل صريح، لكن باقي الصفحات لا تفعل ذلك. الاعتماد على إعدادات RTL الخارجية دون تحديدها صراحةً يعني أن أي تغيير في إعداد `main.dart` أو في السياق قد يكسر اتجاه الواجهة في تلك الصفحات.

**الإصلاح المقترح:**
التأكد من أن `main.dart` يحدد `locale: const Locale('ar')` و `supportedLocales` بشكل صحيح، أو إضافة Directionality wrapper في الـ MaterialApp.

---

### [P1-02] الشاشة الرئيسية: Welcome Card لا تدعم RTL بشكل صحيح
**الصفحة:** `home_page.dart`
**الموقع:** `_buildHomeTab`، الـ Row الخاص بـ Welcome Card

**الوصف:**
الـ Row يضع صورة الملف الشخصي أولاً (يسار)، ثم الاسم والترحيب (يمين). في RTL، صورة الملف الشخصي يجب أن تكون على اليمين والنص على اليسار.

المشكلة الأدق: `crossAxisAlignment: CrossAxisAlignment.start` في الـ Column المحتوي للاسم يعمل صحيحاً لأنه يسار في LTR ويمين في RTL — لكن الـ Row الأب مرتب بـ LTR منطق.

**الإصلاح المقترح:**
استخدام `Row` مع مراعاة أن Flutter يعكس `Row` تلقائياً في RTL. المشكلة الرئيسية هي استخدام `SizedBox(width: 16)` بدل `SizedBox.fromSize` أو `gap` منطقي. مراجعة أن الـ avatar يظهر على اليمين في RTL.

---

### [P1-03] AttendanceCard: الساعة الكبيرة تعرض AM/PM بالعربية بدون اختبار
**الصفحة/Widget:** `attendance_card.dart`
**الموقع:** السطر 145

```dart
DateFormat('hh:mm:ss a', 'ar').format(DateTime.now()),
```

**الوصف:**
استخدام `locale: 'ar'` مع format يحتوي على `a` (AM/PM) قد يُنتج نصاً عربياً طويلاً مثل "صباحاً" أو "مساءً" بدلاً من "ص"/"م"، مما قد يكسر تنسيق الساعة الكبيرة (font size: 48) على شاشات صغيرة. على بعض إصدارات `intl` هذا يُنتج فراغاً أو نصاً غير متوقع.

**الإصلاح المقترح:**
اختبار على أجهزة حقيقية، أو تحويل الـ format إلى `HH:mm:ss` (24 ساعة) لتفادي مشكلة AM/PM، أو التحقق من format الـ intl المستخدمة.

---

### [P1-04] CheckIn Dialog: الـ Eligibility Check لا يعمل تلقائياً
**الصفحة/Widget:** `attendance_card.dart`
**الموقع:** دالة `_showCheckInDialog`، داخل `showModalBottomSheet`

**الوصف:**
عند فتح الـ BottomSheet لتسجيل الحضور، يظهر خيار "مكتب" محدداً افتراضياً، لكن التحقق من الموقع لا يبدأ تلقائياً — المستخدم يجب أن يضغط على زر "التحقق من الموقع" يدوياً. هذا يضيف خطوة احتكاك غير ضرورية.

**السلوك الحالي:** المستخدم يفتح الـ dialog ويرى زر "التحقق من الموقع" ويجب أن يضغط عليه
**السلوك المتوقع:** عند تحديد "مكتب" (وهو الافتراضي)، يجب بدء التحقق تلقائياً

**الإصلاح المقترح:**
إضافة `checkEligibility()` في `initState` أو عبر `WidgetsBinding.instance.addPostFrameCallback` عند ظهور الـ sheet إذا كان نوع العمل "مكتب".

---

### [P1-05] LeavesPage في HomePage: الـ Balance Header يسبب overflow على الشاشات الصغيرة
**الصفحة:** `home_page.dart`
**الموقع:** `_buildLeavesTab`، الـ Container الخاص بـ Balance Summary، السطر 566

**الوصف:**
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: state.balances.map((balance) {
    return Column(children: [...]);
  }).toList(),
),
```
إذا كان لدى الموظف 4 أو 5 أنواع إجازات مختلفة، تُعرض كلها في صف واحد أفقي بدون scrolling وبدون ضمان عدم الـ overflow. على شاشات بعرض 320px ستظهر الأرقام ضيقة جداً أو تتداخل.

**الإصلاح المقترح:**
استبدال الـ Row بـ `Wrap` أو `SingleChildScrollView` أفقي، أو تحديد عدد max من 3 أنواع تُعرض في الـ header.

---

### [P1-06] ApprovalsPage: زر الرفض لا يتحقق من إدخال السبب
**الصفحة:** `approvals_page.dart`
**الموقع:** دالة `_showRejectDialog`

**الوصف:**
حقل "سبب الرفض" في dialog الرفض لا يمتلك `required` validator. المشرف يمكنه رفض طلب إجازة بدون كتابة أي سبب، مما يُخلف الموظف بدون توضيح.

**الإصلاح المقترح:**
إضافة validation تُلزم بكتابة سبب لا يقل عن 10 أحرف قبل تفعيل زر الرفض.

---

### [P1-07] HomePage: History Tab يعرض أحدث 10 سجلات فقط بدون إشعار
**الصفحة:** `home_page.dart`
**الموقع:** دالة `_buildHistoryList`، السطر 442

```dart
final recentRecords = records.take(10).toList();
```

**الوصف:**
السجل مقطوع عند 10 عناصر بصمت. لا يوجد نص يُخبر المستخدم بأن هناك المزيد، ولا زر "عرض المزيد" داخل القائمة ذاتها (الزر "عرض الكل" موجود في header لكنه بعيد عن نهاية القائمة).

**الإصلاح المقترح:**
إضافة عنصر أخير في القائمة (footer item) يشير إلى المزيد، أو عرض رسالة مثل "يعرض آخر 10 سجلات — اضغط عرض الكل للمزيد".

---

### [P1-08] Splash Page: بدون animation ولا splash screen احترافي
**الصفحة:** `splash_page.dart`

**الوصف:**
شاشة البداية تعرض أيقونة `Icons.access_time_rounded` (أيقونة ساعة Material عامة) بدلاً من شعار التطبيق الحقيقي. صفحة الـ Login تعرض `logo.png` الفعلي، لكن صفحة الـ Splash لا تستخدمه. كما لا توجد أي entrance animation على العناصر.

**الإصلاح المقترح:**
استخدام `Image.asset('assets/images/logo.png')` كما في `login_page.dart`، وإضافة `FadeTransition` أو `ScaleTransition` بسيطة.

---

## القسم الثالث: المشاكل المتوسطة (P2 — Medium)

---

### [P2-01] CreateLeavePage: استخدام print() في production
**الصفحة:** `attendance_card.dart`
**الموقع:** السطر 670

```dart
print('Check-in requested with workType: $selectedWorkType');
```

**الوصف:**
`print()` يُرسل بيانات إلى console في production وهو ممارسة غير مستحسنة أمنياً ومؤثر على الأداء.

**الإصلاح المقترح:** حذف السطر أو استبداله بـ `debugPrint()`.

---

### [P2-02] الـ Typography: استخدام `TextStyle` مباشر بدون الـ Theme
**الصفحات المتأثرة:** `home_page.dart`، `attendance_card.dart`، `leaves_page.dart`

**الوصف:**
كثير من النصوص تُعرَّف بـ `TextStyle` مباشرة بدلاً من استخدام `Theme.of(context).textTheme`. هذا يجعل تغيير Typography مستقبلاً صعباً لأنه يتطلب تعديل كل `TextStyle` يدوياً. مثال:

```dart
// الأسلوب الحالي (يتكرر عشرات المرات):
const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)

// الأسلوب الموصى به:
Theme.of(context).textTheme.titleLarge
```

---

### [P2-03] AttendanceCard: الـ Countdown يعتمد على 8 ساعات ثابتة
**الصفحة/Widget:** `attendance_card.dart`
**الموقع:** دالة `_buildCountdownDisplay`، السطر 367

```dart
const standardWorkHours = 8;
```

**الوصف:**
ساعات العمل القياسية ثابتة على 8 ساعات في الكود مع تعليق:
```dart
// Standard work day is 8 hours (can be adjusted based on settings)
```
لكن لا يوجد أي آلية للجلب من الـ settings. هذا يعني أن الموظف ذو 6 ساعات عمل سيرى "وقت إضافي" بعد 6 ساعات بينما الأصح يكون بعد 8.

**الإصلاح المقترح:**
جلب ساعات العمل المقررة من إعدادات الموظف أو الـ attendance policy.

---

### [P2-04] LeavesPage (standalone): لا يوجد error state كامل
**الصفحة:** `leaves_page.dart`
**الموقع:** `_buildRequestsTab`، السطر 98

```dart
return const SizedBox();
```

**الوصف:**
عند حدوث `LeavesError`، الـ builder يعيد `SizedBox()` فارغاً بدلاً من عرض رسالة خطأ مع زر إعادة المحاولة. SnackBar يظهر لكنه يختفي بسرعة وتبقى الصفحة فارغة بالكامل.

**الإصلاح المقترح:**
إضافة معالجة صريحة لـ `LeavesError` في builder تعرض error state مع زر retry.

---

### [P2-05] Home Page Leaves Tab: duplicate leave view بين المسارين
**الوصف:**
المستخدم يمكنه الوصول لطلبات الإجازة عبر:
1. تبويب "الإجازات" في الـ BottomNavigationBar (يفتح صفحة منفصلة `LeavesPage`)
2. تبويب "الإجازات" داخل `HomePage` نفسه (`_buildLeavesTab`)

كلاهما يعرض نفس المحتوى بتنفيذ مختلف. `_buildLeavesTab` في HomePage لا يحتوي على filter chips مثل `LeavesPage` المستقلة، مما يجعل التجربة غير متسقة.

**الإصلاح المقترح:**
توحيد التجربة: إما حذف التبويب من HomePage واستخدام `LeavesPage` مباشرة، أو جعل `_buildLeavesTab` يعرض نفس الـ filter chips وكامل المحتوى الموجود في `LeavesPage`.

---

### [P2-06] CreateLeavePage: لا يمنع اختيار تاريخ بداية في الماضي
**الصفحة:** `create_leave_page.dart`
**الموقع:** دالة `_selectStartDate`

**الوصف:**
```dart
firstDate: DateTime.now(),
```
هذا صحيح في `_selectStartDate`، لكن القيمة الأولية `_startDate = DateTime.now()` تعني أن المستخدم يمكنه بدء الإجازة من اليوم نفسه. في حال نظام العمل يتطلب تقديم الطلب قبل X أيام، لا توجد أي validation أو تنبيه.

**الإصلاح المقترح:** إضافة تنبيه (غير ملزم) عند اختيار تاريخ بدء قريب جداً، مثل "هذا الطلب يحتاج موافقة، تأكد من التقدم مبكراً."

---

### [P2-07] ProfilePage: معلومات القسم تعرض ID بدلاً من الاسم
**الصفحة:** `profile_page.dart`
**الموقع:** السطر 339

```dart
_buildInfoRow(Icons.business, 'القسم', user.departmentId ?? 'غير محدد'),
```

**الوصف:**
يُعرض `departmentId` (على الأرجح UUID أو رقم مثل `a3f7...`) للمستخدم بدلاً من اسم القسم الحقيقي. هذا يُنتج عرضاً محرجاً مثل "القسم: a3f7b2c1-..."

**الإصلاح المقترح:**
عرض `user.departmentName` (إذا كانت موجودة في الـ model) أو جلب اسم القسم من الـ API.

---

### [P2-08] CheckoutWorkLogForm: ساعات العمل لا تُقارن بالساعات الفعلية
**الصفحة/Widget:** `checkout_work_log_form.dart`

**الوصف:**
المستخدم يُدخل ساعات العمل لكل مشروع يدوياً. لا يوجد أي تحقق بأن إجمالي الساعات المُسجَّلة يتطابق تقريباً مع ساعات الحضور الفعلية (check-in حتى الآن). يمكن للمستخدم تسجيل 20 ساعة بينما حضر 4 ساعات فقط.

**الإصلاح المقترح:**
تمرير ساعات الحضور الفعلية للـ `CheckoutWorkLogForm` وعرض تحذير عند التجاوز الكبير.

---

### [P2-09] ApprovalsPage: لا يوجد تمييز بصري لأولوية الطلبات
**الصفحة:** `approvals_page.dart`

**الوصف:**
جميع طلبات الإجازة تُعرض بنفس التنسيق بغض النظر عن نوعها. طلب إجازة طارئة (emergency) يظهر بنفس مظهر الإجازة السنوية الاعتيادية. لا يوجد sorting واضح مشروح للمستخدم.

**الإصلاح المقترح:**
إضافة badge أو border مميز للطلبات الطارئة، وإظهار كم يوماً مضى على الطلب بشكل بارز.

---

### [P2-10] HomePage: الـ Quick Actions لا تعرض أي Badge للإشعارات المعلقة
**الصفحة:** `home_page.dart`
**الموقع:** `_buildQuickAction` لـ "طلبات الموافقة"

**الوصف:**
زر "طلبات الموافقة" في Quick Actions المُوجَّه للمشرفين لا يُظهر عدد الطلبات المعلقة. المشرف لا يعرف إذا كان لديه 0 أو 10 طلبات تنتظره.

**الإصلاح المقترح:**
إضافة Badge فوق أيقونة "طلبات الموافقة" يعرض عدد الطلبات المعلقة.

---

### [P2-11] NotificationsPage: "قراءة الكل" بدون أي تأثير وظيفي
**الصفحة:** `notifications_page.dart`
**الموقع:** السطر 17

```dart
onPressed: () {
  // Mark all as read
},
```

**الوصف:**
زر "قراءة الكل" لا يفعل شيئاً وهو ظاهر للمستخدم. هذا يُقلل الثقة في التطبيق.

**الإصلاح المقترح:**
إما إخفاء الزر حتى يكتمل تنفيذه، أو ربطه بـ BLoC يُغيّر حالة الإشعارات.

---

### [P2-12] التناقض في ألوان SnackBars
**الصفحات المتأثرة:** `attendance_card.dart`، `leaves_page.dart`، `profile_page.dart`

**الوصف:**
بعض الـ SnackBars تستخدم `Colors.green` و`Colors.red` المباشرة بدلاً من `AppTheme.successColor` و`AppTheme.errorColor`:

```dart
// في leaves_page.dart:
backgroundColor: Colors.green   // يجب أن يكون AppTheme.successColor
backgroundColor: Colors.red     // يجب أن يكون AppTheme.errorColor

// في profile_page.dart:
backgroundColor: Colors.green   // يجب أن يكون AppTheme.successColor
backgroundColor: Colors.red     // يجب أن يكون AppTheme.errorColor
```

هذا يعني أن تغيير اللون الأخضر في الـ theme لن ينعكس على هذه الـ SnackBars.

---

## القسم الرابع: المشاكل المنخفضة (P3 — Low)

---

### [P3-01] SplashPage: نص "نظام الحضور" فقط — الاسم الكامل غير مستخدم
**الصفحة:** `splash_page.dart`

**الوصف:**
`LoginPage` تعرض "Webstdy HR" كاسم للتطبيق، بينما `SplashPage` تعرض "نظام الحضور" فقط. التناقض في التسمية يُشوّش هوية التطبيق.

**الإصلاح المقترح:** توحيد الاسم في كلا الصفحتين.

---

### [P3-02] LoginPage: عنوان التطبيق "Webstdy HR" بدون Tajawal font
**الصفحة:** `login_page.dart`
**الموقع:** السطر 182

```dart
const Text(
  'Webstdy HR',
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppTheme.primaryColor,
  ),
),
```

**الوصف:**
هذا النص لا يحدد `fontFamily: 'Tajawal'` ولا يستخدم `GoogleFonts.tajawal()`. بينما الثيم العام يُحدد Tajawal لجميع النصوص، الـ `TextStyle` المباشر يمكن أن يتجاوز هذا الإعداد على بعض المنصات.

---

### [P3-03] LeavesPage: غياب حالة فارغة (Empty State) مع call-to-action في تبويب "رصيدي"
**الصفحة:** `leaves_page.dart`
**الموقع:** دالة `_buildBalanceContent`، السطر 419

**الوصف:**
عند عدم وجود رصيد إجازات، تُعرض رسالة بسيطة "لا يوجد رصيد إجازات" بدون توجيه المستخدم لأي إجراء. لا يوجد زر للتواصل مع HR أو معلومات إضافية.

**الإصلاح المقترح:**
إضافة توجيه مثل "تواصل مع قسم الموارد البشرية لمعرفة رصيد إجازاتك".

---

### [P3-04] AttendanceCard: الـ Break Timer لا يُظهر الحد الأقصى للاستراحة
**الصفحة/Widget:** `attendance_card.dart`
**الموقع:** دالة `_buildCountdownDisplay`، قسم الاستراحة

**الوصف:**
عداد الاستراحة يعرض المدة التي مضت فقط بدون أي إشارة إلى الحد الأقصى المسموح به للاستراحة. الموظف لا يعرف إذا كان يتجاوز وقت استراحته.

**الإصلاح المقترح:**
إضافة progress indicator دائري أو تنبيه عند الاقتراب من نهاية وقت الاستراحة المقرر (إذا كانت هذه المعلومة متاحة من الـ settings).

---

### [P3-05] CheckoutWorkLogForm: Font Family مُضمَّن يدوياً بدلاً من الثيم
**الصفحة/Widget:** `checkout_work_log_form.dart`

**الوصف:**
الـ form يُحدد `fontFamily: 'Tajawal'` يدوياً في عدة TextStyle بدلاً من الاعتماد على الـ Theme:
```dart
style: TextStyle(fontFamily: 'Tajawal', ...)
```
هذا تكرار غير ضروري.

---

### [P3-06] TeamAttendancePage: السطر الفاصل بين تفاصيل الحضور والانصراف ضيق جداً
**الصفحة:** `team_attendance_page.dart`
**الموقع:** `_TeamMemberCard`

**الوصف:**
في `_TeamMemberCard`، المعلومات الزمنية (check-in/check-out) مفصولة بـ `SizedBox(width: 16)` فقط. على الشاشات الصغيرة، أسماء الموظفين الطويلة قد تتداخل مع معلومات الحضور.

---

### [P3-07] ProfilePage: لا يوجد تأكيد قبل حذف/تغيير صورة الملف الشخصي
**الصفحة:** `profile_page.dart`

**الوصف:**
عند الضغط على "اختيار من المعرض" أو "التقاط صورة"، يبدأ الرفع مباشرة دون تأكيد. لا توجد خطوة preview للصورة قبل رفعها.

**الإصلاح المقترح:**
إضافة شاشة preview بسيطة تسمح للمستخدم بالتأكيد أو الإلغاء قبل رفع الصورة.

---

### [P3-08] ApprovalsPage: لا يوجد pagination
**الصفحة:** `approvals_page.dart`

**الوصف:**
قائمة الطلبات تُحمَّل بالكامل دفعة واحدة. في حال المشرف لديه 50+ طلب معلق، سيكون الأداء بطيئاً وتجربة التمرير طويلة.

---

### [P3-09] تناقض في border-radius بين الـ components
**الصفحات المتأثرة:** عدة صفحات

**الوصف:**
بعض الـ cards تستخدم `BorderRadius.circular(12)` والبعض `circular(16)` بدون نمط واضح. الـ Theme يُحدد `circular(16)` للـ CardTheme لكن كثير من الـ containers تستخدم `circular(12)` مباشرة:

- `attendance_card.dart`: بعض عناصره تستخدم `12` وبعضها `20`
- `approvals_page.dart`: `circular(12)` و`circular(20)` و`circular(8)` في نفس الصفحة
- `leaves_page.dart`: `circular(12)` و`circular(8)` و`circular(20)`

**الإصلاح المقترح:** توحيد القيم في design tokens داخل `AppTheme`:
```dart
static const double radiusSm = 8.0;
static const double radiusMd = 12.0;
static const double radiusLg = 16.0;
static const double radiusPill = 20.0;
```

---

## القسم الخامس: ملاحظات Accessibility

| الصفحة | المشكلة | الأولوية |
|--------|---------|---------|
| جميع الصفحات | غياب `Semantics` أو `Tooltip` على أزرار الأيقونات (مثل زر الإشعارات في AppBar) | P2 |
| `attendance_card.dart` | أزرار الحضور/الانصراف/الاستراحة تمتلك `padding: vertical: 16` = 48dp وهو مقبول، لكن في حال الضغط عليها من الحافة قد يكون أصغر | P3 |
| `checkout_work_log_form.dart` | حقول الإدخال تمتلك `Tooltip: 'إغلاق'` على زر الإغلاق فقط — باقي العناصر بدون Semantics | P2 |
| `team_attendance_page.dart` | `CircleAvatar` يعرض أول حرف من الاسم بدون alt text للـ screen reader | P3 |
| `login_page.dart` | `CheckboxListTile` للـ biometric يستخدم `controlAffinity: leading` — في RTL هذا يضع الـ checkbox على اليسار، لكن في RTL يجب أن يكون على اليمين (يمكن استخدام `trailing`) | P1 |

---

## القسم السادس: ملاحظات الأداء

| الصفحة | المشكلة | الأولوية |
|--------|---------|---------|
| `attendance_card.dart` | `StreamBuilder` يعيد بناء الـ widget كل ثانية حتى بعد الانصراف (`record.isCheckedOut = true`) | P2 |
| `home_page.dart` | `IndexedStack` يُبقي جميع التبويبات الـ 4 في الذاكرة في نفس الوقت. مناسب للتبديل السريع لكنه يستهلك ذاكرة أكثر | P3 |
| `notifications_page.dart` | قائمة الإشعارات لا تستخدم `ListView.builder` مع `itemExtent` ثابت، مما يُبطئ الـ rendering على القوائم الطويلة | P3 |

---

## قائمة الإجراءات المُرتَّبة حسب الأولوية

### أسبوع 1 — إصلاحات حرجة (P0)

1. **[P0-01]** إصلاح اتجاه أسهم التنقل بالتاريخ في `team_attendance_page.dart`
2. **[P0-02]** إصلاح `chevron_left` إلى `chevron_right` في `profile_page.dart` لـ settings rows
3. **[P0-03]** ربط `notifications_page.dart` بـ API حقيقي أو إخفاؤها مؤقتاً
4. **[P0-04]** إضافة تحقق حقيقي وـ API call لتغيير كلمة المرور في `profile_page.dart`

### أسبوع 2 — إصلاحات عالية (P1)

5. **[P1-05]** إصلاح احتمال overflow في Leave Balance header على الشاشات الصغيرة
6. **[P1-01]** التحقق من إعداد RTL على مستوى MaterialApp
7. **[P1-06]** إضافة validation على سبب الرفض في `approvals_page.dart`
8. **[P1-04]** تفعيل Location Check التلقائي عند فتح Check-In dialog
9. **[P1-08]** استبدال أيقونة الـ Splash بشعار التطبيق الحقيقي
10. **[P0-05 / Accessibility]** تصحيح اتجاه `CheckboxListTile` في `login_page.dart` لـ RTL

### أسبوع 3 — إصلاحات متوسطة (P2)

11. **[P2-01]** حذف `print()` من `attendance_card.dart`
12. **[P2-04]** إضافة error state كامل لـ `leaves_page.dart`
13. **[P2-05]** توحيد تجربة صفحة الإجازات في HomePage مع `LeavesPage` المستقلة
14. **[P2-07]** عرض اسم القسم بدلاً من ID في `profile_page.dart`
15. **[P2-10]** إضافة Badge لعدد الطلبات المعلقة على Quick Action "طلبات الموافقة"
16. **[P2-11]** إخفاء أو تفعيل زر "قراءة الكل" في `notifications_page.dart`
17. **[P2-12]** توحيد ألوان SnackBars لاستخدام `AppTheme` tokens

### أسبوع 4 — Polish وتحسينات (P3)

18. **[P3-09]** توحيد قيم `border-radius` في `AppTheme` كـ design tokens
19. **[P3-01]** توحيد اسم التطبيق في SplashPage
20. **[P3-07]** إضافة preview قبل رفع صورة الملف الشخصي
21. **[P3-04]** إضافة حد أقصى للاستراحة في Break Timer
22. **[P2-02]** تحويل inline TextStyle إلى Theme.of(context).textTheme تدريجياً
23. **[P2-08]** ربط ساعات العمل المُسجَّلة بالساعات الفعلية في CheckoutWorkLogForm
24. **[P3-05]** حذف `fontFamily: 'Tajawal'` المكرر من CheckoutWorkLogForm
25. **[P1-07]** إضافة footer في History Tab يُخبر المستخدم بأن السجل مقطوع

---

## ملخص الإحصائيات

| المستوى | العدد |
|---------|-------|
| P0 — Critical | 4 |
| P1 — High | 8 |
| P2 — Medium | 12 |
| P3 — Low | 9 |
| **المجموع** | **33** |

---

## ملاحظة ختامية

التطبيق بُني بأساس جيد ويتبع معايير Flutter الحديثة مع استخدام BLoC pattern بشكل صحيح. المشاكل الرئيسية تتمركز في:

1. **RTL**: بعض الأسهم والاتجاهات لم تُعالج بشكل كامل
2. **الصفحات غير المكتملة**: الإشعارات وتغيير كلمة المرور تعمل كـ placeholder فقط
3. **التناسق**: بعض القيم مثل border-radius وألوان SnackBars غير موحدة

إصلاح المشاكل الـ P0 وP1 كافٍ لإطلاق نسخة مستقرة. مشاكل P2 وP3 تُحسّن جودة التجربة وتُقلل التقنية الدين (technical debt) على المدى البعيد.
