# دورك: Design Tokens

**Source:** Figma "Design System" (`YOXpQ9ovXe8cwaVBszRmOJ`), pages *Input Field* (`4002:1992`) and *Icons* (`4019:1933`).
**Labels used below:** **DS** means the value is read directly from Figma. **PROPOSED** means it is derived from DS values because the Design System has no such token or component yet. Every PROPOSED item needs designer approval.

## Colors
| Token | Value | Source | Used for |
|---|---|---|---|
| `border/border-primary` | `#014AE0` | DS | Primary brand blue; focused field border |
| focus ring | `rgba(1,74,224,0.08)`, 3px | DS | Focused field glow |
| `text/text-primary-paragraph` | `#1D1D1D` | DS | Labels, primary text |
| `global/text-default-disabled` | `#6D6D6D` | DS | Field values, secondary text |
| `black/50`, `colors/tertiary/25` | `#FAFAFA` | DS | Field background |
| field border | `#E5E5E5`, 1px | DS | Default field outline |
| `border/border-warning`, `text/text-warning` | `#B54708` | DS | Error state (border + message) |
| error ring | `rgba(209,82,39,0.08)` | DS | Error field glow |
| `border/border-success`, `text/text-success` | `#067647` | DS | Valid state |
| success ring | `rgba(6,118,71,0.08)` | DS | Valid field glow |
| `colors/base/white` | `#FFFFFF` | DS | Surfaces |
| primary tint | `#EBF1FE` | PROPOSED | Icon backgrounds, selected-chip hover; equals `#014AE0` at 8% over white |
| skeleton | `#EFEFEF` | PROPOSED | Loading placeholders |
| on-primary | `#FFFFFF` | PROPOSED | Text on primary buttons and chips |

## Typography
- **Latin font: Plus Jakarta Sans.** Source: DS (`font-family-text`).
- **Arabic font: Tajawal.** Source: PROPOSED. It's the app's current font, chosen by the product owner because Plus Jakarta Sans has no Arabic glyphs. IBM Plex Sans Arabic was tried and rejected because its final ي has no dots.

| Style | Size / line height | Weight | Source |
|---|---|---|---|
| Text md / Regular | 12 / 18 | 400 | DS |
| Text md / Semibold | 12 / 18 | 600 | DS (field label) |
| Text lg / Regular | 14 / 20 | 400 | DS (field value) |
| Text lg / Semibold | 14 / 20 | 600 | PROPOSED (card title, buttons) |
| Title sm | 16 / 24, semibold | 600 | PROPOSED (section headings) |
| Title md | 20 / 28, bold | 700 | PROPOSED (screen titles) |
| Display | 24 / 32, bold | 700 | PROPOSED (splash, auth welcome) |

## Shape and spacing
- **Radius:** 12px (DS, input field). PROPOSED: the same 12px for buttons, chips, cards and thumbnails.
- **Field:** 44px high, 16px horizontal padding, 6px between label and field (DS).
- **Disabled:** 50% opacity (DS).
- **Spacing scale:** 4 / 6 / 8 / 12 / 16 / 24 / 32. PROPOSED, extended from the DS values 6 and 16.
- **Touch targets:** at least 44px. Buttons are 48px high (PROPOSED).

## Components
| Component | Status | Notes |
|---|---|---|
| Input field: Text, Password, Select, Mobile Number, Email | DS | 7 states each: Default, Focused, Valid, Error, Filled, Disabled, Read Only |
| Mobile Number field | DS | `+966` prefix cell plus number; the right component for Phone Entry (B2) |
| Icons: Hicon Linear, 24px, about 460 | DS | Location, Location Cross, Map, Call, Group 1, Search, Category, Refresh, Wifi, Danger/Info/Tick/Time Circle, arrows |
| Apple and Google glyphs | DS (social icons) | The Google glyph is monochrome. **Google branding requires the official multicolor "G".** Needs designer confirmation. |
| Buttons: primary, secondary, provider | **PROPOSED** | Missing from DS |
| Specialty chip: normal, selected, disabled | **PROPOSED** | Missing from DS |
| Center card | **PROPOSED** | The DS "Cards" frame is empty |
| Location header | **PROPOSED** | Missing from DS |
| OTP input (4 cells) | **PROPOSED** | Built from field tokens; cell count follows the current app (4) |
| Skeleton loaders | **PROPOSED** | Missing from DS |
| Empty, error and permission state block | **PROPOSED** | Missing from DS |
| Logo | Placeholder | «دورك» text placeholder; the real logo has not been provided |
