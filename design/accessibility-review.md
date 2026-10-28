## Accessibility Audit: دورك UI Mockups v1
**Standard:** WCAG 2.1 AA | **Date:** 2026-10-11 | **Scope:** `design/Dorak_UI_Mockups_v1.pdf` (Splash, Auth, OTP, Home and all its states)

### Summary
**Issues found:** 8 | **Critical:** 0 | **Major:** 3 | **Minor:** 5. Three of these (the placeholder contrast, the Arabic font and the chip height) are already fixed in v1.

### Findings

#### Perceivable
| # | Issue | WCAG | Severity | Recommendation |
|---|---|---|---|---|
| 1 | Field border `#E5E5E5` is 1.21:1 on `#FAFAFA`, so the outline of an empty field is hard to see. This value comes from the **DS**. | 1.4.11 Non-text contrast | 🟡 Major | Designer to darken the default field border to ≥ 3:1 (e.g. `#949494`), or rely on the label plus the filled surface. Not changed in the mockups because it is a DS value. |
| 2 | Placeholder `#A3A3A3` was 2.42:1 (PROPOSED value). | 1.4.3 Contrast | 🟡 Major | **Fixed.** The placeholder now uses DS `#6D6D6D` (4.96:1). |
| 3 | IBM Plex Sans Arabic drew final «ي» without dots («الطبي» looked like «الطبى»). | Legibility | 🟡 Major | **Fixed.** The Arabic font is now Tajawal. |
| 4 | Center thumbnails are photos. | 1.1.1 Non-text content | 🟢 Minor | Mark them decorative (the center name is already present), or use the name as alt text. |

#### Operable
| # | Issue | WCAG | Severity | Recommendation |
|---|---|---|---|---|
| 5 | Specialty chips were 36px high. | 2.5.5 Target size | 🟢 Minor | **Fixed.** Chips are now 40px, plus the 8px gap: implement a 44px hit area. |
| 6 | The phone number on the card is a small tap-to-call text link, about 18px high. | 2.5.5 Target size | 🟢 Minor | Give it a 44px hit area with padding, or make the whole footer row the target. |

#### Understandable
| # | Issue | WCAG | Severity | Recommendation |
|---|---|---|---|---|
| 7 | OTP and phone errors use color plus text ✅. Error banners need to be announced. | 3.3.1 Error identification | 🟢 Minor | Implement banners and field errors as live regions (`Semantics(liveRegion: true)`). |

#### Robust
| # | Issue | WCAG | Severity | Recommendation |
|---|---|---|---|---|
| 8 | Icon-only and state-bearing controls need names and states: the back button, the selected chip, the location header, and skeletons. | 4.1.2 Name, Role, Value | 🟢 Minor | See the Screen Reader table below. |

### Color Contrast Check
| Element | Foreground | Background | Ratio | Required | Pass? |
|---|---|---|---|---|---|
| Body / labels | #1D1D1D | #FAFAFA | 16.15:1 | 4.5:1 | ✅ |
| Secondary text, field values | #6D6D6D | #FAFAFA | 4.96:1 | 4.5:1 | ✅ |
| Secondary text on white | #6D6D6D | #FFFFFF | 5.17:1 | 4.5:1 | ✅ |
| Primary links, specialty line | #014AE0 | #FFFFFF | 6.87:1 | 4.5:1 | ✅ |
| Button label | #FFFFFF | #014AE0 | 6.87:1 | 4.5:1 | ✅ |
| Distance badge | #014AE0 | #EBF1FE | 6.07:1 | 4.5:1 | ✅ |
| Error text | #B54708 | #FFFFFF | 5.43:1 | 4.5:1 | ✅ |
| Error banner icon | #B54708 | #FEF4EE | 5.01:1 | 3:1 | ✅ |
| Success text | #067647 | #FFFFFF | 5.69:1 | 4.5:1 | ✅ |
| Field border (DS) | #E5E5E5 | #FAFAFA | 1.21:1 | 3:1 | ❌ |
| Disabled button | #FFFFFF | ~#80A4EF | 2.48:1 | exempt (inactive) | n/a |

### Screen Reader
| Element | Announced As | Note |
|---|---|---|
| Back button | «رجوع», button | Icon only; needs a label |
| Location header | «موقعك الحالي: الرياض، حي النرجس. تغيير الموقع», button | Full value even when the text is truncated |
| Specialty chip | «الأسنان», button, selected / not selected | Selection shown by more than color (fill + weight) ✅ |
| Center card | name, specialty, distance, then the address | The full address is read even when visually truncated |
| Skeletons | «جارٍ التحميل» once per section | Don't announce every skeleton line |
| OTP cells | One field: «رمز التحقق، 4 أرقام» | Use a single input with an autofill hint (`oneTimeCode`), not 4 separate fields |

### Priority Fixes
1. **Field border contrast (DS)** affects low-vision users trying to find inputs. Raise with the designer.
2. **Arabic font**: fixed by switching to Tajawal.
3. **Live regions and labels** during implementation (#7, #8). These are covered in the handoff spec.
