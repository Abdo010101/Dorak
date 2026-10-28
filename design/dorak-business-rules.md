# دورك (Dorak) Patient App: Business Rules and Flows

> **Purpose:** A single source of truth that any AI agent or developer can read to understand the Dorak patient app flows and continue the work without guessing.
> **Last updated:** 2026-10-20
> **Status:** v1 scope: Splash, Authentication, Home (nearby medical centers). Items marked **TBD** need a product decision. Do not implement them by assumption.

## 0. How to use this file (instructions for AI agents)

1. Treat this file as the **behavior spec**, and treat the Figma file and `design/design-tokens.md` as the **visual spec**.
2. Build **only** what is described here. Do not invent screens, modules, business rules, copy or data.
3. If something is marked **TBD**, leave a clear placeholder or `TODO(TBD)` and ask the product owner. Never fill the gap with an assumption.
4. All names, addresses, distances, phone numbers and images in the mockups are **sample content**, not product data.
5. When a rule here conflicts with older docs (for example `Medical_App_Initial_Flows_Claude.md`), **this file wins**, because it includes later product-owner decisions (see §11).

### Reference assets

| Asset | Location |
|---|---|
| Figma mockups (20 screens) | https://www.figma.com/design/jA3JQXye9DbBrxzNkEj9nf (WebSTDY Team) |
| PDF mockups | `design/Dorak_UI_Mockups_v1.pdf` |
| Mockup source (rebuild with `sh design/mockups/render.sh`) | `design/mockups/build.py`, `design/mockups/mockups.css` |
| Design tokens (colors, type, spacing, components) | `design/design-tokens.md` |
| Accessibility notes | `design/accessibility-review.md` |
| App logo | `design/mockups/brand/logo.png` |
| Original flow spec | `Medical_App_Initial_Flows_Claude.md` (superseded where this file differs) |

---

## 1. Product summary

- **App name:** «دورك». Use this exact Arabic spelling. The English brand spelling is **TBD**. Do not write "Dawrak" or "Dorak" in user-facing UI.
- **Platform:** Mobile (iOS and Android), Flutter.
- **Market:** Saudi Arabia.
- **Primary user:** A patient looking for nearby medical centers.
- **Core value:** Show the user's location first, let them filter by medical specialty, and list the nearby medical centers.

## 2. Golden rules (never break these)

1. **Guest first.** Opening the app, viewing Home, granting location, changing location, browsing centers and filtering by specialty **never** require sign-in.
2. **No login wall.** Splash always goes to Home. It never goes to Authentication.
3. **Authentication is a separate, optional flow.** It opens only when the user explicitly chooses to sign in, or (in the future) when they try an action that needs an account. Which actions need an account is **TBD**. Do not invent gates on booking, favorites or similar.
4. **One language at a time.** Show only the active-language field (`name_ar` **or** `name_en`, `description_ar` **or** `description_en`). Never show both together.
5. **No fake data.** Never show a fabricated location, distance, count, rating or result list. If a value is not available, hide that row.
6. **Location is requested at the point of need.** Explain why before the system prompt, and always offer a manual location alternative.
7. **Arabic RTL is the baseline.** English LTR is supported for the key screens.

## 3. Information architecture

```text
App launch
  → Splash
  → Home (guest or signed-in)                     ← bottom nav tab 1
      ├─ Location header → Location picker (map)
      ├─ Specialty chips (filter)
      └─ Nearby center cards → Center details (TBD, out of scope)
  Bottom navigation:
      1. الرئيسية  Home           (specified)
      2. المواعيد  Appointments   (TBD: tab exists, screen not specified)
      3. العروض    Offers         (TBD: tab exists, screen not specified)
      4. الإعدادات Settings       (TBD: tab exists, screen not specified)

Authentication (separate, optional):
  Explicit sign-in entry / future account-required action
  → Auth entry → Phone (OTP) | Apple | Google
  → Signed-in → restore previous context, or Home
```

**Out of scope for v1 (do not build):** center details, booking, payment, profile, saved centers, reviews, map view of results, push notification flows, onboarding carousel, and the content of the Appointments, Offers and Settings tabs.

---

## 4. Flow A: Splash

| Item | Rule |
|---|---|
| Background | White (`#FFFFFF`) |
| Content | Dorak logo centered (`brand/logo.png`) |
| Loader | Blue (`#014AE0`) circular spinner near the bottom. Show it **only** if initialization is actually slow. |
| Status bar | Not drawn in the mockups. The real app must still respect device safe areas. |

**Navigation logic**
- First launch or signed out → **Home in guest mode**.
- Already signed in → **Home in signed-in mode**.
- Initialization failure → non-blocking error with retry. Never block Home behind it.

Figma: `1:2`

---

## 5. Flow B: Authentication (optional)

### B1. Authentication entry
**Shown only** when the user chooses to sign in. It is never shown automatically.

Layout, top to bottom:
1. Back button (returns to the previous guest context)
2. Logo
3. Heading `أهلًا بك في دورك` with subtitle `سجّل الدخول أو أنشئ حسابًا للمتابعة.`
4. Primary button: `المتابعة برقم الجوال` (Continue with phone number)
5. Divider `أو`
6. `المتابعة باستخدام Apple` (black, official Apple branding)
7. `المتابعة باستخدام Google` (outlined, **official multicolor Google "G"**)
8. Footer link: `المتابعة كزائر` (Continue as guest) → back to Home

**Rules**
- Terms and privacy links stay **hidden** until approved URLs and copy exist.
- Apple and Google buttons must follow each provider's official branding rules.
- After successful sign-in → return to the pending destination if one exists, otherwise Home. **Keep the selected location and specialty.**

Figma: AR `2:2`, EN `3:2`

### B1.1 Apple / Google hand-off states

| State | Behavior | Figma |
|---|---|---|
| Signing in | Native provider sheet, then a loading overlay `جارٍ تسجيل الدخول باستخدام Apple…` while the session is created | `4:2` |
| Cancelled by user | Neutral **info** banner: `تم إلغاء تسجيل الدخول. يمكنك المحاولة مجددًا أو المتابعة كزائر.` Nothing is blocked. | `5:2` |
| Provider failure | **Error** banner (DS error color `#B54708`) and the user can retry | `6:2` |

### B2. Phone number entry
- Country code fixed to `+966`. The number is displayed LTR inside the RTL layout.
- Validation (copy is illustrative): the field must not be empty, and the number must be a valid Saudi mobile number (starts with `5`). Error message: `أدخل رقم جوال سعودي صحيح يبدأ بـ 5.`
- States: empty (button disabled), invalid, sending (button spinner, field locked), network error (banner; keep the entered number).
- **Note:** This screen was **removed from mockup v1** at the product owner's request. Whether phone entry remains a separate screen or merges into another step is **TBD**. The B1 phone button currently leads to OTP.

### B3. OTP verification (proposed, pending backend confirmation)
- **4-digit** code. Focus moves to the next cell automatically.
- Shows the masked number (`+966 5•• ••• •67`) and a `تغيير الرقم` (Change number) link.
- Resend: countdown first (sample `00:45`, real value from backend), then the `إعادة إرسال الرمز` link.
- `تحقق` (Verify) stays disabled until all 4 digits are entered.

| State | Behavior | In mockup |
|---|---|---|
| Empty | First cell focused, countdown running | Yes `7:2` |
| Invalid code | Cells get the error border, message `الرمز غير صحيح. تحقق منه وحاول مرة أخرى.`, resend available | Yes `8:2` |
| Success | Tick icon, `تم التحقق بنجاح`, then auto-redirect to Home or the pending destination | Yes `9:2` |
| Verifying | Button spinner, cells locked | Implement (not drawn) |
| Expired code | Error message, resend available | Implement (not drawn) |
| Rate limited | Error banner; resend locked; wait time from backend | Implement (not drawn) |
| Network error | Banner; keep the code so the user can tap Verify again | Implement (not drawn) |

**TBD:** Is phone sign-in passwordless OTP? Does the first successful verification create the account, or are profile fields needed? **Do not build a registration form until this is decided.**

---

## 6. Flow C: Home (discover nearby medical centers)

### 6.1 Layout, top to bottom (fixed order)
1. **Location header:** pin icon, label (`موقعك الحالي` / `الموقع المختار`), locality (for example `الرياض، حي النرجس`), chevron. Tapping it opens the location picker. Long text is truncated, and the full value goes to the accessibility label.
2. **Specialties:** heading `التخصصات الطبية`, then horizontal chips. `الكل` comes first, followed by the backend specialty list.
3. **Nearby centers:** heading `المراكز الطبية القريبة منك`, then a vertical list of center cards. Show a result count **only** if the backend provides one.
4. **Bottom navigation bar** (4 tabs, Home active):

| Index | Arabic label | English label | Icon | Status |
|---|---|---|---|---|
| 0 | الرئيسية | Home | home | Specified (this screen) |
| 1 | المواعيد | Appointments | calendar | **TBD** |
| 2 | العروض | Offers | discount / ticket | **TBD** |
| 3 | الإعدادات | Settings | settings / gear | **TBD** |

- Active tab: primary blue `#014AE0`, bold label, small top indicator. Inactive tabs: grey `#A3A3A3`.
- In RTL, index 0 sits on the **right**. In LTR it sits on the **left**.
- Whether the Appointments, Offers and Settings tabs require sign-in is **TBD**. Do not gate them by assumption.

### 6.2 Filtering semantics
- The **selected location** decides geographic relevance.
- The **selected specialty** narrows the results **within** that location's result set.
- `الكل` (All) means every specialty near the selected location.
- Example: location Riyadh + specialty Dentistry → dentistry centers in or near Riyadh, **not** all dentistry centers in Saudi Arabia.
- Changing the specialty refreshes the results for the **same** location.
- Changing the location refreshes the results for the **new** location and **keeps** the selected specialty.
- Tapping `الكل` clears the specialty filter.
- Order by proximity **if** the backend supports it.
- **TBD:** search radius or definition of "nearby", server sort order, and whether a multi-specialty center matches each of its specialties.

### 6.3 Home interaction logic
1. Home opens (guest or signed in). If location permission is unresolved, show the explanation state. Never show authentication first.
2. Permission granted → get position → resolve the locality → fetch specialties and centers → render.
3. Permission denied or services off → explanation plus a manual location CTA. **Never** show a fake nearby list.
4. Tap the location header → location picker (map with pin, search field for city or district, "my location" button, `تأكيد الموقع` confirm).
5. Tap a specialty → update the selected chip → refresh the results.
6. Tap a center card → **TBD** (center details are out of scope).

### 6.4 Home states

| State | Behavior | Figma |
|---|---|---|
| Results (AR) | Normal list | `10:2` |
| Results (EN) | LTR, English data fields only | `11:2` |
| Specialty selected | Chip highlighted, filtered list | `12:2` |
| Permission not requested | Header shows `حدّد موقعك`. Block: `اعرض المراكز القريبة منك`, explanation, buttons `السماح بالوصول للموقع` (primary) and `اختيار الموقع يدويًا` | `13:2` |
| Permission denied | Block: `لم يتم السماح بالوصول للموقع`. Buttons: `اختيار الموقع يدويًا` (primary) and `فتح الإعدادات` | `14:2` |
| Resolving location | Header spinner `جارٍ تحديد موقعك…`. Card skeletons. No address shown until one resolves. | `15:2` |
| Manual location | Header label changes to `الموقع المختار` | `16:2` |
| Loading centers | Card skeletons | `17:2` |
| Specialties failed | Only `الكل` is shown, plus inline error and `إعادة المحاولة`. Centers still work. | `18:2` |
| No centers near location | `لا توجد مراكز طبية قريبة من هذا الموقع`, button `تغيير الموقع` | `19:2` |
| Location picker | Map, pin, search, confirm sheet | `20:2` |
| Location services off | Same pattern as Permission denied, with button `فتح إعدادات الجهاز` | Implement (not drawn) |
| Loading specialties | Chip skeletons; centers load independently | Implement (not drawn) |
| No centers for specialty | `لا توجد مراكز … قريبة منك`, button `عرض الكل`, chip stays selected | Implement (not drawn) |
| Network / server error | Error block with `إعادة المحاولة`. Retry keeps the location and specialty. | Implement (not drawn, removed from mockup at product owner's request) |

If no specialties exist at all, show only `الكل`.

---

## 7. Medical center card: data contract

**Display order:** cover image (distance badge on top) → name → specialty tags → city · address → description excerpt → doctors count + call button.

| Source field | Shown as | Rule |
|---|---|---|
| `medical_center_image` | Cover image, 12px radius | Use a neutral fallback icon if missing |
| `name_ar` / `name_en` | Title, max 2 lines | **Active language only** |
| specialty (discovery data) | Tint tags, can be several | Mapping is **TBD** |
| `city` · `address` | Pin icon + 1 truncated line | Do not invent translations |
| distance (computed) | Badge on the image (`2.4 كم`) | Only if it can be calculated; otherwise hide it |
| `description_ar` / `description_en` | 2-line excerpt ending in "…" | **Active language only** |
| `doctor_count` | `8 أطباء` with group icon | Only if the value is valid; otherwise hide it |
| `phone` | Tint button with call icon; number shown LTR | Tap-to-call if implemented |
| `coordinates` | Not displayed | Used for proximity only. **No map inside the card.** |

- **Never** show both languages. If the active-language value is missing, use a fallback agreed with the product owner (**TBD**). Never show both values.
- **Do not add** ratings, prices, opening hours or a booking button.
- Full text values go to accessibility labels.

---

## 8. Global UX rules

- **Safe areas:** respect the notch, status bar, home indicator and keyboard. The status bar is not drawn in the mockups, but the real app must still respect it.
- **Touch targets:** at least 44px. Buttons are 48px high.
- **Numbers and phone numbers** are always rendered LTR, even inside RTL text.
- **Back chevron** points right in RTL and left in LTR.
- **Disabled state** is 50% opacity.
- **Errors** use the DS error color `#B54708`. **Success** uses `#067647`.
- **Fonts:** Tajawal (Arabic), Plus Jakarta Sans (Latin).
- **Primary color:** `#014AE0`. The logo is green. Whether to align the brand colors is **TBD** with the designer.

## 9. Visual tokens (summary)

See `design/design-tokens.md` for the full list.

| Token | Value |
|---|---|
| Primary | `#014AE0` |
| Primary tint | `#EBF1FE` |
| Text primary / secondary | `#1D1D1D` / `#6D6D6D` |
| Field surface / border | `#FAFAFA` / `#E5E5E5` |
| Error / Success | `#B54708` / `#067647` |
| Skeleton | `#EFEFEF` |
| Radius | 12px (fields, buttons, chips, cards) |
| Spacing scale | 4 · 6 · 8 · 12 · 16 · 24 · 32 |

## 10. Open decisions (TBD)

| # | Question | Current handling |
|---|---|---|
| 1 | Which action requires an account? | Auth is a standalone flow, not linked to any gate |
| 2 | Is phone sign-in passwordless OTP? Are profile fields needed on first sign-in? | Drawn as a 4-digit OTP with no registration form |
| 3 | Is the phone-entry screen kept as a separate step? | Removed from mockups. OTP is shown directly. |
| 4 | Content and access rules of the Appointments, Offers and Settings tabs | Tabs exist in the nav; screens not specified |
| 5 | Is the whole v1 bilingual? | Key screens are drawn in AR and EN |
| 6 | Location selection method (city/district list, typed address, map pin)? | Map picker with search is drawn |
| 7 | Definition of "nearby" (radius, city, backend ranking)? | Distance shown only if the backend provides it |
| 8 | Specialty list, and can a center have several? | The card supports several tags |
| 9 | What happens on tapping a card? | Center details are out of scope |
| 10 | Fallback when the active-language value is missing | Must be agreed. Never show both languages. |
| 11 | English brand spelling | Not approved; use «دورك» |
| 12 | Brand colors: green logo vs blue primary | Needs a designer decision |
| 13 | Google "G": the DS glyph is monochrome, but Google requires the multicolor mark | Use the official multicolor mark |

## 11. Change log (product-owner decisions)

| Date | Decision |
|---|---|
| 2026-10-11 | Mockups v1 created from the original flow spec |
| 2026-10-20 | Status bar removed from all mockup screens |
| 2026-10-20 | **Bottom navigation added to Home**: الرئيسية · المواعيد · العروض · الإعدادات. This overrides the original spec's "no bottom navigation". |
| 2026-10-20 | Each mockup page limited to 2–3 screens |
| 2026-10-20 | OTP reduced to one page (Empty, Invalid, Success) |
| 2026-10-20 | Phone-number-entry screen removed from mockups |
| 2026-10-20 | Network/server error state removed from the Home mockup page (the app must still handle it) |
| 2026-10-20 | Real logo added. Splash is now white with a blue loader. |
| 2026-10-20 | Figma file created in WebSTDY Team |
