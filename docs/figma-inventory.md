# Figma Inventory — Dorak Patient

> Snapshot generated 2026-10-28 via Figma MCP (`mcp__figma-aslan__get_metadata`). Treat node ids as data for Phase 8 feature rebuilds. Refresh when Figma changes.

## Files

| File | fileKey | Entry node |
|---|---|---|
| Dorak — Patient App UI Mockups | `jA3JQXye9DbBrxzNkEj9nf` | `212:3046` (Page: Patient App UI) |
| Dorak — Design System | `YOXpQ9ovXe8cwaVBszRmOJ` | `4168:3273` (Variable Color Swatches) |

## Patient App — pages

| Page | Node id |
|---|---|
| Patient App UI | `212:3046` |
| Doctor App UI | `389:3828` |
| Archive | `0:1` |
| Logo | `23:6` |

## Patient App — sections (within `212:3046`)

| # | Section | Node id |
|---|---|---|
| 01 | الدخول والتسجيل — Authentication | `210:3046` |
| 02 | الاستكشاف — Discovery | `210:3070` |
| 03 | المركز والأطباء — Center & doctors | `210:3088` |
| 04 | الحجز — Booking | `210:3100` |
| 05 | الحساب والمتابعة — Account & follow-up | `210:3121` |
| 06 | طبقات النوافذ — Prototype overlays (sheets) | `350:3069` |

## Patient App — screens (390 px frames, filtered to screen prefixes)

### 01 Authentication
| Node id | Screen |
|---|---|
| `201:1334` | Auth 01 — Splash |
| `201:1345` | Auth 02 — Welcome |
| `201:1422` | Auth 03 — Phone number |
| `376:4496` | Auth 03 — Phone number (variant) |
| `352:3204` | Auth 03b — Phone invalid number |
| `201:1471` | Auth 04 — OTP |
| `292:8728` | Auth 04 — OTP valid code |
| `202:1445` | Auth 05 — OTP invalid code |
| `352:3260` | Auth 06 — Complete profile (new account) |
| `202:1598` | Auth 07 — Sign-in required (sheet) |
| `352:3321` | Auth 08 — Signed in |

### 02 Discovery
| Node id | Screen |
|---|---|
| `171:509` | Home — الرئيسية (AR) |
| `203:1600` | Discovery 02 — Location picker |
| `203:1690` | Discovery 03 — Search results |
| `352:3400` | Discovery 03b — Search no results |
| `173:649` | Explore — استكشف (AR) |
| `203:1881` | Discovery 05 — Explore map view |

### 03 Center & doctors
| Node id | Screen |
|---|---|
| `175:861` | Center Details — صفحة المركز (AR) |
| `204:1933` | Center 02 — Doctors at center |
| `204:2053` | Center 03 — Doctor profile |
| `363:3494` | Center 03b — Doctor profile · د. سارة الحسن |
| `363:3625` | Center 03c — Doctor profile · د. منى الزهراني |

### 04 Booking
| Node id | Screen |
|---|---|
| `177:888` | Booking 1 — Specialty & Doctor (AR) |
| `209:3151` | Booking 1b — Service (doctor preselected) (AR) |
| `205:2084` | Booking 2 — City & Branch (AR) |
| `178:978` | Booking 2 — Date & Time (AR) |
| `206:2176` | Booking 4 — Review & confirm (AR) |
| `206:2315` | Booking 5 — Confirmed (AR) |

### 05 Account & follow-up
| Node id | Screen |
|---|---|
| `207:2279` | Account 01 — My bookings · Upcoming |
| `207:2407` | Account 02 — My bookings · Past |
| `307:2547` | Account 02 — My bookings · canceled |
| `352:3602` | Account 02d — My bookings · canceled (after cancel) |
| `207:2525` | Account 03 — My bookings · Empty |
| `208:2535` | Account 04 — Booking details |
| `362:3487` | Account 04b — Booking details · pending |
| `208:2641` | Account 05 — Cancel booking (sheet) |
| `209:2649` | Account 06 — Profile (signed in) |
| `209:2842` | Account 07 — Profile (guest) |
| `209:2971` | Account 08 — Notifications |
| `352:3712` | Account 08b — Notifications · empty |
| `209:3066` | Account 09 — Personal info |
| `363:3887` | Account 10 — Favourite centers |
| `363:3756` | Account 11 — Help & support |
| `384:5265` | Account 11 — Help & support (variant) |

### 06 Prototype overlays (bottom sheets)
| Node id | Overlay |
|---|---|
| `350:3072` | Sign-in required |
| `350:3113` | Sign-in required · enter |
| `350:3134` | Sign-in required · exit |
| `350:3161` | Cancel booking |
| `350:3201` | Cancel booking · enter |
| `350:3226` | Cancel booking · exit |
| `350:3257` | Logout |
| `350:3297` | Logout · enter |
| `350:3322` | Logout · exit |
| `363:4080` | Language |
| `363:4037` | Language · enter |
| `363:4123` | Language · exit |
| `363:4218` | Filter · Specialty |
| `363:4172` | Filter · Specialty · enter |
| `363:4264` | Filter · Specialty · exit |
| `363:4357` | Filter · Area |
| `363:4316` | Filter · Area · enter |
| `363:4398` | Filter · Area · exit |
| `419:3551` | Rate booking |
| `420:3794` | Rate booking · typing |
| `419:3595` | Rate booking · success |

## Design System — pages

| Page | Node id | Scope |
|---|---|---|
| Input Field | `4002:1992` | 7 states per field type (DS) |
| Buttons | `4034:130` | Primary, Secondary, Provider, Icon |
| Icons | `4019:1933` | Hicon Linear, 24 px, ~460 icons |
| Calendar | `4013:2` | Date/time picker |
| Tooltip | `4019:1939` | Tooltip component |
| Chips & Badges | `4108:30` | Specialty chip + badges |
| Navigation | `4108:31` | App bar, bottom nav |
| Cards & Lists | `4108:32` | Center card, list rows |
| Booking | `4108:33` | Booking-specific molecules |
| Feedback & Controls | `4108:34` | Toasts, dialogs, switches |
| Variable Color Swatches | `4168:3273` | Color tokens |

## Scope delta (vs. current app `lib/ui/screens/`)

- Figma Patient App: **~55 unique screens** (excluding re-exports and overlay variants) across 5 sections + overlays. Current app: ~32 screens.
- Figma covers screens the current app does NOT yet have: Doctors-at-center, Doctor-profile variants, Favourite centers, Help & support, Notifications empty, Booking details · pending, Rate booking flow.
- Current app has features without Figma frames: social-login (Apple/Google/Facebook) specifics, phone-change, change-password, forget-password, best-doctors, app-review.
- Pattern-match current app behavior for non-Figma features per the plan. Treat overlays (section 06) as `AppBottomSheet` variants, not standalone routes.

## How to use

- Per Phase 8 feature PR, read the matching node ids via `mcp__figma-aslan__get_design_context` (load `figma-design-to-code` skill first).
- Use `mcp__figma-aslan__get_screenshot` for visual review attachments.
- Session ids rotate per task; `create_session` once per fileKey when a new feature starts.
