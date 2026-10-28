---
name: fullup-ui-kit
description: Fullup shared UI catalog and hard UI rules — which ui_kit widget, text style, spacing, icon and toast to use, plus RTL layout rules. Load before writing or reviewing any widget or page.
---

# Fullup UI kit

One import gives everything: `import 'package:fullup_ui_kit/fullup_ui_kit.dart';`
Barrel: `packages/ui_kit/lib/fullup_ui_kit.dart`. Sources: `packages/ui_kit/lib/src/`.

**Rule zero: look in the barrel before building any widget.** If ui_kit has it, use
it. If it is close, use it and say what is missing. A custom widget in an app is the
last resort, and a widget two apps need belongs in ui_kit, not copied.

## Hard rules

| Need | Use | Never |
|------|-----|-------|
| Text field | `FullupInput`, `FullupPhoneInput`, `FullupPinCodeField` | raw `TextField` / `TextFormField` |
| OTP | `FullupOtpInput` | hand-built boxes |
| Button | `FullupButton` (`FullupButtonStyle`, `FullupButtonSize`) | `ElevatedButton`, `TextButton`, `InkWell` + `Container` |
| Feedback message | `FullupToast.show(context, type: FullupToastType.success, message: ...)` (`success`, `error`, `info`, `warning`) | `SnackBar`, `ScaffoldMessenger` |
| Confirmation | `FullupConfirmDialog.show(...)` | `AlertDialog` |
| Result / status dialog | `FullupStateDialog.show(...)`, `FullupSuccessView` | custom dialogs |
| Bottom sheet | `showFullupBottomSheet(...)` + `FullupBottomSheetHeader` | `showModalBottomSheet` |
| Money in SAR | `RiyalAmount(amount: ..., style: ...)` | `'$x ر.س'`, `'SAR'` text, a riyal icon by hand |
| Text style | `AppTextStyles.*` (+ `.copyWith`) | `TextStyle(...)` |
| Colour | `AppColors.*` | `Color(0xFF...)`, `Colors.*` |
| Gap | `verticalSpace(AppSpacing.md)`, `horizontalSpace(AppSpacing.sm)` | `SizedBox(height: 12)` |
| Padding / radius / shadow | `AppSpacing.*`, `AppRadius.*`, `AppShadows.*` | magic numbers |
| Icon / image | `AppIcons.*`, `AppImages.*` (assets in `packages/ui_kit/assets/`) | copying an asset into an app |
| Back navigation | `FullupBackArrow`, `FullupPageBackHeader` | inline `Icon(Icons.arrow_back)` |
| Empty state | `FullupEmptyStateView(message: ...)` | ad hoc centered `Text` |
| Error state | `FullupErrorRetryView(onRetry: ...)` | ad hoc error column |
| Loading | page / section → `FullupLoadingView` (`.sliver` in a `CustomScrollView`); known list / card layout → `FullupSkeleton` / `FullupSkeletonList` (`.sliver` in a `CustomScrollView`); blocking action → `FullupLoadingOverlay`; button → `FullupButton(isLoading: true)`. Screen-reader label defaults to `'common.loading'.tr()`: every app must have `common.loading` | raw `CircularProgressIndicator` / `LinearProgressIndicator` for page or section loading, a shimmer package |

`AppSpacing`: `xs2`=2, `xs`=4, `sm`=8, `md`=12, `lg`=16, `xl`=20, `xl2`=24 … `xl7`=64,
plus `screenHorizontal`, `screenPadding`, `cardPadding`, `sectionGap`, `allSm/allMd/allLg`.

A new icon: check `packages/ui_kit/assets/icons/` first; if missing, add it there and
to `AppIcons`, not to the app.

## Catalog

| Group | Widgets |
|-------|---------|
| Buttons | `FullupButton`, `FullupBackArrow`, `FullupBackButton`, `FullupFilterButton` |
| Inputs | `FullupInput`, `FullupOtpInput`, `FullupPhoneInput`, `FullupPinCodeField`, `FullupCountrySelector`, `FullupCheckbox`, `FullupRadio<T>`, `FullupToggle`, `FullupQuantityControl`, `FullupImageUploadField`, `LatinDigitsInputFormatter` |
| Cards | `FullupAppCard`, `FullupOperationCard`, `FullupOperationStrip`, `FullupProductCard`, `VehiclePlate` |
| Display | `FullupLabelValueRow`, `FullupCountBadge`, `FullupUserGreeting`, `RiyalAmount`, `FullupScanFrame` |
| Filters | `FullupTag` (`FullupTagTone`), `FullupFilterChips`, `FullupDotLabel`, `FullupDateRangePicker`, `FullupPeriodSelector`, `FullupFilterExportRow` |
| Dialogs | `FullupToast`, `FullupConfirmDialog`, `FullupStateDialog`, `FullupSuccessView`, `showFullupDialog` |
| Sheets | `showFullupBottomSheet`, `FullupBottomSheetHeader`, `FullupBottomSheetDropdown<T>`, `FullupOptionSheet<T>` |
| Navigation | `FullupBottomNavBar`, `FullupHomeHeader`, `FullupPageBackHeader`, `FullupTabBar`, `FullupSegmentedControl<T>`, `FullupCategoryTab`, `FullupMenuTile`, `FullupSettingsTile` |
| Layout | `FullupEmptyStateView`, `FullupErrorRetryView`, `FullupLoadingView`, `FullupLoadingOverlay`, `FullupLoader` (`FullupLoaderSize`), `FullupSkeleton`, `FullupSkeletonBox`, `FullupSkeletonLine`, `FullupSkeletonCircle`, `FullupSkeletonList`, `FullupSkeletonListItem`, `FullupDirectionalFlip`, `verticalSpace`, `horizontalSpace`, `FadePageTransitionBuilder` |
| Theme | `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius`, `AppShadows`, `AppIcons`, `AppImages`, `AppTheme` |

The barrel is the source of truth: if a name here is missing from it, the barrel wins.
Open the widget's source for its parameters instead of guessing them.

## RTL — Arabic is primary

Flutter flips `Row` children automatically in RTL, and Figma shows the screen already flipped.

- Write `Row` children in **logical (start → end) order**. If Figma shows the icon on
  the right in Arabic, the icon is the *first* child.
- Check each row: "after Flutter flips this, does it match Figma?"
- Never reach for `CrossAxisAlignment.end` or `TextAlign.right` to push content to the
  Arabic side. Default `start` already lands on the right in RTL.
- Use directional APIs: `EdgeInsetsDirectional`, `AlignmentDirectional`,
  `PositionedDirectional`, `BorderRadiusDirectional`. Use absolute left/right only
  when something must not flip (e.g. chat bubble sides).
- Icons that imply direction go through `FullupBackArrow` / `FullupDirectionalFlip`.
- Numbers typed by the user: `LatinDigitsInputFormatter`.

## Screen checklist

- Four states: loading, success, empty, error with retry.
- Light and dark mode: colours only from `AppColors` / theme.
- Arabic, English and (Delivery, Worker) Urdu: no clipped or overflowing text with the longest copy.
- No business logic, API call or DTO in the widget: read state from the cubit, call cubit methods.
- Long lists use `ListView.builder`. Pull-to-refresh keeps the old content visible.
