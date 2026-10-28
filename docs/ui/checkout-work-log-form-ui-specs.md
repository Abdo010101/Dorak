# UI Specs: CheckoutWorkLogForm

**Feature**: Checkout Work Log  
**File**: `mobile/lib/features/work_log/presentation/widgets/checkout_work_log_form.dart`  
**Last Updated**: 2026-04-06

---

## Component: CheckoutWorkLogForm

### Purpose
A bottom sheet presented to the employee when checking out from work. It collects the work
location, one or more project entries (project, tasks description, hours spent), and an
optional notes field. On submission it calls the parent's `onSubmit` callback with a
`CreateWorkLogRequest`.

### Props
| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| projects | `List<ProjectModel>` | yes | - | All available projects for selection |
| onSubmit | `Function(CreateWorkLogRequest)` | yes | - | Called with the completed request on submit |
| onCancel | `VoidCallback?` | no | `Navigator.pop` | Called when the close button is tapped |

---

## Component: _LocationChip

### Purpose
Animated selection chip for choosing the work location (office / home / hybrid). Replaces
the plain `ChoiceChip` with a vertically-stacked icon + label layout that better communicates
meaning on small screens.

### States
- **Default**: Light grey background (#F9FAFB), grey border, grey icon and label.
- **Selected**: `AppTheme.primaryColor` background and border, white icon and label.
- **Transition**: 180ms `AnimatedContainer` on color and border.

### Responsive Behavior
- **Mobile**: Three chips in a single row, each `Expanded` with 4px horizontal padding.
- Each chip has a minimum height of ~60px (icon 20px + spacing + text 12px + vertical
  padding 10px top + 10px bottom) satisfying the 44px touch target requirement.

### Accessibility
- `GestureDetector` used — semantic label is derived from the `displayName` text inside.
- Icons are purely decorative (meaning is conveyed by the adjacent text label).

---

## Component: _HoursStepper

### Purpose
Replaces the plain numeric `TextField` for hours input. Provides decrement (−0.5) and
increment (+0.5) buttons flanking the text field so the user can adjust hours without
typing on mobile. Direct keyboard entry is still supported.

### Props
| Prop | Type | Description |
|------|------|-------------|
| controller | `TextEditingController` | Bound to the entry's hours value |
| focusNode | `FocusNode` | Focus management |
| onDecrement | `VoidCallback` | Subtracts 0.5, min 0.5 |
| onIncrement | `VoidCallback` | Adds 0.5, max 24.0 |
| onChanged | `ValueChanged<String>` | Triggers parent `setState` for total recalculation |

### States
- **Default**: Enabled decrement/increment buttons with coloured backgrounds.
- **Decrement button**: `AppTheme.errorColor` tint (red), disabled appearance when value is 0.5.
- **Increment button**: `AppTheme.successColor` tint (green).
- Clamp range: 0.5 – 24.0 hours.

### Accessibility
- Both stepper buttons are 44x44 px touch targets.
- The text field has a `suffixText: 'ساعة'` label so screen readers hear the unit.

---

## Component: _ProjectEntryCard

### Purpose
Displays a single project entry with a numbered badge (using the index), the selected
project name in the header, and three fields: project dropdown, tasks description
(multi-line), and hours stepper.

### States
- **Default**: White card with subtle shadow and border.
- **Focused field**: Field border changes to 2px `AppTheme.primaryColor`.
- **Delete**: `Icons.delete_outline_rounded` in `AppTheme.errorColor` at top-right,
  44x44 touch target.

### Responsive Behavior
- Fills the full scroll column width.
- Tasks description field uses `maxLines: 3` to avoid tall content being hidden.

---

## Component: _TotalHoursSummary

### Purpose
A contextual summary row that appears directly below the last project entry card. Shows
total hours as a pill badge and changes colour based on the value.

### States
- **Normal (<=10h)**: `AppTheme.successColor` with a check-circle icon.
- **Warning (>10h)**: `AppTheme.warningColor` with a warning icon — alerts the user to
  an unusually high total without blocking submission.

---

## User Flow: Checkout Work Log

### Steps
1. Employee taps "تسجيل الانصراف" on the home screen.
2. Bottom sheet slides up with the handle, title, and all form sections visible.
3. Employee selects work location by tapping one of the three location chips.
4. Employee taps "إضافة مشروع" (full-width dashed button in the empty state).
5. A project entry card appears. The employee:
   a. Optionally changes the project via the dropdown.
   b. Types the tasks description in the multi-line field.
   c. Adjusts hours using the stepper buttons or direct keyboard input.
6. The total hours summary pill appears below the card and updates live.
7. Employee optionally taps "إضافة مشروع آخر" (text button) to add more entries.
8. Employee fills optional notes field.
9. The submit button becomes active once all entries are valid.
10. Employee taps "تسجيل الانصراف".
11. A loading spinner replaces the button label.
12. Parent handles the response (success/error toasts are the parent's responsibility).

### Edge Cases
- No projects available from the API: "إضافة مشروع" button is disabled with the label
  "لا توجد مشاريع متاحة".
- All projects already selected: Tapping the add button shows a warning toast; the text
  button is hidden.
- Submit with incomplete fields: A validation hint appears above the button;
  a contextual snack bar is shown.
- Hours out of range: Stepper clamps between 0.5 and 24.0; text input accepts free
  entry (validated on submit).

---

## Accessibility Notes
- `Directionality(textDirection: TextDirection.rtl)` wraps the entire sheet, ensuring
  correct RTL layout independent of the surrounding scaffold.
- All icon-only interactive elements use `tooltip` for screen reader disclosure.
- Every interactive element is at least 44x44 px.
- Text contrast: all labels use `AppTheme.textPrimary` (#1F2937) on white — contrast
  ratio approximately 14:1, well above the 4.5:1 minimum.
- Secondary text uses `AppTheme.textSecondary` (#6B7280) on white — contrast ratio
  approximately 5.7:1, above the 4.5:1 minimum for normal text.
- Required fields are marked with a red asterisk (*) and a `_FieldLabel` with
  `isRequired: true`.
- The `maxLength: 300` counter on the notes field is surfaced to the user.

---

## Design Tokens Used
| Token | Value | Usage |
|-------|-------|-------|
| `AppTheme.primaryColor` | `#2563EB` | Selected chips, field focus, add button, card badge |
| `AppTheme.secondaryColor` | `#1E40AF` | (available for hover/pressed states if needed) |
| `AppTheme.successColor` | `#10B981` | Total hours (normal), increment stepper button |
| `AppTheme.errorColor` | `#EF4444` | Delete button, decrement stepper button, required marker |
| `AppTheme.warningColor` | `#F59E0B` | Total hours (>10h), "all projects selected" toast |
| `AppTheme.textPrimary` | `#1F2937` | All primary labels |
| `AppTheme.textSecondary` | `#6B7280` | Hints, field labels, secondary text |
| `AppTheme.backgroundColor` | `#F3F4F6` | Bottom sheet background |
| `AppTheme.cardColor` | `#FFFFFF` | Section cards, project entry cards |

---

## Suggestions for Future Improvements
1. **Drag-to-reorder entries** — when the user has multiple projects, allow reordering
   via long-press drag (use `ReorderableListView`).
2. **Recent projects shortcut** — surface the last 3 projects used in a quick-select
   chip row above the dropdown to reduce taps.
3. **Hours presets** — add 1h, 2h, 4h, 8h quick-tap preset chips below the stepper.
4. **Auto-fill from draft** — if the user dismisses the sheet and reopens it, restore
   the in-progress entries from a local state cache.
5. **Haptic feedback** — add `HapticFeedback.lightImpact()` on stepper button taps.
