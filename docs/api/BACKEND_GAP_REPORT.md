# Dorak Patient — Mobile vs API Gap Report (v2)

> **Source of truth:** Figma (`jA3JQXye9DbBrxzNkEj9nf`). Mobile UI on branch `ui-redesign` was built from it.
>
> **Compared against:** updated `docs/api/Dorak_Mobile_API_v2.postman_collection.json` (68 patient requests) + `docs/api/scope.md` (change log current to 2026-11-01).
>
> **Flip from the earlier report:** backend has now shipped almost everything the earlier gap report flagged. Of the previous 7 blockers, 6 are resolved by the updated API. **The remaining gaps are almost entirely on the mobile side.** This doc is now a mobile integration backlog, plus a short list of residual backend open questions (§16).
>
> **Severity:** `BLOCKER` — the feature cannot ship. `MAJOR` — feature degraded (missing data, extra client work). `MINOR` — polish or duplication.
>
> Patient app only. Doctor app (75 endpoints) is out of scope.

---

## 0. Platform-level

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 0.1 | Mobile base URL `https://dorak-app.com/api/patient/` (`lib/data/networks/network_constant.dart`) | Spec says `{host}/api/v2/patient/` (scope §10.0) | Mobile 404s against v2 | **BLOCKER** | **Mobile.** Switch base URL to `/api/v2/patient/`. Confirm per env. |
| 0.2 | Dio header `Content-language` set by `LanguageCubit` + `splash_page.dart` | Spec accepts `lang` query/body or `Content-Language` header; other values → 403 | Mobile uses lowercase `l` — HTTP headers are case-insensitive but confirm no proxy normalizes | MINOR | Mobile. Switch to canonical `Content-Language: ar\|en` for safety. |
| 0.3 | Mobile sends phone from `phone_page.dart` with `+966` dial chip | API accepts `5XXXXXXXX` / `05XXXXXXXX` / `+9665XXXXXXXX`; stored as `05XXXXXXXX` | Fine. No gap. | — | — |
| 0.4 | Mobile uses `BaseResponse<T>` everywhere | `/patient/current` stays raw by design; `/patient/profile` returns the wrapped form (backend answer Q4) | Parsing exception on `/patient/current` only | MINOR | **Mobile.** Prefer `GET /patient/profile` wherever the envelope is wanted; keep a `rawCurrent()` call for `/patient/current` only where raw is actually needed. |
| 0.5 | Rate limiting | 60 req/min per client; OTP throttles 3/account + 20/IP per 10 min (send) and 5/account + 30/IP per 10 min (verify); over limit → 429 with `Retry-After` | Mobile ignores `Retry-After`; OTP page uses a local 45 s timer only | MAJOR | Mobile. Honor `429` + `Retry-After` on `send-otp` / `check-otp`; show user-visible wait. |

---

## 1. Auth & onboarding
Screens: splash (`201:1334`), welcome (`201:1345`), phone (`201:1422`+`352:3204`), otp (`201:1471`+`202:1445`), complete profile (`352:3260`), signed-in (`352:3321`).

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 1.1 | Dead clients `POST login`, `POST register`, `POST change-password/{phone}` (`lib/data/networks/clients/auth_client.dart`) | Removed from v2 (scope §9.1) | Stale | MINOR | **Mobile.** Delete methods + `LoginRequest`/`RegisterRequest` + any references. |
| 1.2 | After OTP, route to complete-profile vs home based on `is_new_user` + `profile_completed` | `POST /patient/check-otp` returns `{token, is_new_user, profile_completed, patient}` ✓ | `UserResponse { token, patient }` missing both booleans (`login_response.dart`) | **MAJOR** | **Mobile.** Add fields, drive routing. |
| 1.3 | Splash hydration (`AuthCubit.loadCurrentUser` → persisted session) | Prefer `GET /patient/profile` (wrapped envelope, backend answer Q4). `/patient/current` stays raw if needed. | No mobile client | MAJOR | **Mobile.** Add `/patient/profile` client; call it from splash. |
| 1.4 | Change-phone CTA on profile | `POST /patient/change-phone {phone}` ✓ then re-sends OTP | Mobile client exists; no UI binding | MAJOR | **Mobile.** Wire to UI. |
| 1.5 | Delete-account destructive link on `personal_info_page.dart` | `POST /patient/delete-account` ✓ | No mobile client | **MAJOR** | **Mobile.** Add client + confirm dialog. |
| 1.6 | Resend OTP on `otp_page.dart` after 45 s | `POST /patient/resend-otp` ✓ | No mobile client | MAJOR | **Mobile.** Add client. |
| 1.7 | Social sign-in (Apple/Google) on `welcome_page.dart` | `POST /patient/social-login {provider, id_token, fcm_token, name?}` returns `{token, is_new_user, profile_completed, patient}` | Mobile sends `{email, name, social_id, fcm_token}` — wrong field set | **BLOCKER** | **Mobile.** Replace `LoginWithSocialRequest`. |
| 1.8 | OTP verify | `POST /patient/verify {otp}` ✓ | `AuthenticationClient.verifyOtp(body)` ✓ | — | — |
| 1.9 | OTP mock (`AuthCubit._mockAuth = true`) short-circuits auth | — | Dev-only; must be flipped off when wiring real API | MAJOR | **Mobile.** Remove flag. |

---

## 2. Home tab
Screen: `home_page.dart` (`171:509`).

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 2.1 | Location pill in top header | `GET /patient/home` returns `location` ✓ | `HomeResponse` missing `location` | **MAJOR** | **Mobile.** Add field; use it instead of running `LocationService` on every build. |
| 2.2 | Bell with unread badge | `/patient/home` returns `unread_notifications_count` ✓ | Missing on model | MAJOR | **Mobile.** Add field. |
| 2.3 | Specialty chip row (currently hardcoded) | `/patient/home` returns `specializations` ✓ | Missing on model | **MAJOR** | **Mobile.** Add field, render from response. |
| 2.4 | Nearest medical centers (4) + nearest clinics (4) grids | `/patient/home` returns `nearest_medical_centers`, `nearest_clinics` ✓ | `HomeResponse` has only `bestDoctors, latestOffers, patientReservations` | **MAJOR** | **Mobile.** Add both arrays. |
| 2.5 | Latest offers row | `/patient/home` returns `latest_offers` (each has `place`) | Mobile `OfferResponse` missing `place`, `city`, `from_date`, `to_date`, `is_price_shown` | MAJOR | **Mobile.** Align model. See §14. |
| 2.6 | Home filter query params | API accepts `lat, lng, specialization_id, city_id, area_id` | Mobile sends none | MINOR | **Mobile.** Send after location + chip wiring. |
| 2.7 | Reverse-geocode device lat/lng → area_id for filters | `GET /patient/location?lat&lng` ✓ | No mobile client | MAJOR | **Mobile.** Add client; keep `LocationService` as fallback geocoder only. |

---

## 3. Discovery
Screens: `explore_page.dart` (`173:649`), `explore_map_page.dart` (`203:1881`), `location_picker_page.dart` (`203:1600`).

All backend endpoints exist. Pure mobile wiring work.

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 3.1 | Explore list — centers + clinics with filters | `GET /patient/medical-centers`, `GET /patient/clinics` paginated with full filter set ✓ | No mobile client; pages render `DiscoveryCentersMock` | **MAJOR** | **Mobile.** Add 2 clients + wire. |
| 3.2 | Explore map (up to 100 centers + 100 clinics within radius) | `GET /patient/explore/map` ✓ | No mobile client | **MAJOR** | **Mobile.** Add client. |
| 3.3 | Location picker — area search | `GET /patient/locations?search=` ✓ | No mobile client | **MAJOR** | **Mobile.** Add client. |
| 3.4 | "Nearest centers" inside location picker | `GET /patient/nearest-medical-centers` (paginated, default per_page 20, 1..100) ✓ | No mobile client | MAJOR | **Mobile.** Add client. |

---

## 4. Search
Screen: `search_results_page.dart` (`203:1690`+`352:3400`).

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 4.1 | Unified search returning specialties + centers + clinics | `GET /patient/search?search&lat&lng&specialization_id&per_page` returns `{specializations, medical_centers{total,data}, clinics{total,data}}` ✓ | `SearchCubit` wires to old `GET /patient/doctors`; UI renders hardcoded grid | **MAJOR** | **Mobile.** Migrate `SearchCubit` to `/patient/search` + render results. |
| 4.2 | Autocomplete / typeahead | `GET /patient/search-by-name?name&lat&lng` ✓ | Mobile client exists; no UI binding | MINOR | **Mobile.** Decide if §4.2 is still needed given §4.1; wire or drop. |

---

## 5. Medical center / Clinic / Doctors-at-center
Screens: `center_details_page.dart` (`175:861`), `clinic_details_page.dart` (`433:11943`), `doctors_at_center_page.dart` (`204:1933`).

All API endpoints exist. Pure mobile wiring.

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 5.1 | Center details page | `GET /patient/medical-centers/{id}?lat&lng` returns `card + description + images + doctors_count + specializations + offers + ratings{count,average,data} + is_favorite` ✓ | No mobile client; `CenterDetailsCubit` → `CenterMock.sample()` | **MAJOR** | **Mobile.** Add client + wire. |
| 5.2 | Clinic details | `GET /patient/clinics/{doctor_id}?lat&lng` ✓ | No mobile client; `ClinicDetailsCubit` → mock | **MAJOR** | **Mobile.** Add client + wire. |
| 5.3 | Doctors-at-center with specialty chip filter | `GET /patient/medical-centers/{id}/doctors?specialization_id` returns header counts, chips, `DoctorCardResource[]` ✓ | No mobile client; `DoctorsAtCenterCubit` → mock | **MAJOR** | **Mobile.** Add client + wire. |
| 5.4 | Specialties chip source for 5.3 | `GET /patient/medical-centers/{medical_center}/specializations` ✓ (also inlined in 5.3) | No mobile client | MINOR | **Mobile.** Use whichever path is more convenient; drop the other. |
| 5.5 | Favorite heart on top bar | `POST /patient/add-medical-center-to-favorite/{id}` + remove (and doctor + offer variants) ✓ | No mobile clients; heart is a stub | **MAJOR** | **Mobile.** Add 6 clients. See §9. |

---

## 6. Doctor profile
Screen: `doctor_profile_page.dart` (`204:2053`).

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 6.1 | Avatar, name, headline, rating + ratings_count, experience_years, patients_count, bio, bio_url, branches, services, contact_phone, is_favorite | `GET /patient/doctors/{doctor}` returns `{doctor, profile{headline, rating, ratings_count, experience_years, patients_count, bio, bio_url, branches, services, is_favorite, contact_phone}, places, ratings}` ✓ (contact_phone added 2026-11-01) | `DoctorProfileResponse { doctor, places, ratings }` has no `profile` block (`doctor_profile_response.dart`); UI reads `_doctorMock(doctorId)` | **BLOCKER** | **Mobile.** Add `profile` block to model + wire cubit to UI. See §14. |
| 6.2 | Offers tab | `GET /patient/doctors/{doctor}/offers` ✓ | `DoctorProfileClient.getDoctorOffers` exists; UI uses mock | MAJOR | **Mobile.** Wire to UI. |
| 6.3 | Place list + per-place rating | API `DoctorPlace` + `PlaceRatings` schemas | Mobile `Places` drifts | MAJOR | **Mobile.** Align. See §14. |

---

## 7. Booking flow (center + clinic)
Screens: step 1 `booking_specialty_doctor_page.dart` (`177:888`+`209:3151`), step 2 `booking_date_time_page.dart` (`438:12682`), step 3 `booking_review_page.dart` (`438:12762`), step 4 `booking_confirmed_page.dart` (`438:12824`).

Scope says the flow is `days → slots → preview → reservations` (scope §9.3 / §9.4).

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 7.1 | Step 2 day strip (28 days with status available/full/closed) | `GET /patient/booking/days` center: `doctor_id, medical_center_id` or `specialization_id, medical_center_id` for "any doctor"; clinic: `doctor_id` only ✓ | No mobile client; `AvailableAppointmentClient` targets old `{doctor_id}/available-schedules[/{id}]` | **BLOCKER** | **Mobile.** Add client for `/booking/days`. |
| 7.2 | Step 2 slots split morning/evening | `GET /patient/booking/slots {date (req), doctor_id, medical_center_id?, specialization_id?}` returns `{morning[], evening[]}` of `BookingSlot {time, label, available, doctor_id}` ✓ | No mobile client | **BLOCKER** | **Mobile.** Add client. |
| 7.3 | Step 3 preview without booking | `POST /patient/booking/preview {doctor_id, medical_center_id\|null, date, time}` returns full preview with `place.type`, `payment_type: cash`, `payment_method: الدفع في العيادة` ✓ | No mobile client | MAJOR | **Mobile.** Add client. |
| 7.4 | Step 4 create reservation | `POST /patient/reservations {doctor_id, medical_center_id\|null, date (Y-m-d), time ("h:i A"), note?, day_of_week?}` returns `PatientReservationResource` ✓ | `BookingCubit.confirm` posts correctly but step 4 UI never calls it | MAJOR | **Mobile.** Wire cubit to UI; drop static mock. |
| 7.5 | Clinic variant: no specialty step; `medical_center_id = null` | API supports both center + clinic shapes ✓ | `BookingCubit` has no clinic-vs-center branch | MAJOR | **Mobile.** Model the variant. |
| 7.6 | Doctor-profile availability view (next 4 weeks of weekly slots) | `GET /patient/{doctor_id}/available-schedules[/{medical_center_id}]` returns `TimeSlotsWeek[]` ✓; backend confirms (answer Q6) both this and `/booking/days`+`/booking/slots` stay supported | Mobile `AvailableAppointmentClient.getAvailableSchedules*` ✓ | — | Keep. Used for doctor-profile availability only; booking stepper uses §7.1 + §7.2. |
| 7.7 | Patient note on reservation | API accepts `note` on `POST /patient/reservations` (2026-11-01 change log) | Mobile body does not include `note` | MINOR | **Mobile.** Add optional `note` to request body + a textarea on review step if Figma shows one. |

---

## 8. My bookings
Screens: `appointments_page.dart` (upcoming `207:2279`, past `207:2407`, cancelled `307:2547`), details `booking_details_page.dart` (`208:2535`), rate sheet `rate_booking_sheet.dart` (`420:3794`+`419:3595`).

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 8.1 | List upcoming / past / cancelled, paginated | `GET /patient/reservations/upcoming\|past\|cancelled?page=` ✓; `upcoming` now excludes cancelled; `past` excludes cancelled | `AppointmentsCubit.load` calls `getAllAppointments('reservations/${tab.name}', pageKey:1)`. Confirm enum `name` really yields `upcoming\|past\|cancelled` | MINOR | **Mobile.** Verify; if fine, no gap. |
| 8.2 | Card renders booking number, place, date/time, service, status badge, status label, cancellation reason (on cancelled tab) | `PatientReservationResource` includes `booking_number, status, display_status, status_label, place{type,name,image,branch,phone,address,lat,lng}, date_label, time_label, service, payment_type, payment_method, can_cancel, can_reschedule, change_deadline, specialization, can_rate, cancellation` ✓ | `AppointmentResponse` is flat and legacy (`name, phone, status, rate, date, day, month, main_specialization, full_image_path`) | **BLOCKER** | **Mobile.** Replace `AppointmentResponse` with new resource. See §14. |
| 8.3 | Rate button on past cards gated by `can_rate` | `can_rate` on every row of upcoming/past/cancelled + on `/patient/reservations/{id}` (backend answer Q5); `true` only when `completed` AND patient has not yet reviewed the doctor; server flips it to `false` on all that doctor's rows after review | `AppointmentResponse` has no `can_rate`; UI shows button on every past row | MAJOR | **Mobile.** Add field + gate on `can_rate`. No local "already rated" flag — trust server. |
| 8.4 | Rate submit from `rate_booking_sheet.dart` | `POST /patient/ratings {doctor_id, rate (1..5), comment?}` ✓ one per doctor, requires `completed` | `RateClient.doctorRate` + `RateRequest` ✓ but sheet is not wired | MAJOR | **Mobile.** Wire sheet to a cubit using `RateClient`. |
| 8.5 | Cancel sheet with reason + optional note | `POST /patient/reservations/cancel-reservation {id, reason?, note?}`; reasons come from `general.cancellation_reasons[{key,label}]` ✓ | `AppointmentsCubit.cancel` posts `{id}` only; `GeneralResponse` has no `cancellation_reasons` | **MAJOR** | **Mobile.** Add field (§14) + enrich cancel body + build reason sheet. |
| 8.6 | Reschedule button on booking details | `POST /patient/reservations/{id}/reschedule {date, time}` keeps the same reservation id, moves it to the new date/time, sets `status: pending`, and returns the full reservation (backend answer Q1) | No mobile client; CTA is a stub | **BLOCKER** | **Mobile.** Add client. Update the row in place with the returned reservation — no refetch, no new id. |
| 8.7 | Booking details fetched fresh | `GET /patient/reservations/{id}` ✓ | Mobile reads `AppointmentResponse` from router `extra` | MAJOR | **Mobile.** Fetch on open. |

---

## 9. Favorites
Screen: `favourite_centers_page.dart` (`363:3887`) + heart affordances on center/clinic/doctor/offer details.

All API endpoints exist. Pure mobile wiring.

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 9.1 | 2-column grid of favorite centers (and future: doctors, offers) | `GET /patient/favorites?type=medical_center\|doctor\|offer` returns `FavoriteResource` ✓ | `FavouritesCubit.load()` returns `[]` after 150 ms; no client; no repo | **MAJOR** | **Mobile.** Add client + wire. |
| 9.2 | Add/remove favorite — center | `POST /patient/add-medical-center-to-favorite/{id}` + remove ✓ | No mobile client | **MAJOR** | **Mobile.** Add. |
| 9.3 | Add/remove favorite — doctor (clinic saved as the doctor) | `POST /patient/add-doctor-to-favorite/{id}` + remove ✓ | No mobile client | MAJOR | **Mobile.** Add. |
| 9.4 | Add/remove favorite — offer | `POST /patient/add-offer-to-favorite/{id}` + remove ✓ | No mobile client | MAJOR | **Mobile.** Add. |

Backend confirmed the 6-endpoint pattern stays (answer Q2); no consolidation planned.

---

## 10. Notifications
Screen: `notifications_page.dart` (`209:2971`+`352:3712`).

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 10.1 | Paginated list grouped Today / This week / Earlier | `GET /patient/notifications?page=` returns `NotificationResource {type, title, description, read_at, is_read, group, target, date_label}` ✓ | `NotificationModel` has only `{id, type, title, description, date}`; UI re-derives grouping from `date` | MAJOR | **Mobile.** Align model; drop client-side grouping. |
| 10.2 | "Mark all as read" button | `POST /patient/notifications/mark-all-as-read` ✓ | No mobile client; button is a stub | **MAJOR** | **Mobile.** Add client. |
| 10.3 | Per-item mark as read (tap or swipe) | `POST /patient/notifications/{notification_id}/mark-as-read` (UUID path) ✓ | No mobile client | MAJOR | **Mobile.** Add client. |
| 10.4 | Unread-only feed | `GET /patient/unread-notifications` ✓ | No mobile client | MINOR | **Mobile.** Optional — prefer `unread_notifications_count` from `/patient/home` (§2.2). |
| 10.5 | Toggle notifications setting on profile | `POST /patient/toggle-notifications {allow_notifications: 0\|1}` ✓ | `NotificationClient.updateNotificationsStatus` ✓ but `profile_page.dart` shows static "profile_enabled" label | **MAJOR** | **Mobile.** Drive label from profile; wire real toggle. |

---

## 11. Profile / personal info / change phone / delete
Screens: `profile_page.dart` (`209:2649`+`209:2842`), `personal_info_page.dart` (`209:3066`).

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 11.1 | Load profile card (name, full_phone, email, city, birth_date, gender, allow_notifications) | `GET /patient/profile` returns `PatientResource` with `full_phone, birth_date, city, allow_notifications` ✓ | Mobile `Patient` model drifts (see §14) | MAJOR | **Mobile.** Align model. |
| 11.2 | Update profile (every field optional) | `POST /patient/update-profile {name?, email?, gender?, birth_date?, city_id?}` ✓ | Mobile client ✓ but model must include `birth_date` + `city_id` | MAJOR | **Mobile.** See §14. |
| 11.3 | Delete account destructive link | `POST /patient/delete-account` ✓ (cancels upcoming, revokes tokens, soft-deletes) | No mobile client | **MAJOR** | **Mobile.** Add client + confirm dialog. |
| 11.4 | Change phone CTA | `POST /patient/change-phone {phone}` ✓ then re-sends OTP | `AuthenticationClient.changePhone` ✓ but no UI binding | MAJOR | **Mobile.** Wire to UI. |

---

## 12. Help & support
Screen: `help_support_page.dart` (`363:3756`).

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 12.1 | "Contact us" row opens WhatsApp with support number | `GET /patient/general` returns `whatsapp_number` ✓ | `GeneralResponse` has no `whatsapp_number` field | **MAJOR** | **Mobile.** Add field + build WhatsApp deep link. |
| 12.2 | Terms + privacy pages | `GET /patient/terms-of-service` + `GET /patient/privacy-policy` ✓ | Mobile clients ✓; no UI route | MINOR | **Mobile.** Add reader screen + link from help/support + welcome. |

---

## 13. Settings
Screens: `settings_page.dart`, `language_page.dart`, `app_review_page.dart`.

| # | UI need | API today | Gap | Severity | Owner / Fix |
|---|---|---|---|---|---|
| 13.1 | App review submits an **app** rating (stars + comment) | `POST /patient/app-ratings {rate (1..5), comment?}` ✓ | `AppReviewCubit.submit` calls `RateRepository.doctorRate` → hits `POST /patient/ratings` (doctor rating). Wrong endpoint. | **BLOCKER (bug)** | **Mobile.** Add `appRate` on `RateClient` pointing to `app-ratings`; switch cubit. |
| 13.2 | Language toggle | — | `LanguageCubit` sets Dio header + locale only | — | — |

---

## 14. Field-level resource diffs

### 14.1 `HomeResponse` ↔ `GET /patient/home`
- Mobile has: `bestDoctors, latestOffers, patientReservations`.
- API returns: `location, unread_notifications_count, specializations, latest_offers (with place), nearest_medical_centers (4), nearest_clinics (4), best_doctors (sponsored, 15), patient_reservations (5)`.
- Add: `location, unread_notifications_count, specializations, nearest_medical_centers, nearest_clinics`. **MAJOR**

### 14.2 `UserResponse` ↔ `POST /patient/check-otp` + `POST /patient/social-login`
- Mobile has: `token, patient`.
- API returns: `token, is_new_user, profile_completed, patient`.
- Add: `is_new_user, profile_completed`. **MAJOR**

### 14.3 `GeneralResponse` ↔ `GET /patient/general`
- Mobile has: `titles, main_specializations, cities`.
- API returns: `titles, cities, main_specializations, cancellation_reasons [{key,label}], whatsapp_number`.
- Add: `cancellation_reasons, whatsapp_number`. **MAJOR** (gates §8.5 and §12.1)

### 14.4 `DoctorProfileResponse` ↔ `GET /patient/doctors/{doctor}`
- Mobile has: `doctor, places, ratings`.
- API returns: `doctor, profile{headline, rating, ratings_count, experience_years, patients_count, bio, bio_url, branches[], services[], is_favorite, contact_phone}, places, ratings`.
- Add: whole `profile` sub-object. **BLOCKER** (gates §6.1)

### 14.5 `AppointmentResponse` ↔ `PatientReservationResource`
- Mobile has: `id, name, phone, status, rate, date, day, month, main_specialization, full_image_path`.
- API returns: `id, booking_number, status, display_status, status_label, place{type, name, image, branch, phone, address, lat, lng}, date_label, time_label, service, payment_type ("cash"), payment_method ("الدفع في العيادة"), can_cancel, can_reschedule, change_deadline, specialization {id,name}, can_rate (past only), cancellation {reason, label, note}`.
- Add: all of the above. Drop the legacy flat fields. **BLOCKER** (gates §8.2, §8.3, §8.6, §8.7, §8.5)

### 14.6 `Places` ↔ `DoctorPlace` + `PlaceRatings`
- Mobile has: `id, images, name, phone, description, short_address, long_address, lat, lng, examination_price, examination_duration, reservation_status`.
- API: `DoctorPlace` + `PlaceRatings` (see scope §11 for full field list). Price + duration are per place (2026-11-01 change log).
- Action: enumerate against scope §11 shapes; expect drift on `reservation_status` vs new 5-state model (`pending\|confirmed\|completed\|no_show\|cancelled`). **MAJOR**

### 14.7 `OfferResponse` ↔ `OfferResource`
- Mobile has: `id, main_pic, title, description, price_after, price_before, is_active, doctor`.
- API adds: `place`, `city`, `from_date`, `to_date`, `is_price_shown`, and offer `status` + `status_label`.
- Add missing fields. Hide price when `is_price_shown == false`. **MAJOR**

### 14.8 `NotificationModel` ↔ `NotificationResource`
- Mobile has: `id, type, title, description, date`.
- API adds: `read_at, is_read, group (today\|this_week\|earlier), target, date_label`.
- Add fields. Drop client-side grouping. **MAJOR** (gates §10.1)

### 14.9 Booking-schedule models
- Mobile has: `AvailableSchedulesResponse { schedules[].week[].time_slots[] }` — keep for doctor-profile availability (§7.6).
- API adds (for booking stepper): `BookingDay[]`, `BookingSlot {time, label, available, doctor_id}`.
- Action: add new models, do not delete the old one. **BLOCKER** (gates §7.1, §7.2)

### 14.10 `AllOffersResponse`
- Mobile has `offers: BaseResponse<List<OfferResponse>>, max_price, min_price` — wrong wrapper on `offers`.
- Backend confirms (answer Q3) the real shape is:
  ```
  data: {
    offers: { data: OfferResource[], links: PaginationLinks, meta: PaginationMeta },
    max_price,
    min_price
  }
  ```
  Inner `offers` is a Laravel paginator — it has `links` and `meta` but **no** `success`/`message`.
- Action: replace inner `BaseResponse<List<OfferResponse>>` with a paginator model (`data[]` + `links` + `meta`). **MAJOR** (silently parsing wrong today).

### 14.11 `Patient` ↔ `PatientResource` / `PatientModelRaw`
- Mobile has: `id, name, phone, email, gender, weight, height, allow_notifications, country_id, verified_at`.
- API/scope lists: `name, full_phone, email, city, birth_date, allow_notifications, …`.
- Add: `full_phone, birth_date, city`. Drop (not in v2 patient scope): `weight, height, country_id`. **MAJOR**

---

## 15. Dead endpoints — mobile must remove

Per scope §9.1, v2 patient no longer has:
- `POST /patient/login` → delete `AuthenticationClient.login` + `LoginRequest`.
- `POST /patient/register` → delete `AuthenticationClient.register` + `RegisterRequest`.
- `POST /patient/change-password/{phone}` → delete `AuthenticationClient.changePassword`.

No backend action.

---

## 16. Residual open questions for backend

(Short list — most previous questions are resolved by scope §9.14 and §10.0.)

Backend answers, checked against the code on 2026-11-01:

1. **Reschedule response:** Yes. `POST /patient/reservations/{id}/reschedule` keeps the same reservation id, moves it to the new date and time, and sets `status` to `pending`. The response is the full reservation, so mobile can update the row in place.
2. **Favorites consolidation:** Keep the 6 add/remove endpoints. They already work, so no change is planned. List favorites with `GET /patient/favorites?type=`.
3. **`AllOffersResponse` wrapping:** The nesting is real. The shape is `data.offers.data[]`, with `data.offers.links`, `data.offers.meta`, `data.max_price` and `data.min_price`. The inner `offers` object has no `success` or `message`, so model it as a paginated list, not as a second `BaseResponse`.
4. **`/patient/current` envelope:** It stays raw, with no envelope. For the wrapped form, use `GET /patient/profile`.
5. **`can_rate` guarantee:** Yes. `can_rate` is on every row of `upcoming`, `past` and `cancelled`, and on `GET /patient/reservations/{id}`. It is `true` only for a `completed` reservation when the patient has not reviewed that doctor. After a review it turns `false` on all of that patient's reservations with that doctor, so mobile needs no local "already rated" flag.
6. **Doctor-profile availability vs booking stepper:** Yes. Both are supported: `/patient/{doctor}/available-schedules/{medical_center?}` for the doctor-profile preview, and `/patient/booking/days` + `/patient/booking/slots` for the booking stepper.

---

## 17. Suggested mobile execution order

Round-robin by least-friction. All rounds are mobile-side; no backend blocking.

**Round 1 — base plumbing (BLOCKER).**
- §0.1 switch base URL to `/api/v2/patient/`.
- §0.2 header casing.
- §1.9 remove `_mockAuth` flag.
- §1.7 fix social-login body.
- §13.1 fix app-ratings bug.
- §15 delete dead clients.

**Round 2 — model extensions, high value, low surface area.**
- §14.3 `GeneralResponse` (unlocks §8.5 cancel sheet + §12.1 WhatsApp).
- §14.2 `UserResponse` (unlocks §1.2 OTP routing).
- §14.1 `HomeResponse` (unlocks §2 home wiring).
- §14.8 `NotificationModel` (unlocks §10.1).
- §14.11 `Patient` (unlocks §11.1 / §11.2).
- §14.5 `AppointmentResponse` → new reservation resource (unlocks all of §8).

**Round 3 — fast feature wiring on endpoints that already exist.**
- Favorites (§9).
- Notifications mark-read + toggle (§10.2, §10.3, §10.5).
- Delete-account, change-phone, resend-otp (§1.5, §1.4, §1.6).
- Help & support WhatsApp + T&C + privacy pages (§12).
- Rate sheet wiring (§8.4) + cancel sheet (§8.5).
- Home live data (§2) + reverse geocode (§2.7).

**Round 4 — detail-page replacements.**
- Center / clinic / doctors-at-center (§5) + favorites heart (§5.5).
- Doctor profile with new `profile` block (§6.1 + §14.4).
- Discovery screens (§3) + search (§4).

**Round 5 — biggest refactor.**
- New booking flow: `/booking/days` → `/booking/slots` → `/booking/preview` → `/reservations` (§7).
- My-bookings list + details + reschedule (§8.1, §8.2, §8.6, §8.7).

---

## 18. Out of scope

- All doctor-app endpoints (75). Doctor app is a separate repo.
- Admin dashboard scope items.
- Figma visual review — covered elsewhere.
- The code changes themselves. This doc is the backlog; follow-up tickets implement the mobile side.
