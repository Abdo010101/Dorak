# Dorak — Project Scope

Dorak ("your turn") is a medical appointment booking platform for the Saudi market. This document defines what the platform covers, what it does not, and the constraints that apply to the work. It is based on the documents in this folder (`BUSINESS_PATIENT_DOCTOR_APPS.md`, `Dorak_Tasks_Expanded.md`, `Dorak_DQA_03_02_04_05_Fix_Tasks.md`) and on the current v2 API routes.

The companion file `Dorak_Mobile_API_v2.postman_collection.json` lists every mobile endpoint in scope. [Section 10](#10-api-reference-v2) documents each endpoint (authorization, headers, request fields, request example, success response and errors) and [section 11](#11-response-objects) describes the response objects.

---

## 1. Products in scope

| Product | Users | Delivered as |
|---|---|---|
| Patient app | People looking for a doctor | Mobile app (iOS / Android) using API `/api/v2/patient/*` |
| Doctor app | Doctors | Mobile app (iOS / Android) using API `/api/v2/doctor/*` |
| Admin dashboard | Dorak admins | Web, `/dashboard` (Laravel Blade) |
| Landing page | Public visitors | Web, `/`, `/terms-conditions`, `/privacy-policy`, contact form |

Both apps support Arabic (default) and English.

---

## 2. Patient app — features

**Without an account**
- Home screen:
  - the patient's location ("الدمام، حي الفيصلية"), which the patient can change with a map picker
  - the notifications bell and the search box
  - specialization chips
  - the latest offers
  - the nearest medical centers and the nearest clinics
  - the sponsored ("best") doctors
- Medical centers and doctors' own clinics are shown as place cards. Each card has an image, a rating, the distance, the specializations, the address, "available today", a call button and a details button.
  - A center's rating is the average of its doctors' ratings.
  - "Available today" means a doctor works there today and takes bookings.
- Explore shows the same places as a list or on a map, filtered by city and specialization, with medical offers below.
- Search finds specializations, medical centers and clinics by name or specialization. When nothing matches, the app shows a no-results screen.
- The medical center page has photos, address and distance, about, specializations, the center's offers, ratings, location on the map, the list of its doctors, and booking. Patients can save a center as a favorite.
- The clinic page has photos, address, phone, offers, ratings, location and booking.
- The doctor profile shows:
  - title and specialization, with the center name
  - rating, years of experience and patients seen
  - bio
  - branches grouped by city
  - the price ("كشف واستشارة" + specialization)
- Doctor search with filters: name, specialization / sub-specialization, city, area, medical center, availability (any / today / tomorrow), gender, title, price range.
- Sorting: most recommended, lowest price, highest price, shortest waiting time, most wanted. Results are nearest first when the patient's location is known. Sponsored doctors appear first.
- Doctor profile: details, places of work, ratings, offers, available time slots.
- Offers list with filters and sorting.
- Nearest medical centers and their specializations.
- Reference data: specializations, cities, areas, countries, terms, privacy policy.

**With an account**
- Sign in or sign up with the phone number and a 4-digit SMS code, with no password. The same screens serve new and existing patients:
  1. The welcome screen offers phone, Apple, Google, or continue as a guest.
  2. The patient enters the phone number after the fixed `+966` prefix.
  3. The patient enters the code. "Resend code" is offered after 45 seconds, and the patient can go back and change the number.
  4. Complete profile asks for name and email, both optional. It is shown only when the account has no name yet.
- Sign in with Google or Apple.
- Change the phone number from the profile, confirmed by SMS code.
- Book an appointment at a medical center or a clinic in four steps:
  1. **Specialty & doctor.** Pick the doctor, or "any available doctor". From a doctor profile the doctor is already chosen.
  2. **Date & time.** 4 weeks of days, each available, full or closed. Times are split into morning and evening.
  3. **Review.** Doctor, service, date, time, branch, fee, and the payment method. Every booking is paid in cash at the visit ("الدفع في العيادة"), at a center or a clinic.
  4. **Confirmation.** A booking number such as DR-00042. The booking starts as **pending**, and the patient gets a "booking received" push.
- My bookings has three tabs:
  - **Upcoming:** soonest first. Each card has a badge (confirmed / awaiting confirmation), details and call.
  - **Past:** each card is completed or not confirmed, with "add rating" until the doctor is rated.
  - **Cancelled.**
- Booking details show the booking number, the place with its address and map, the date, time, doctor, service and fee, plus change and cancel.
- When cancelling, the patient may pick a reason (schedule conflict, feeling better, found an earlier appointment, other). The doctor and the dashboard see it.
- The patient may leave a note for the doctor when booking.
- Upcoming and past reservations. The patient can cancel or move (reschedule) a pending or confirmed appointment until 4 hours before it. A moved appointment waits for the doctor again.
- A reminder push goes out the day before the appointment.
- Rate a doctor (1–5 stars + comment) after a visit the doctor marked **completed**, once per doctor.
- Favorite doctors, offers and medical centers. The "favourite centers" screen lists centers only.
- Personal info: name, email, gender, birth date and city, all optional. The phone is shown, and changing it goes through change-phone with a code.
- Profile: notifications on / off, language and city. The language comes from the app with each request (`Content-Language`).
- Help & support has contact us (WhatsApp) and the privacy policy. There is no FAQ.
- Log out, and delete account. Deleting cancels upcoming appointments and keeps the history.
- Notifications are grouped into today, this week and earlier, and can all be marked read. They cover:
  - booking received, confirmed or cancelled
  - the reminder a day before
  - "rate your visit" two hours after a confirmed visit
  - a new offer in the patient's city ("new offer near you")
  - admin announcements

  They can be switched off.
- Rate the Dorak app.

---

## 3. Doctor app — features

- The administration adds the doctor by phone (the name is optional). There is no self-registration and no password.
- Sign in with the registered phone and a 4-digit SMS code. On the first sign-in, complete the account: name (read-only if the administration entered it), email, and accepting the terms.
- Account: profile, edit photo, bio, email and contact phone (name, specialization and sign-in phone are managed by the administration), settings, log out.
- Ask to delete the account: the administration reviews it, the account stays active, and the doctor can withdraw the request.
- Support: official contacts and a message form.
- Profile completion in 3 steps: personal details → workplace (own clinic, medical center(s), or both) → weekly schedules per place.
- Each place has its own schedule (working days, hours, break) and reservation type: exact time slot (`specified_time`) or first come, first served (`advance`).
- Update personal information (including years of experience, shown on the patient app profile), clinic details and photos (up to 10), schedules. Attach, update or detach medical centers.
- Open or close booking with one switch.
- Appointments: today (by place), upcoming and past (by date), filtered by place.
- The "..." menu on an appointment changes its status: confirm, cancel (the patient is notified), and after the appointment time **completed** or **no show**. No status is final.
- Appointment details: patient, date, time or turn, place, online or manual booking, price, patient note.
- My workplaces: for each place the booking system, appointment duration and price, and a weekly schedule with up to two periods a day. Changing the schedule warns about confirmed appointments outside the new hours; they stay as they are.
- Today's queue at a first-come place: the "next" button calls the next turn and notifies the patient.
- Manual booking in three steps: patient (name + phone), workplace and date (a time, or the next turn at a first-come place), review. It is confirmed at once.
- Offers: published, paused and expired. Create, edit, delete, publish or pause. An offer has a cover image, bilingual title and description, price before / after, and start and end dates. An expired offer is read-only.
- Home: today's appointment count and earnings (completed visits), the queue at each medical center (next turn, who is waiting), today's appointments, recent ratings, and a link to support.
- Patient reviews with the average and count. Monthly reports of appointments and reviews per year.
- Subscription: 14-day free trial from the first sign-in, then monthly or yearly plan (prices set by admins, optional discount).
- My subscription: the doctor's package (an ad package giving sponsored placement), its dates and payment method. Renew by bank transfer with one receipt, or in cash through the administration; the administration confirms both.
- Consultation invoices: one per booking, with the amount and state only.
- Notifications: new reservation, reservation cancelled by patient, subscription status, admin announcements.
- Support contact through WhatsApp.

---

## 4. Admin dashboard — features

- Add a doctor quickly by phone (the name is optional) or with the full form. Review doctors (pending / approved / rejected) and manage doctors and patients.
- Confirm bank transfer payments for subscriptions and ads; pending subscriptions page.
- Reference data: titles, specializations, countries, cities, areas, medical centers, payment methods and bank accounts, ad packages, news. Each area can have the coordinates of its centre (lat / lng); the patient app uses them to name the patient's location.
- Content and settings: general settings (site name, description, light / dark logo, icon, alert sounds), terms and privacy, contact numbers, app store links, subscription prices with discount periods, landing page content.
- Ratings moderation, contact messages, admin notifications, trash and restore.
- Admins, roles and permissions. Buttons are hidden when an admin lacks the permission, and the server also rejects the action.
- Reports.

---

## 5. Payments

| Method | Behaviour | Status |
|---|---|---|
| Cash | Shown as "through the administration"; request saved as unpaid; admin confirms | Required — keep |
| Bank transfer | Doctor uploads receipt; stays unpaid until an admin confirms it | Required — keep |
| Online | Removed: there is no payment gateway, and the API refuses it | Gateway not in scope |

Payment for the medical examination itself happens at the clinic and is not handled by Dorak. Dorak earns money from doctor subscriptions and ad packages. Patients use the app for free.

---

## 6. Deliberate constraints (do not change)

- **Market:** Saudi Arabia. Phone numbers are stored as `05XXXXXXXX`. Patient sign in also accepts `5XXXXXXXX` (typed after the `+966` prefix) and `+9665XXXXXXXX`. Timezone `Asia/Riyadh`.
- **Fixed OTP `1995`:** accepted by phone verification and password reset. No SMS delivery service is integrated yet; a legacy SMS gateway is in the code. Missing SMS delivery is not a defect.
- **Hidden support admin account:** intentional; must be preserved.
- **Cash and bank transfer:** both required. A receipt does not mark a payment as paid automatically.
- **Active API:** v2 only (`routes/patient_api_v2.php`, `routes/doctor_api_v2.php`). v1 routes stay unchanged.

---

## 7. Out of scope

- Online payment gateway integration.
- Real SMS / OTP provider integration (fixed OTP stays).
- In-app payment for examinations.
- Video consultation, chat, prescriptions, medical records.
- Changes to the legacy v1 API.
- New sidebar entries or navigation redesign in the dashboard (unless requested separately).

---

## 8. Work status

### Completed and verified
- **Security:** SEC-01, SEC-02, SEC-05 to SEC-11, SEC-13, and OTP attempt limits.
- **API and dashboard bugs:** BUG-F01 to BUG-F20 and BUG-F24 to BUG-F27. These include double booking, closed booking, the doctor-places endpoint, nearest medical centers, sponsored doctors filtering, and review eligibility.
- **Dashboard QA:** DQA-02 (patient gender edit), DQA-03 (pending subscriptions filter), DQA-04 (discount price dates), DQA-05 (hide create buttons from unauthorized admins).
- **Dashboard browser regression tests** executed.
- Light and dark logo settings, used in the dashboard sidebar and the landing page navbar.
- Patient home, explore (list and map), search and location picker, matching the app's discovery screens (2026-10-28):
  - New endpoints: `medical-centers`, `clinics`, `search`, `explore/map`, `location`, `locations`.
  - `home` was reworked.
  - Offers name the doctor's center.
  - Areas have coordinates, entered in the dashboard.
- Patient sign in with phone + OTP, no password, matching the app's auth screens (2026-10-28):
  - The patient password endpoints (`login`, `register`, `change-password`) were removed from v2. v1 is unchanged.
  - The sign-in code expires after 5 minutes.
  - `patients.name` is now optional.
  - A patient without a name is shown by phone number in the dashboard, and as "Dorak user" in ratings.

The "known gaps" list in `BUSINESS_PATIENT_DOCTOR_APPS.md` section 5 was written before these fixes. Most of those items are now fixed.

### Open
- **Remove default admin credentials:** review the seeded and predictable admin accounts. Keep the hidden support account.
- **App subscription after the free trial:** patients stop seeing a doctor when the 14-day trial ends unless the doctor has a monthly or yearly app subscription, but the doctor app screens only cover packages (ads). This needs a decision.

---

## 9. API notes for mobile developers

- Base URL: `{host}/api/v2`. Auth: Laravel Passport bearer token, returned in `data.token`.
- Patient sign in:
  1. `POST patient/send-otp` with `{phone}`.
  2. `POST patient/check-otp` with `{phone, otp, fcm_token}` returns `token`, `is_new_user` and `profile_completed`.
  3. When `profile_completed` is false, `POST patient/complete-profile-data` with `{name?, email?}`.
- Doctor sign in: `doctor/send-otp`, `doctor/check-otp`, then `doctor/complete-account` when `account_completed` is false (section 9.7).
- Language: `lang` parameter or `Content-Language` header (`ar` / `en`). `Accept-Language` is ignored. Other values return 403.
- Response: `{success, data, message}`. Paginated lists add `links` and `meta`, 15 items per page. Validation errors are HTTP 422 `{message, errors}`. A few endpoints return a bare resource without the envelope; they are marked in the collection.
- File uploads use `multipart/form-data`: profile completion, personal and clinic updates, offers, payment receipts.
- Doctor profile completion: steps are `0`, `1`, `2`. Steps 0 and 1 only validate. Step 2 saves everything, so the app must resend the step 0 and step 1 fields with it.
- Schedule endpoints (update clinic schedules, attach or update medical center) need all 7 days in the request. A missing day causes a server error.
- `bio` is a text field in profile completion but a PDF file in update personal information.
- Price filter names differ: `min_price` / `max_price` for doctors, `minPrice` / `maxPrice` for offers.
- Payment is cash or bank transfer (receipt required for a transfer), both confirmed by the administration. Online is refused.

---

---

### 9.1 Patient sign-in flow (screens → API)

```text
Welcome ──► [Continue with phone] ──► Enter phone ──► Enter code ──► (new account?) Complete profile ──► Home
   │                                     ▲   │            │  │
   │                                     │   │            │  └─ wrong code: stay, show error, allow resend
   │                                     └───┴── Change number
   ├──► [Continue with Apple / Google] ──► (new account?) Complete profile ──► Home
   └──► [Guest] ──► Home (public endpoints, no token)
```

| # | Screen | Request | What the app does with the response |
|---|---|---|---|
| 1 | Welcome | — | Phone, Apple, Google or guest |
| 2 | Enter phone (`+966` prefix shown) | `POST /api/v2/patient/send-otp` `{"phone": "551234567"}` | Go to the code screen. Show the masked `data.full_phone`. Start the resend timer from `data.resend_after` (45 s). |
| 3a | Enter code | `POST /api/v2/patient/check-otp` `{"phone": "551234567", "otp": "1234", "fcm_token": "..."}` | 200: store `data.token`. If `data.profile_completed` is false → screen 4, else → Home. |
| 3b | Wrong code | same call → 422 `errors.otp[0]` = "الرمز غير صحيح. تحقق منه وحاول مرة أخرى." | Show the message under the boxes and keep the screen open. |
| 3c | Resend code (after the timer) | `POST /api/v2/patient/send-otp` again | Restart the timer. The previous code stops working. |
| 3d | Change number | back to screen 2, then `send-otp` with the new number | — |
| 4 | Complete profile (name and email, both optional) | `POST /api/v2/patient/complete-profile-data` `{"name": "سارة أحمد", "email": "sara@example.com"}` with `Authorization: Bearer <token>` | → Home. "Skip" sends nothing; the screen shows again on the next sign in while the name is empty. |
| — | Apple / Google | `POST /api/v2/patient/social-login` | Same `token` / `is_new_user` / `profile_completed` handling as 3a |
| — | Guest | public endpoints (home, doctors, offers…) with no token | Ask to sign in when the guest tries to book, rate or favorite |

Rules: the code is 4 digits and is valid 5 minutes, once. The fixed test code `1995` is always accepted. Sending is limited to 3 codes per phone every 10 minutes; checking to 5 tries. Over the limit → 429 with `Retry-After`.

### 9.2 Patient home and discovery (screens → API)

| Screen | Request | Notes |
|---|---|---|
| Home | `GET /api/v2/patient/home?lat=&lng=` (+ `specialization_id` when a chip is picked) | `location.label` for the top bar, `unread_notifications_count` for the bell, `specializations` for the chips, `latest_offers`, `nearest_medical_centers`, `nearest_clinics` (4 each), `best_doctors` |
| Home "View all" (offers) | `GET /api/v2/patient/offers` | each offer has `place.name` (the doctor's center, or clinic) |
| Home "View all" (centers / clinics) | `GET /api/v2/patient/medical-centers` · `GET /api/v2/patient/clinics` with `lat`, `lng` | paginated cards, nearest first |
| Location picker (open) | `GET /api/v2/patient/location?lat=&lng=` | names the point under the pin: "الدمام، حي الفيصلية" |
| Location picker (search box) | `GET /api/v2/patient/locations?search=` | areas with their centre `lat` / `lng` to move the map |
| Location picker "Confirm" | — | the app keeps the chosen `lat` / `lng` and sends them to every discovery call |
| Search | `GET /api/v2/patient/search?search=أسنان&lat=&lng=` | `specializations` = chips; `medical_centers.total` / `clinics.total` = the counts in the headings |
| Search: chip picked | same + `specialization_id` | |
| Search: no results | same call; every list is empty | show "لا توجد نتائج"; "Clear search" just clears the box |
| Explore · list | `GET /api/v2/patient/medical-centers`, `GET /api/v2/patient/clinics`, `GET /api/v2/patient/offers` with `city_id` (city picker), `specialization_id` (specialization filter), `search` | |
| Explore · map | `GET /api/v2/patient/explore/map?lat=&lng=` (+ same filters) | pins from `lat` / `lng`, the label is `name` + `rating`; the card under the map is the same card object |
| Card: call | — | `tel:` the card's `phone` |
| Card: details (center) | `GET /api/v2/patient/medical-centers/{id}?lat=&lng=` | card, about (`description`), `specializations` (icons), center offers, `ratings` {`count`, `average`, `data`}, `location`, `is_favorite` |
| Center: "Center doctors" / "Book" | `GET /api/v2/patient/medical-centers/{id}/doctors` (+ `specialization_id` for a chip) | header: name, `doctors_count`, `specializations_count`; doctor cards with `headline` ("استشاري طب الأسنان"), rating, "Book" |
| Card: details (clinic) | `GET /api/v2/patient/clinics/{doctor_id}?lat=&lng=` | card, photos, about, offers, ratings, `is_favorite`; "Book" opens the doctor's booking |
| Doctor profile | `GET /api/v2/patient/doctors/{id}` → `data.profile` | headline ("استشاري طب الأسنان · مجمع النور الطبي"), stat boxes: `rating` + `ratings_count`, `experience_years`, `patients_count`; `bio`; "available at" = `branches` (city + areas); prices = `services`; "Book with Dr." |
| Heart (center) | `POST /api/v2/patient/add-medical-center-to-favorite/{id}` · `remove-medical-center-from-favorite/{id}` | needs a patient token |
| Heart (clinic / doctor) | `POST /api/v2/patient/add-doctor-to-favorite/{doctor_id}` · `remove-doctor-from-favorite/{doctor_id}` | |
| Offer card: "Offer details" | offer object from the lists | `place.name` is the doctor's center |

Card fields (center and clinic): `type` (`medical_center` / `clinic`), `id`, `name`, `image`, `rating` (null until rated), `ratings_count`, `distance_km` (null without `lat` / `lng`), `specializations`, `city`, `area`, `address`, `available_today`, `phone`, `lat`, `lng`. A clinic card also has `doctor` and `is_sponsored`; its `id` is the doctor's id.

### 9.3 Patient booking at a center (screens → API)

| Screen | Request | Notes |
|---|---|---|
| 01 Specialty & doctor | `GET /api/v2/patient/medical-centers/{id}/doctors` (+ `specialization_id`) | specialization chips and the doctors; "أي طبيب متاح" = no doctor chosen |
| 01b Doctor preselected | from the doctor profile: `doctor_id` is known | the doctor's specialization is the only chip |
| Branch | `GET /api/v2/patient/doctors/{id}` → `profile.branches[].places` | skip it when booking from a center page (the center is the branch) |
| 02 Date & time: days | `GET /api/v2/patient/booking/days?doctor_id=&medical_center_id=` — any doctor: `?specialization_id=&medical_center_id=` | `status` available / full / closed → green dot, grey, "مغلق" |
| 02 Date & time: times | `GET /api/v2/patient/booking/slots?…&date=2026-11-05` | `morning` / `evening`; `available: false` = "محجوز"; keep the slot's `doctor_id` and `time` |
| 03 Review | `POST /api/v2/patient/booking/preview` `{doctor_id, medical_center_id, date, time}` | summary; nothing is booked yet |
| 03 Confirm | `POST /api/v2/patient/reservations` same body | `booking_number`, `status: pending`; 422 `errors.time` if the time was taken meanwhile → back to step 02 |
| 04 Confirmed | the response of the confirm call (or `GET /api/v2/patient/reservations/{id}`) | "عرض حجوزاتي" → `reservations/upcoming` |
| Cancel | `POST /api/v2/patient/reservations/cancel-reservation` `{id}` | while `can_cancel` (until 4 hours before) |
| Change date / time | `booking/slots` for the same doctor and place, then `POST /api/v2/patient/reservations/{id}/reschedule` `{date, time}` | while `can_reschedule` |

### 9.4 Patient booking at a clinic (screens → API)

The same calls as at a center, with `medical_center_id` left out (or `null`): the place is the doctor's own clinic. There is no specialty / doctor step, since the clinic is one doctor.

| Screen | Request | Notes |
|---|---|---|
| 01 Date & time: header | the clinic card (`clinics/{doctor_id}`) | "عيادة دكتور احمد" + the specialization |
| 01 Date & time: days | `GET /api/v2/patient/booking/days?doctor_id={doctor_id}` | available / full / closed |
| 01 Date & time: times | `GET /api/v2/patient/booking/slots?doctor_id={doctor_id}&date=2026-10-22` | morning / evening, "محجوز" = `available: false` |
| 02 Review | `POST /api/v2/patient/booking/preview` `{doctor_id, date, time}` | `place.type = clinic`, `place.name` = clinic name, `place.branch` = "فرع الفيصلية · الدمام", `payment_type` = `cash`, `payment_method` = "الدفع في العيادة", `patient_name`, `amount` |
| 02 Confirm | `POST /api/v2/patient/reservations` same body | `booking_number` |
| 03 Confirmed | the confirm response | date + time, clinic (`place.name`), specialization (`specialization.name`) |
| Cancel / change | as at a center | until 4 hours before |

A doctor who works only at medical centers has no clinic: `booking/days` answers 422 `errors.doctor_id`.

### 9.5 Patient account & follow-up (screens → API)

| Screen | Request | Notes |
|---|---|---|
| 01 My bookings · upcoming | `GET /api/v2/patient/reservations/upcoming` | `display_status` / `status_label` = the badge; "Details" → `reservations/{id}`; call = `place.phone` |
| 02 My bookings · past | `GET /api/v2/patient/reservations/past` | `completed` = "مكتمل"; "Add rating" while `can_rate` → `POST /api/v2/patient/ratings` `{doctor_id, rate, comment}` |
| 02 My bookings · cancelled | `GET /api/v2/patient/reservations/cancelled` | `status_label` "ملغي" |
| 03 Empty tab | same calls → `data: []` | "Explore centers" → explore |
| 04 Booking details | `GET /api/v2/patient/reservations/{id}` | `booking_number`, `place.address`, `place.lat` / `lng` (map, directions), `date_label`, `time_label`, doctor, `service`, `amount` + `payment_method`; "Change" while `can_reschedule`, "Cancel" while `can_cancel` |
| 05 Cancel sheet | reasons: `GET /api/v2/patient/general` → `cancellation_reasons`; confirm: `POST /api/v2/patient/reservations/cancel-reservation` `{id, reason, note?}` | the reason is optional |
| 06 Notifications | `GET /api/v2/patient/notifications` | headings from `group` (today / this_week / earlier), unread dot = `is_read: false`, tap → `target` |
| 06 "Mark all as read" | `POST /api/v2/patient/notifications/mark-all-as-read` | |
| 07 Profile (signed in) | `GET /api/v2/patient/profile` | name, `full_phone`, `city.name`, `allow_notifications` ("مفعّلة") |
| 07 Notifications switch | `POST /api/v2/patient/toggle-notifications` `{allow_notifications: 0/1}` | |
| 07 Language | — | the app sends `Content-Language: ar / en` with every call |
| 07 Log out | `POST /api/v2/patient/logout` | |
| 08 Profile (guest) | — | no call; "Sign in" → sign-in flow (9.1) |
| 09 Personal info | `POST /api/v2/patient/update-profile` `{name, email, gender, birth_date, city_id}` | cities from `general.cities`; phone changes with `change-phone` + `verify` |
| 09 Delete account | `POST /api/v2/patient/delete-account` | then clear the token in the app |
| 10 Favourite centers | `GET /api/v2/patient/favorites?type=medical_center` | heart off → `remove-medical-center-from-favorite/{id}` |
| 11 Help & support | contact us: `general.whatsapp_number`; privacy: `GET /api/v2/patient/privacy-policy` | no FAQ |

### 9.6 Booking statuses

Stored in `reservations.status`, five values. Nothing changes a status by itself: a booking keeps its status until the patient or the doctor changes it.

| Status | Arabic label (`status_label`) | Meaning | Set by |
|---|---|---|---|
| `pending` | بانتظار التأكيد | booked, waiting for the doctor | the patient's booking or a reschedule |
| `confirmed` | مؤكد | the doctor confirmed it | the doctor; a manual booking starts here |
| `completed` | مكتمل | the patient came | the doctor, once the appointment started |
| `no_show` | لم يحضر | the patient did not come | the doctor, once the appointment started |
| `cancelled` | ملغي | cancelled before the visit | the patient (until 4 hours before), the doctor, or deleting the account |

```text
 pending ──confirm──► confirmed ──after the appointment time──► completed
    │                     │                                  └► no_show
    └───────cancel────────┴──► cancelled
```

The flow above is the normal path. **No status is final:** the doctor, and only the doctor, can change any status from the "..." menu, for example from `no_show` back to `completed`. The patient can only cancel.

| Rule | Detail |
|---|---|
| Who | the doctor; the dashboard does not change statuses |
| `completed` / `no_show` | only once the appointment started (`attendance_available`) |
| Bringing back a cancelled appointment | a fixed-time appointment needs its time to be still free |
| The patient | cancels pending / confirmed until 4 hours before |

Doctor call: `POST /api/v2/doctor/reservations/change-status` `{id, status}`. `completed` / `no_show` before the appointment starts answers 422 `errors.status`.

What each status drives:
- **Patient app tabs.** Upcoming holds pending and confirmed bookings that have not started. Past holds what has passed, each with its own status (completed, no_show, or still pending / confirmed). Cancelled holds cancelled bookings.
- **Ratings.** Only a `completed` visit lets the patient rate the doctor. `can_rate` follows the same rule, and so does the "rate your visit" push.
- **Doctor home totals and the profile's patients count.** These skip `cancelled` and `no_show`; the patients count counts `completed` visits.
- **Time slots.** Every status except `cancelled` keeps its slot taken.
- **Reminders.** The day-before reminder goes to `pending` and `confirmed` bookings only.

### 9.7 Doctor sign-in flow (screens → API)

The administration adds the doctor first: **Doctors → add a doctor by phone** in the dashboard, with the phone and an optional name. A doctor added this way stays `pending` until an admin reviews them.

| Screen | Request | What the app does with the response |
|---|---|---|
| 02 Sign in | `POST /api/v2/doctor/send-otp` `{"phone": "550002468"}` | go to the code screen and start the resend timer from `resend_after` (45 s) |
| 02b Number not registered | same call → 422 `errors.phone` | show the message; "contact the administration" uses `whatsapp_number` from `GET /api/v2/doctor/general` |
| 03 Code | `POST /api/v2/doctor/check-otp` `{phone, otp, fcm_token}` | store `token`. `account_completed: false` → complete account; `true` → home |
| 03b Wrong code | same call → 422 `reason: "wrong"`, `attempts_left` | show `errors.otp[0]` ("الرمز غير صحيح. تبقت لديك محاولتان."). After the last attempt → 429 |
| 03c Code expired | same call → 422 `reason: "expired"` | show `errors.otp[0]` and offer "resend code" (`send-otp` again) |
| 03d Complete account | `POST /api/v2/doctor/complete-account` `{name, email, accepted}` with the token | `name_locked: true` (03k): show the name read-only. Keep "Continue" disabled until the fields are valid and the box is ticked (03i, 03j) |
| 03f, 03g, 03h Errors | same call → 422 | show `errors.name[0]` / `errors.email[0]` under the field |
| 03e Signed in | — | success screen, then home |

Rules:
- The code is 4 digits and valid 5 minutes, once. The fixed test code `1995` is always accepted.
- The 14-day free trial starts at the first sign-in. Doctors who existed before this change keep the trial counted from their registration.
- Doctors who registered in the app before this change already accepted the terms. Doctors entered in the dashboard see "complete your account" once.

### 9.8 Doctor home (screens → API)

| Part of the screen | Where it comes from |
|---|---|
| Name, photo, greeting | `GET /api/v2/doctor/home` → `doctor`; the greeting ("مساء الخير") comes from the phone's clock |
| Bell dot | `unread_notifications_count` |
| Date | `today_appointments.date_label` |
| Today's appointments box | `today_appointments.count`: every visit today except cancelled and no-shows |
| Today's earnings box | `today_appointments.earnings`: the amounts of today's `completed` visits |
| Center card | `center_queues[]`: `name`, `next.turn`, `next.patient_name`, `waiting_count`. `next` is null when nobody is waiting |
| "Open bookings" | `GET /api/v2/doctor/queue?medical_center_id={id}` at a first-come place (section 9.10); otherwise `reservations/today?medical_center_id={id}` |
| Today's list | `today_appointments.reservations`: `time_label`, `status_label`, `name`, `place_name`, `booking_number`. "View all" → `reservations/today` |
| "•••" on an appointment | `POST /api/v2/doctor/reservations/change-status` `{id, status}` |
| Latest ratings | `recent_ratings`; "View all" → `GET /api/v2/doctor/ratings` |
| "Add appointment manually" (empty day) | `POST /api/v2/doctor/reservations` |
| "Need help?" | `whatsapp_number` from `GET /api/v2/doctor/general` |

The "booking paused at a place" banner (04b) is not built: pausing booking stays one switch for the doctor (`change-booking-status`).

### 9.9 Doctor appointments (screens → API)

| Screen | Request | Notes |
|---|---|---|
| Tabs: today / upcoming / past | `GET /api/v2/doctor/reservations/today` · `upcoming` · `past` | groups: `title` + `count` + `reservations`. Today is grouped by place, the others by date. Upcoming starts tomorrow |
| Place chips | same + `?medical_center_id={id}`; `0` = own clinic | places from `GET /api/v2/doctor/doctor-places`, each with `reservation_type` |
| Card | `time_label`, or `queue_label` ("دور 3") at a first-come place; `status_label`; `queue_status_label`; `name`; `place_name`; `booking_number` | |
| "..." menu | `actions` = statuses to offer; grey out `completed` / `no_show` while `attendance_available` is false and show `attendance_available_from` | the design needs a "confirm" row for `pending` |
| Confirm sheets (completed, no show, cancel) | `POST /api/v2/doctor/reservations/change-status` `{id, status}` | the toast is shown by the app |
| 04 Details | `GET /api/v2/doctor/reservations/{id}` | `patient_full_phone`, `date_label`, `source_label`, `reservation_system_label`, `amount`, `patient_note` |
| 05 Manual: patient | no call; check in the app, the server repeats the check on save | error texts come back in `errors.name` / `errors.phone` |
| 06 Manual: place and date | `GET /api/v2/doctor/booking/days?medical_center_id=` | |
| 06 Manual: times | `GET /api/v2/doctor/booking/slots?medical_center_id=&date=` | `reservation_type: specified_time` → `morning`, `evening`, `duration_minutes` ("كل موعد 20 دقيقة") |
| 06b Manual: first come | same call → `reservation_type: advance` | `queue_label` ("دور 5") and `starts_label` |
| 07 Review and confirm | no call for the review; `POST /api/v2/doctor/reservations` `{name, phone, medical_center_id, date, time}` | leave `time` out at a first-come place |
| 06c Slot taken | same call → 422 `errors.time` | show the message and go back to the times |

First-come rules:
- Only the doctor's manual bookings get a turn; the patient app still books times.
- "تم الاستدعاء" means the doctor called the turn with the "next" button (section 9.10), and "بالانتظار" means still in line.
- A cancelled turn is not given again.

### 9.10 Doctor workplaces, schedule and queue (screens → API)

| Screen | Request | Notes |
|---|---|---|
| 02 My workplaces | `GET /api/v2/doctor/workplaces` | `id` 0 = the own clinic. Empty list = "no workplaces" screen |
| 03 Workplace details | `GET /api/v2/doctor/workplaces/{id}` | system, duration, price, `working_days_count`; `address` and `phone` are read-only |
| 04 Booking settings | `POST /api/v2/doctor/workplaces/{id}/settings` `{reservation_type, examination_duration, examination_price}` | this place only. Duration: 10, 15, 20 or 30. Existing bookings do not change |
| 05 Weekly schedule | `GET /api/v2/doctor/workplaces/{id}/schedule` | seven days, each with up to two `periods`; the app hides "add period" after the second |
| 05 Save | `POST /api/v2/doctor/workplaces/{id}/schedule` `{days: [{day, is_available, periods}]}` | |
| 05b Invalid period | same call → 422 | `errors["days.{index}.periods.{n}.end_time"]`; `index` is the position in `days` |
| 05c Affected appointments | same call → 409 `affected_count`, `affected` | nothing was saved. "Save and keep the appointments" sends it again with `confirm_affected: true` |
| Today's queue | `GET /api/v2/doctor/queue?medical_center_id=` | header: `name`, `date_label`, `starts_label`, `waiting_count`, `total_count`; each row has `queue_label`, `status_label`, `queue_status_label` |
| "Next" button | `POST /api/v2/doctor/queue/call-next` `{medical_center_id}` | `message` is the toast; disable the button when `can_call_next` is false |
| "..." on a turn | `POST /api/v2/doctor/reservations/change-status` | calling does not change the status |

Rules:
- A place's price and duration are its own. A center that has none set uses the doctor's values; the clinic uses the doctor's columns.
- The patient sees the price and time slots of the place being booked.
- The break is the gap between the two periods of a day.
- "Next" sends the patient "جه دورك" if they use the app. A patient the doctor added by hand with no app gets nothing.
- There is no per-place switch to pause online booking.

### 9.11 Doctor offers, reports and reviews (screens → API)

| Screen | Request | Notes |
|---|---|---|
| 01 My offers | `GET /api/v2/doctor/offers` | chips: `?status=active` (published), `inactive` (paused), `expired`. Card: `title_ar` / `title_en`, prices, `date_label`, `status_label`, `place`. Empty `data` = "no offers" |
| Published switch | `POST /api/v2/doctor/offers/{id}/change-status` `{is_active}` | hide it when `can_edit` is false |
| 02 Add offer | `POST /api/v2/doctor/offers` (form-data) | `city_id` is not on the form: the workplace city is used |
| 02b Form errors | same call → 422 | `errors.{field}[0]` under each field |
| Edit | `POST /api/v2/doctor/offers/{id}` (form-data) | |
| 03b Expired offer menu | `can_edit: false` | only delete, or "create new offer" with the form filled in by the app |
| 04 Delete | `DELETE /api/v2/doctor/offers/{id}` | |
| 06 Reports | `GET /api/v2/doctor/monthly-report/{reservations or ratings}/{year}` | `data` = 12 months; `years` fills the picker; `has_data: false` = the empty note |
| 07 Patient reviews | `GET /api/v2/doctor/ratings` | `summary.average`, `summary.count`, then the reviews; empty `data` = "no reviews yet" |

Rules:
- Patients see an offer only when it is switched on and today is between its dates, last day included.
- An expired offer cannot be edited, switched on or have its price visibility changed. It can only be deleted.

### 9.12 Doctor subscription and invoices (screens → API)

A package here is an ad package from the dashboard, for example "الباقة الذهبية".

| Screen | Request | Notes |
|---|---|---|
| 01 My subscription | `GET /api/v2/doctor/my-subscription` | `package.name`, `status_label`, `duration_days`, `start_date_label`, `end_date_label`, `payment_method_label` |
| 01 "Pay by bank transfer" | shown while `can_renew_by_transfer` | |
| 01b Paid through the administration | `payment_method: cash` | no button, the note instead |
| Package ended, or none | `can_choose_package` → `GET /api/v2/doctor/ads` | the same package or another one |
| My ads | `GET /api/v2/doctor/my-ads` | every ad the doctor subscribed to: `ad.name`, `amount`, `status_label` (نشط / منتهي / قيد المراجعة / مرفوض), `payment_method_label`, dates |
| 02 Bank transfer | `bank_accounts` from `my-subscription` | bank, beneficiary, IBAN |
| 02b Send receipt | `POST /api/v2/doctor/ads/{id}/subscribe` (form-data) `{payment_method_id, payment_receipt}` | one file: JPG, PNG or PDF, up to 5 MB |
| 02c Upload error | same call → 422 `errors.payment_receipt` | |
| 03 Receipt under review | `pending_request` | `file_name`, `sent_at_label`, `status_label`; the renewal button is hidden |
| 04 Invoices | `GET /api/v2/doctor/invoices` | chips: `?status=pending`, `paid`, `cancelled` |
| 05 Invoice details | `GET /api/v2/doctor/invoices/{id}` | |

Rules:
- There is no payment gateway. A package is paid in cash or by bank transfer, and the administration confirms both from the dashboard; nothing is activated by the app.
- While a package runs, only that package can be renewed. Once it ends the doctor can take it again or another one. Changing it earlier goes through the administration.
- Only one request can be under review at a time.
- An invoice is a booking: pending and confirmed = "قيد الانتظار", completed = "مدفوعة", cancelled and no-show = "ملغية". There is no invoices table and no payment from the app.

### 9.13 Doctor account, settings and support (screens → API)

| Screen | Request | Notes |
|---|---|---|
| 01 My account | `GET /api/v2/doctor/profile` | `name`, `specialization`, `workplaces_count`, `rating`, `package_name`, `deletion_request` (the banner) |
| 02 Profile | same call | read-only: `name`, `specialization`, `sign_in_phone`; editable: `bio`, `email`, `contact_phone_full` |
| 03 Edit profile | `POST /api/v2/doctor/profile` (form-data) `{image, bio, email, contact_phone}` | 03b: 422 `errors.email` |
| 01c Request deletion | `POST /api/v2/doctor/deletion-request` | the account stays active; an admin deletes it from the dashboard |
| 01d Withdraw request | `POST /api/v2/doctor/deletion-request/withdraw` | |
| 01e Log out | `POST /api/v2/doctor/logout` | |
| 04 Notifications | `GET /api/v2/doctor/notifications` | `group`, `is_read`, `target` (`reservation_id`, `invoice_id`). Types: `new_reservation`, `reservation_cancel`, `reservation_rescheduled`, `subscription_ending`, `invoice_updated` |
| Mark all read | `POST /api/v2/doctor/notifications/mark-all-as-read` | |
| 05 Settings | notifications: `POST /api/v2/doctor/toggle-notifications`; language: `Content-Language` on every call | state: `allow_notifications` |
| 06 Support | `GET /api/v2/doctor/support` | `phone`, `email`, `hours`, `subjects` |
| 06 Send | `POST /api/v2/doctor/support` `{subject, message}` | lands in the dashboard contact messages |

### 9.14 API change log

These two files are updated with every change to the mobile API flow:
- `dosc/scope.md`
- `dosc/Dorak_Mobile_API_v2.postman_collection.json`

| Date | Change |
|---|---|
| 2026-11-01 | New endpoint `doctor/my-ads`: the ads the doctor subscribed to, with status, payment method and dates. |
| 2026-11-01 | Doctor account, settings and support (section 9.13).
<ul>
<li>New endpoints: `doctor/profile` (read and save), `doctor/deletion-request`, `doctor/deletion-request/withdraw`, `doctor/support` (read and send), `doctor/notifications/mark-all-as-read`.</li>
<li>`doctor/delete-account` was removed from v2: the doctor requests deletion and an admin deletes the account. v1 is unchanged.</li>
<li>Doctor notifications have new texts and a `target`; new types `subscription_ending` (three days before, `doctors:send-package-ending-reminders`) and `invoice_updated`. Notifications add `date_label`.</li>
<li>Patient `doctors/{id}` `profile` adds `contact_phone`.</li>
<li>Dashboard: support phone, email and hours in Settings > Contact; the doctor page shows a deletion request.</li>
<li>Migration: `doctors.contact_phone`, `deletion_requested_at`, `ad_ending_notified_at`; `bio` up to 500 characters.</li>
</ul> |
| 2026-11-01 | Doctor subscription and invoices (section 9.12).
<ul>
<li>New endpoints: `doctor/my-subscription`, `doctor/invoices`, `doctor/invoices/{id}`.</li>
<li>Online payment is gone from `ads/{id}/subscribe` and `create-application-subscription`, on v1 too: online answers 422, and nothing activates without the administration.</li>
<li>`ads/{id}/subscribe`: the receipt may be JPG, PNG or PDF up to 5 MB; returns the subscription; only one request under review; a running package can only be renewed; each request is a new row.</li>
<li>Dashboard: a PDF receipt opens in a new tab.</li>
<li>Migration: `subscriptions.payment_receipt_name`.</li>
</ul> |
| 2026-11-01 | Doctor offers, reports and reviews (section 9.11).
<ul>
<li>`doctor/offers` accepts `?status=` and returns `status`, `status_label`, `can_edit`, `date_label` and `place`.</li>
<li>Creating an offer: `city_id` and `is_price_shown` are optional, with screen error messages.</li>
<li>An expired offer is read-only (422 `errors.offer`); `DELETE` now uses the normal envelope.</li>
<li>Patients see only offers inside their dates.</li>
<li>`monthly-report` accepts `ratings` and returns `has_data` and `years`.</li>
<li>`doctor/ratings` adds `summary`.</li>
</ul> |
| 2026-11-01 | Doctor workplaces, schedule and queue (section 9.10).
<ul>
<li>New endpoints: `doctor/workplaces`, `doctor/workplaces/{id}`, `doctor/workplaces/{id}/settings`, `doctor/workplaces/{id}/schedule` (read and save), `doctor/queue`, `doctor/queue/call-next`.</li>
<li>Price and duration are per place: bookings, time slots and `places` use the place's values.</li>
<li>`queue_status` now comes from the "next" button (`called_at`) and stays after the visit. The home card counts who was not called yet.</li>
<li>Migration: `places.examination_price`, `examination_duration`; `reservations.called_at`.</li>
</ul> |
| 2026-11-01 | Doctor appointments and manual booking (section 9.9).
<ul>
<li>No status is final: the doctor can change any status (section 9.6).</li>
<li>`reservations/today` is grouped by place; `upcoming` starts tomorrow; groups add `title` and `count`; all three accept `medical_center_id`.</li>
<li>New endpoints: `doctor/reservations/{id}`, `doctor/booking/days`, `doctor/booking/slots`.</li>
<li>Doctor reservations add `queue_number`, `queue_label`, `queue_status`, `actions`, `attendance_available` and `attendance_available_from`.</li>
<li>`doctor/reservations` (manual booking): confirmed at once, accepts `5XXXXXXXX`, `time` is optional at a first-come place, an existing patient keeps their name.</li>
<li>`doctor-places` returns `reservation_type`.</li>
<li>Patient `reservations` accepts `note`.</li>
<li>Migration: `reservations.source`, `queue_number`, `patient_note`.</li>
</ul> |
| 2026-11-01 | Doctor home (section 9.8) and code screen states.
<ul>
<li>`doctor/home` adds `doctor`, `unread_notifications_count`, `today_appointments.earnings`, `date_label` and `center_queues`; the list is in time order.</li>
<li>Doctor reservations add `status_label`, `booking_number`, `time_label`, `service` and `medical_center_id`.</li>
<li>`reservations/today` accepts `medical_center_id`.</li>
<li>`doctor/check-otp`: a refused code returns `reason` (wrong / expired) and `attempts_left`.</li>
<li>`doctor/send-otp`: new message for a number that is not registered.</li>
</ul> |
| 2026-11-01 | Doctor sign in with phone + OTP (section 9.7).
<ul>
<li>`doctor/send-otp` and `doctor/check-otp` now sign the doctor in. `check-otp` returns `token`, `doctor`, `account_completed` and `name_locked`.</li>
<li>New endpoint: `doctor/complete-account`.</li>
<li>`doctor/register`, `login`, `social-login` and `change-password` were removed from v2. v1 is unchanged.</li>
<li>Dashboard: quick add of a doctor by phone.</li>
<li>Migration: `doctors.name`, `email` and `password` are nullable; new `terms_accepted_at` and `trial_started_at`.</li>
<li>The free trial runs from the first sign-in.</li>
</ul> |
| 2026-10-29 | Booking statuses (section 9.6).
<ul>
<li>`reservations.status` now has five values: `pending`, `confirmed`, `completed`, `cancelled`, `no_show` (migration).</li>
<li>The doctor's `change-status` accepts `completed` and `no_show`, once the appointment started, and refuses moves outside the flow.</li>
<li>Nothing changes a status automatically.</li>
<li>`display_status` now equals `status`; the derived `expired` value is gone. `status_label` gains "لم يحضر".</li>
<li>Rating a doctor, `can_rate` and the "rate your visit" push now need a `completed` visit, not just a confirmed one.</li>
<li>The doctor home totals skip `no_show`, and the profile `patients_count` counts `completed` visits.</li>
<li>The dashboard reservations filter and badges show the new statuses.</li>
</ul> |
| 2026-10-29 | Patient account & follow-up.
<ul>
<li>New endpoints: `reservations/cancelled`, `notifications/mark-all-as-read`, `delete-account`.</li>
<li>`reservations/upcoming` no longer lists cancelled appointments; it lists only those not started yet, soonest first. `reservations/past` lists only what has passed, without cancelled ones.</li>
<li>Reservations add `display_status`, `status_label`, `can_rate`, `cancellation`, `place.address`, `place.lat` and `place.lng`.</li>
<li>`cancel-reservation` accepts `reason` and `note`.</li>
<li>`general` adds `cancellation_reasons` and `whatsapp_number`.</li>
<li>Notifications add `is_read`, `group` and `target`.</li>
<li>`update-profile`: every field is optional, and it adds `birth_date` and `city_id`. The profile returns `full_phone`, `birth_date` and `city`.</li>
<li>`favorites` accepts `?type`.</li>
<li>New pushes: "new offer near you" when a doctor publishes an active offer, and "rate your visit" via `reservations:send-rating-requests`.</li>
<li>The doctor app reservation and the dashboard reservations table show the cancellation reason.</li>
<li>Migrations: `reservations.cancellation_reason`, `cancellation_note`, `rating_request_sent_at`; `patients.city_id`, `birth_date`.</li>
</ul> |
| 2026-10-29 | Payment for bookings is cash only. Every reservation returns `payment_type: "cash"` and `payment_method: "الدفع في العيادة"`, at a center and at a clinic. Before this, a center showed "الدفع في المركز". |
| 2026-10-29 | Booking at a clinic: same endpoints without `medical_center_id`. The reservation response (book, preview, details) adds `specialization` {id, name} for the "التخصص" row. |
| 2026-10-29 | Booking at a center.
<ul>
<li>New endpoints: `booking/days`, `booking/slots`, `booking/preview`, `reservations/{id}`, `reservations/{id}/reschedule`.</li>
<li>`reservations` (book):
  <ul>
  <li>`day_of_week` is now optional.</li>
  <li>The response adds `booking_number`, `date_label`, `time_label`, `service`, `place`, `payment_method`, `can_cancel`, `can_reschedule` and `change_deadline`.</li>
  <li>The patient gets a "booking received" push.</li>
  </ul></li>
<li>Cancel: pending **or confirmed**, until 4 hours before (`BOOKING_CHANGE_HOURS_BEFORE`).</li>
<li>A day-before reminder push is sent by `reservations:send-reminders` every 15 minutes. `reservations.reminder_sent_at` was added.</li>
</ul> |
| 2026-10-28 | Place and doctor detail screens.
<ul>
<li>New endpoints: `medical-centers/{id}`, `medical-centers/{id}/doctors`, `clinics/{doctor}`, `add-medical-center-to-favorite/{id}`, `remove-medical-center-from-favorite/{id}`.</li>
<li>`doctors/{doctor}` adds `profile`.</li>
<li>Favorites can hold medical centers.</li>
<li>`doctors.experience_years` was added. The doctor app sets it (`update-personal-information`, `complete-information` step 0), and so does the dashboard (doctor create / edit).</li>
</ul> |
| 2026-10-28 | Patient home and discovery screens. `home` now returns `location`, `unread_notifications_count`, `specializations`, `nearest_medical_centers` and `nearest_clinics`, keeps `best_doctors`, `latest_offers` and `patient_reservations`, and shows only active offers. New endpoints: `medical-centers`, `clinics`, `search`, `explore/map`, `location`, `locations`. Offers have `place`. `areas` got `lat` / `lng`, editable in the dashboard. |
| 2026-10-28 | Patient sign in moved to phone + OTP without a password. `send-otp` and `check-otp` now sign patients in and up; `check-otp` returns `is_new_user` and `profile_completed`. `complete-profile-data` accepts `name`. Patient `login`, `register` and `change-password` were removed from v2. `social-login` returns `is_new_user` and `profile_completed`. `patients.name` is nullable. |

---

---

---

---

---

---

---

---

---

---

---

---

---

---

---

---

---

## 10. API reference (v2)

Every mobile endpoint, as implemented in `routes/patient_api_v2.php` and `routes/doctor_api_v2.php`. Request fields come from the Form Requests and controllers. Response examples come from the API Resources; the sample values are illustrative, the field names are exact. `<<SomeResource>>` inside an example means the object described in [section 11](#11-response-objects).

### 10.0 Common rules

| Item | Value |
|---|---|
| **Base URL** | `{host}/api/v2` (local: `http://127.0.0.1:8000/api/v2`) |
| **Accept** | `application/json` (forced by the `json.response` middleware) |
| **Language** | `lang` query/body param, or `Content-Language` header: `ar` (default) or `en`. `Accept-Language` is ignored. Any other value → 403 `Language not supported.` |
| **Authorization** | Laravel Passport. `Authorization: Bearer <token>`; the token is `data.token` from login / register / social-login. Logout revokes it. |
| **Unauthenticated** | HTTP 401 `{"error": "Unauthenticated."}` |
| **Rate limit** | 60 requests/min per client (`throttle:api`); OTP send / verify have their own limits (`config/otp.php`). Exceeded → 429 `{"message": "Too Many Attempts."}` |
| **Success envelope** | `{"success": true, "data": ..., "message": "..."}`; paginated: adds `links` + `meta` (15 per page, `?page=N`) |
| **Failure envelope** | `{"success": false, "message": "..."}` (400 / 401 / 403 / 404) |
| **Validation error** | HTTP 422 `{"message": "...", "errors": {"field": ["..."]}}` |
| **Phone format** | `05XXXXXXXX` — regex `/(^(05)([0-9]{8})$)/u` |
| **Test OTP** | `1995` (accepted by verify and check-otp) |
| **Files** | Endpoints with files use `multipart/form-data` |

- **locale:** Examples assume the default locale ar (no lang param / Content-Language header). Localized fields (name, title, description, translatedFormat dates, diffForHumans) switch to English with lang=en.
- **images:** Image URLs come from getImagePathFromDirectory(): {APP_URL}/storage/Images/<Dir>/<file>, or a placeholder {APP_URL}/assets/dashboard/media/placeholders/<Dir>/default.svg when the file is missing.
- **decimals:** decimal columns (examination_price, price, price_after, price_before, amount) are returned as strings by MySQL, e.g. "150.00".
- **carbon:** Date attributes returned as Carbon objects by a Resource (not pre-formatted) serialize as ISO-8601, e.g. "2026-11-27T00:00:00.000000Z".
- **pagination:** Laravel paginator, 15 per page (nearest-medical-centers: per_page, default 20). links = {first,last,prev,next}; meta = {current_page,from,last_page,links[],path,per_page,to,total}.
- **validation_422:** Laravel ValidationException body: message = first error text (+ ' (and N more errors)'), errors = {field:[msgs]}. Controller validationFailure() uses fixed message 'The given data was invalid.'.
- **unauthenticated_401:** App\Exceptions\Handler::unauthenticated returns {"error":"Unauthenticated."} (key 'error', not 'message') for JSON requests.
- **model_404:** Implicit route-model binding miss: {"message":"No query results for model [App\\Models\\X] <id>"}. abort(404) gives {"message":""}.
- **throttle_429:** {"message":"Too Many Attempts."} with Retry-After / X-RateLimit-* headers. api group: 60/min per user or IP. otp-send: 3 per account + 20 per IP per 10 min. otp-verify: 5 per account + 30 per IP per 10 min.
- **language_403:** Any route: lang / Content-Language other than ar|en -> 403 {"message":"Language not supported."}

### Contents

- [10.1 Patient App — Public](#10-1-patient-app-public)
- [10.2 Patient App — Authenticated (auth:patient)](#10-2-patient-app-authenticated-auth-patient)
- [10.3 Doctor App — Public](#10-3-doctor-app-public)
- [10.4 Doctor App — Authenticated (auth:doctor)](#10-4-doctor-app-authenticated-auth-doctor)

### 10.1 Patient App — Public

#### 10.1.1 Send OTP

`POST /api/v2/patient/send-otp`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | `application/json` |
| **Extra rate limit** | OTP send limit (`throttle:otp-send`) |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `phone` | string | required | Saudi mobile; accepted as 5XXXXXXXX / 05XXXXXXXX / +9665XXXXXXXX / 9665XXXXXXXX / 009665XXXXXXXX with spaces; stored as 05XXXXXXXX |

**Notes:** Step 1 of sign in / sign up (no password). Works for new and existing phones; no account is created here. Sends a 4-digit SMS code valid 5 minutes; a new request replaces the previous code. Use it again for Resend code and Change number. throttle:otp-send (3 per phone / 20 per IP every 10 minutes)

**Request example**

```json
{
  "phone": "{{patient_phone}}"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "phone": "0551234567",
    "full_phone": "+966551234567",
    "resend_after": 45,
    "expires_in": 300
  },
  "message": "otp sent successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | phone missing or not a Saudi mobile | `{"message": "رقم الهاتف يجب ان يبدأ ب 05 متبوعاً ب 8 ارقام ", "errors": {"phone": ["رقم الهاتف يجب ان يبدأ ب 05 متبوعاً ب 8 ارقام "]}}` |
| 429 | OTP limit reached (3 per phone / 20 per IP in 10 minutes) | `{"message": "Too Many Attempts."}` |

---

#### 10.1.2 Verify OTP (Sign In)

`POST /api/v2/patient/check-otp`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | `application/json` |
| **Extra rate limit** | OTP verify limit (`throttle:otp-verify`) |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `phone` | string | required | same formats as send-otp |
| `otp` | string | required | 4-digit code from the SMS or fixed 1995 |
| `fcm_token` | string | optional | max:255, device push token |

**Notes:** Step 2. Right code: creates the account when the phone is new (name empty), or signs in to the existing account (including a walk-in patient a doctor added). The code works once. Response has token, is_new_user (first sign in to the app) and profile_completed (name given); show the complete-profile screen when profile_completed is false. The phone may also be sent in the URL: POST /api/v2/patient/check-otp/{phone}. throttle:otp-verify (5 per phone / 30 per IP every 10 minutes)

**Request example**

```json
{
  "phone": "{{patient_phone}}",
  "otp": "{{otp}}",
  "fcm_token": "{{fcm_token}}"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...",
    "is_new_user": true,
    "profile_completed": false,
    "patient": "<<PatientResource>>"
  },
  "message": "logged in successfully"
}
```

_Note: is_new_user is true on the first sign in to the app (also for a walk-in patient added by a doctor); profile_completed is false while name is empty. patient.name is null for a new account._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | wrong, expired (after 5 minutes) or already used code | `{"message": "الرمز غير صحيح. تحقق منه وحاول مرة أخرى.", "errors": {"otp": ["الرمز غير صحيح. تحقق منه وحاول مرة أخرى."]}}` |
| 422 | wrong code with lang=en | `{"message": "Incorrect code. Check it and try again.", "errors": {"otp": ["Incorrect code. Check it and try again."]}}` |
| 422 | phone missing or not a Saudi mobile | `{"message": "رقم الهاتف يجب ان يبدأ ب 05 متبوعاً ب 8 ارقام ", "errors": {"phone": ["رقم الهاتف يجب ان يبدأ ب 05 متبوعاً ب 8 ارقام "]}}` |
| 422 | otp missing | `{"message": "حقل ( رمز التحقق ) مطلوب", "errors": {"otp": ["حقل ( رمز التحقق ) مطلوب"]}}` |
| 429 | OTP limit reached (5 per phone / 30 per IP in 10 minutes) | `{"message": "Too Many Attempts."}` |

Objects: [PatientResource](#patientresource)

---

#### 10.1.3 General Data

`GET /api/v2/patient/general`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Notes:** returns data.titles, data.cities, data.main_specializations, data.cancellation_reasons [{key, label}] (the cancel sheet), data.whatsapp_number (help & support: contact us)

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "titles": [
      "<<TitleResource>>"
    ],
    "cities": [
      "<<CityResource>>"
    ],
    "main_specializations": [
      "<<SpecializationResource>>"
    ],
    "cancellation_reasons": [
      {
        "key": "schedule_conflict",
        "label": "تعارض في الموعد"
      },
      {
        "key": "feeling_better",
        "label": "تحسنت حالتي"
      },
      {
        "key": "found_earlier",
        "label": "وجدت موعداً أقرب"
      },
      {
        "key": "other",
        "label": "سبب آخر"
      }
    ],
    "whatsapp_number": "+966551112222"
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [CityResource](#cityresource), [SpecializationResource](#specializationresource), [TitleResource](#titleresource)

---

#### 10.1.4 Social Login

`POST /api/v2/patient/social-login`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `provider` | string | required | in:google, apple |
| `id_token` | string | required | provider ID token, verified server side |
| `fcm_token` | string | required |  |
| `social_id` | string | optional | must equal the verified token subject if sent |
| `name` | string | optional | used only on first login when provider gives no name |

**Notes:** response data.token, data.is_new_user, data.profile_completed, data.patient; invalid token -> 401 failure; first login needs provider email (else 422 errors.email), email unique in patients

**Request example**

```json
{
  "provider": "google",
  "id_token": "<provider id token>",
  "fcm_token": "{{fcm_token}}",
  "name": "Test Patient"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...",
    "is_new_user": true,
    "profile_completed": true,
    "patient": "<<PatientResource>>"
  },
  "message": "logged in successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | id_token fails verification, or social_id differs from the verified subject | `{"success": false, "message": "invalid social login credentials"}` |
| 422 | first login and provider gave no verified e-mail | `{"message": "The provider did not share a verified e-mail address.", "errors": {"email": ["The provider did not share a verified e-mail address."]}}` |
| 422 | first login and e-mail already used by another patient | `{"message": "قيمة ( البريد الإلكتروني ) مُستخدمة من قبل", "errors": {"email": ["قيمة ( البريد الإلكتروني ) مُستخدمة من قبل"]}}` |
| 422 | provider not google/apple / fields missing | `{"message": " اختيارك ل provider غير صحيح.", "errors": {"provider": [" اختيارك ل provider غير صحيح."]}}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PatientResource](#patientresource)

---

#### 10.1.5 Terms of Service

`GET /api/v2/patient/terms-of-service`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Notes:** data.terms = setting terms_{locale}

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "terms": "<p>الشروط والأحكام...</p>"
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.1.6 Privacy Policy

`GET /api/v2/patient/privacy-policy`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Notes:** data.privacy = setting privacy_{locale}

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "privacy": "<p>سياسة الخصوصية...</p>"
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.1.7 Doctors (search & filter)

`GET /api/v2/patient/doctors`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `lat` | numeric | optional | -90..90 |
| `lng` | numeric | optional | -180..180; lat+lng sort by distance only when no area_id/city_id |
| `area_id` | integer | optional | takes priority over city_id |
| `city_id` | integer | optional | filters by city's areas |
| `name` | string | optional | max:80, LIKE on doctor name, clinic_name, medical center name_ar/name_en |
| `main_specialization_id` | integer | optional |  |
| `specialization_id` | integer | optional | main OR sub specialization |
| `specializations[]` | array of integer | optional | sub specialization ids |
| `medical_center_id` | integer | optional |  |
| `titles[]` | array of integer | optional | title ids |
| `gender` | string | optional | max:20, male\|female |
| `availability` | string | optional | any\|today\|tomorrow |
| `arrange_by` | string | optional | most_recommended\|lowest_price\|highest_price\|short_waiting_time\|most_wanted |
| `min_price` | numeric | optional | min:0 |
| `max_price` | numeric | optional | min:0; price filter applied only when both sent |
| `page` | int | optional |  |

**Notes:** sponsored (running ad) doctors always first; response data.max_price, data.min_price, data.doctors {data,links,meta}

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "max_price": "500.00",
    "min_price": "0.00",
    "doctors": {
      "data": [
        "<<PatientDoctorResource>>"
      ],
      "links": "<<PaginationLinks>>",
      "meta": "<<PaginationMeta>>"
    }
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | invalid filter types (lat out of range, non-integer ids, negative price...) | `{"message": "يجب أن تكون قيمة ( العنوان من الخريطة ) بين -90 و 90", "errors": {"lat": ["يجب أن تكون قيمة ( العنوان من الخريطة ) بين -90 و 90"]}}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta), [PatientDoctorResource](#patientdoctorresource)

---

#### 10.1.8 Best (Sponsored) Doctors

`GET /api/v2/patient/best-doctors`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** doctors with running ad ordered by ads.order desc; successWithPagination envelope (data, links, meta)

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<PatientDoctorResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta), [PatientDoctorResource](#patientdoctorresource)

---

#### 10.1.9 Doctor Details

`GET /api/v2/patient/doctors/{doctor}`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Path parameters:** `doctor`

**Notes:** path {doctor}=doctor id; data.doctor, data.places, data.ratings; data.profile = the doctor profile screen (headline "استشاري طب الأسنان · مجمع النور الطبي", rating, ratings_count, experience_years, patients_count, bio, branches grouped by city, services [{name: "كشف واستشارة " + specialization, price}], is_favorite)

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "doctor": "<<PatientDoctorResource>>",
    "profile": "<<DoctorProfile>>",
    "places": [
      "<<DoctorPlace>>"
    ],
    "ratings": [
      "<<RatingResource>>"
    ]
  },
  "message": ""
}
```

_Note: profile holds the doctor profile screen: headline, rating, experience_years, patients_count, bio, branches grouped by city, services._

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no Doctor with that id | `{"message": "No query results for model [App\\Models\\Doctor] 999"}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorPlace](#doctorplace), [DoctorProfile](#doctorprofile), [PatientDoctorResource](#patientdoctorresource), [RatingResource](#ratingresource)

---

#### 10.1.10 Doctor Offers

`GET /api/v2/patient/doctors/{doctor}/offers`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Path parameters:** `doctor`

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** active offers of doctor; paginated envelope

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<PatientOfferResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no Doctor with that id | `{"message": "No query results for model [App\\Models\\Doctor] 999"}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta), [PatientOfferResource](#patientofferresource)

---

#### 10.1.11 Search by Name

`GET /api/v2/patient/search-by-name`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `name` | string | required | max:80 |
| `lat` | numeric | required | -90..90 |
| `lng` | numeric | required | -180..180 |

**Notes:** data.specialization (top 5 by name_ar/name_en LIKE), data.medicals_centers (top 5, nearest first)

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "specialization": [
      "<<SpecializationResource>>"
    ],
    "medicals_centers": [
      {
        "id": 2,
        "logo": "{APP_URL}/storage/Images/MedicalCenters/center.png",
        "name": "مجمع النخبة الطبي",
        "description": "مجمع طبي متكامل"
      }
    ]
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | name / lat / lng missing or invalid | `{"message": "حقل ( الأسم ) مطلوب (and 2 more errors)", "errors": {"name": ["حقل ( الأسم ) مطلوب"]}}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [SpecializationResource](#specializationresource)

---

#### 10.1.12 Nearest Medical Centers

`GET|POST /api/v2/patient/nearest-medical-centers`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | GET: query string · POST: `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `lat` | numeric | required | -90..90 |
| `lng` | numeric | required | -180..180 |
| `per_page` | integer | optional | 1..100, default 20 |
| `radius_km` | numeric | optional | >0, expanding radius: doubles until nearest center reached |
| `max_radius_km` | numeric | optional | >0, default 20038 |
| `page` | int | optional |  |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `lat` | numeric | required | -90..90 |
| `lng` | numeric | required | -180..180 |
| `per_page` | integer | optional | 1..100, default 20 |
| `radius_km` | numeric | optional | >0, expanding radius: doubles until nearest center reached |
| `max_radius_km` | numeric | optional | >0, default 20038 |
| `page` | int | optional |  |

**Success response — 200**

```json
{
  "success": true,
  "data": [
    {
      "id": 2,
      "logo": "{APP_URL}/storage/Images/MedicalCenters/center.png",
      "name": "مجمع النخبة الطبي",
      "description": "مجمع طبي متكامل",
      "distance_km": 3.42
    }
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | lat / lng missing or out of range, per_page outside 1..100, radius_km <= 0 | `{"message": "حقل ( خط العرض ) مطلوب (and 1 more error)", "errors": {"lat": ["حقل ( خط العرض ) مطلوب"]}}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta)

---

#### 10.1.13 Medical Center Specializations

`GET /api/v2/patient/medical-centers/{medical_center}/specializations`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Path parameters:** `medical_center`

**Notes:** path {medical_center}=id; distinct specializations of the center's doctors

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<SpecializationResource>>"
  ],
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no MedicalCenter with that id | `{"message": "No query results for model [App\\Models\\MedicalCenter] 999"}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [SpecializationResource](#specializationresource)

---

#### 10.1.14 Doctor Available Schedules (clinic)

`GET /api/v2/patient/{doctor}/available-schedules/{medical_center?}`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Path parameters:** `doctor`, `medical_center`

**Notes:** path {doctor}=doctor id, {medical_center} optional id (omit = doctor's own clinic); data.schedules (weeks -> days -> time_slots[].available; all false if doctor not accepting online booking)

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "schedules": [
      "<<TimeSlotsWeek>>"
    ]
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no Doctor with that id | `{"message": "No query results for model [App\\Models\\Doctor] 999"}` |
| 404 | no MedicalCenter with that id | `{"message": "No query results for model [App\\Models\\MedicalCenter] 999"}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [TimeSlotsWeek](#timeslotsweek)

---

#### 10.1.15 Home

`GET /api/v2/patient/home`

| | |
|---|---|
| **Authorization** | Optional patient Bearer token — without it the response is still returned for guests |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `lat` | numeric | optional; location label + nearest first |  |
| `lng` | numeric | optional |  |
| `specialization_id` | integer | optional | the selected chip: filters places and offers |
| `city_id` | integer | optional |  |
| `area_id` | integer | optional |  |

**Notes:** Home screen. Sections: location, unread_notifications_count, specializations (main, the chips), latest_offers (10 active, each with place), nearest_medical_centers (4), nearest_clinics (4), best_doctors (sponsored, 15), patient_reservations (5)

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "location": "<<Location>>",
    "unread_notifications_count": 2,
    "specializations": [
      "<<SpecializationResource>>"
    ],
    "latest_offers": [
      {
        "id": 1,
        "city_id": null,
        "city_name": null,
        "main_pic": "{APP_URL}/storage/Images/Offers/offer.png",
        "title": "تنظيف الأسنان",
        "description": "وصف",
        "is_price_shown": true,
        "price_after": "199.00",
        "price_before": "299.00",
        "is_active": 1,
        "place": {
          "type": "medical_center",
          "id": 1,
          "name": "مركز العناية الطبي"
        },
        "doctor": "<<PatientDoctorResource>>"
      }
    ],
    "nearest_medical_centers": [
      "<<MedicalCenterCardResource>>"
    ],
    "nearest_clinics": [
      "<<ClinicCardResource>>"
    ],
    "best_doctors": [
      "<<PatientDoctorResource>>"
    ],
    "patient_reservations": [
      "<<PatientReservationResource>>"
    ]
  },
  "message": ""
}
```

_Note: location is null without lat/lng or while no area has coordinates. patient_reservations is [] and unread_notifications_count is 0 for guests. nearest_* hold up to 4 items; latest_offers up to 10 active offers._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | lat without lng / out of range, unknown city_id / area_id / specialization_id, per_page > 50 | `{"message": "حقل ( خط الطول ) مطلوب عند تحديد ( خط العرض )", "errors": {"lng": ["حقل ( خط الطول ) مطلوب عند تحديد ( خط العرض )"]}}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [ClinicCardResource](#cliniccardresource), [Location](#location), [MedicalCenterCardResource](#medicalcentercardresource), [PatientDoctorResource](#patientdoctorresource), [PatientReservationResource](#patientreservationresource), [SpecializationResource](#specializationresource)

---

#### 10.1.16 Medical Centers (explore list / view all)

`GET /api/v2/patient/medical-centers`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `lat` | numeric | optional | -90..90; with lng: distance_km and nearest first |
| `lng` | numeric | optional | -180..180 |
| `radius_km` | numeric | optional | >0..500 |
| `city_id` | integer | optional | exists:cities |
| `area_id` | integer | optional | exists:areas; priority over city_id |
| `specialization_id` | integer | optional | main or sub specialization |
| `search` | string | optional | max:80 |
| `available_today` | boolean | optional |  |
| `per_page` | integer | optional | 1..50, default 15 |
| `page` | int | optional |  |

**Notes:** Explore list and home "view all". Only centers with at least one doctor visible to patients. search matches the center name or a doctor's specialization name. Paginated

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<MedicalCenterCardResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | lat without lng / out of range, unknown city_id / area_id / specialization_id, per_page > 50 | `{"message": "حقل ( خط الطول ) مطلوب عند تحديد ( خط العرض )", "errors": {"lng": ["حقل ( خط الطول ) مطلوب عند تحديد ( خط العرض )"]}}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [MedicalCenterCardResource](#medicalcentercardresource), [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta)

---

#### 10.1.17 Clinics (explore list / view all)

`GET /api/v2/patient/clinics`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `lat` | numeric | optional | -90..90; with lng: distance_km and nearest first |
| `lng` | numeric | optional | -180..180 |
| `radius_km` | numeric | optional | >0..500 |
| `city_id` | integer | optional | exists:cities |
| `area_id` | integer | optional | exists:areas; priority over city_id |
| `specialization_id` | integer | optional | main or sub specialization |
| `search` | string | optional | max:80 |
| `available_today` | boolean | optional |  |
| `per_page` | integer | optional | 1..50, default 15 |
| `page` | int | optional |  |

**Notes:** Explore list and home "view all": doctors' own clinics (work_for clinic or both), card id = doctor id. search matches clinic name, doctor name or specialization name. Paginated

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<ClinicCardResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | lat without lng / out of range, unknown city_id / area_id / specialization_id, per_page > 50 | `{"message": "حقل ( خط الطول ) مطلوب عند تحديد ( خط العرض )", "errors": {"lng": ["حقل ( خط الطول ) مطلوب عند تحديد ( خط العرض )"]}}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [ClinicCardResource](#cliniccardresource), [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta)

---

#### 10.1.18 Search

`GET /api/v2/patient/search`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `search` | string | required | max:80 |
| `lat` | numeric | optional |  |
| `lng` | numeric | optional |  |
| `specialization_id` | integer | optional | the selected chip |
| `per_page` | integer | optional | 1..50, default 10, items per list |

**Notes:** Search screen: matching specializations (chips), medical centers and clinics, each list with its total. Empty lists = the no-results screen

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "search": "أسنان",
    "specializations": [
      "<<SpecializationResource>>"
    ],
    "medical_centers": {
      "total": 4,
      "data": [
        "<<MedicalCenterCardResource>>"
      ]
    },
    "clinics": {
      "total": 2,
      "data": [
        "<<ClinicCardResource>>"
      ]
    }
  },
  "message": ""
}
```

**Alternative success response**

```json
{
  "success": true,
  "data": {
    "search": "تقويم الأسنان",
    "specializations": [],
    "medical_centers": {
      "total": 0,
      "data": []
    },
    "clinics": {
      "total": 0,
      "data": []
    }
  },
  "message": ""
}
```

_Note: The alternative example is the "no results" screen._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | search missing | `{"message": "حقل ( search ) مطلوب", "errors": {"search": ["حقل ( search ) مطلوب"]}}` |
| 422 | lat without lng / out of range, unknown city_id / area_id / specialization_id, per_page > 50 | `{"message": "حقل ( خط الطول ) مطلوب عند تحديد ( خط العرض )", "errors": {"lng": ["حقل ( خط الطول ) مطلوب عند تحديد ( خط العرض )"]}}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [ClinicCardResource](#cliniccardresource), [MedicalCenterCardResource](#medicalcentercardresource), [SpecializationResource](#specializationresource)

---

#### 10.1.19 Explore Map

`GET /api/v2/patient/explore/map`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `lat` | numeric | optional |  |
| `lng` | numeric | optional |  |
| `radius_km` | numeric | optional | default 30 when lat/lng are sent |
| `city_id` | integer | optional |  |
| `area_id` | integer | optional |  |
| `specialization_id` | integer | optional |  |
| `search` | string | optional |  |
| `available_today` | boolean | optional |  |

**Notes:** Explore map pins and the card under the map: up to 100 centers and 100 clinics with a location, not paginated

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "medical_centers": [
      "<<MedicalCenterCardResource>>"
    ],
    "clinics": [
      "<<ClinicCardResource>>"
    ]
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | lat without lng / out of range, unknown city_id / area_id / specialization_id, per_page > 50 | `{"message": "حقل ( خط الطول ) مطلوب عند تحديد ( خط العرض )", "errors": {"lng": ["حقل ( خط الطول ) مطلوب عند تحديد ( خط العرض )"]}}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [ClinicCardResource](#cliniccardresource), [MedicalCenterCardResource](#medicalcentercardresource)

---

#### 10.1.20 Current Location

`GET /api/v2/patient/location`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `lat` | numeric | required | -90..90 |
| `lng` | numeric | required | -180..180 |

**Notes:** Location label on home and in the picker: the area whose centre (entered in the dashboard) is nearest to the point

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "area_id": 1,
    "area": "حي الفيصلية",
    "city_id": 1,
    "city": "الدمام",
    "label": "الدمام، حي الفيصلية",
    "lat": 26.42,
    "lng": 50.09
  },
  "message": ""
}
```

**Alternative success response**

```json
{
  "success": true,
  "data": null,
  "message": ""
}
```

_Note: data is null while no area has coordinates (enter them in the dashboard: Settings > Areas)._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | lat / lng missing or out of range | `{"message": "حقل ( خط العرض ) مطلوب", "errors": {"lat": ["حقل ( خط العرض ) مطلوب"]}}` |

---

#### 10.1.21 Locations (picker search)

`GET /api/v2/patient/locations`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `search` | string | optional | max:80, area or city name |

**Notes:** Location picker search box: up to 30 areas with city, label and centre coordinates (to move the map)

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<Location>>"
  ],
  "message": ""
}
```

Objects: [Location](#location)

---

#### 10.1.22 Medical Center Details

`GET /api/v2/patient/medical-centers/{medical_center}`

| | |
|---|---|
| **Authorization** | Optional patient Bearer token — without it the response is still returned for guests |
| **Content-Type** | — |

**Path parameters:** `medical_center`

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `lat` | numeric | optional |  |
| `lng` | numeric | optional |  |

**Notes:** Medical center screen: the card, about (description), address, images, doctors_count, specializations (icons), the center's offers (active offers of its doctors, up to 10), ratings {count, average, latest 10}, is_favorite. 404 when no doctor patients can see works there

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "medical_center": "<<MedicalCenterCardResource>>",
    "description": "رعاية طبية متكاملة لك ولعائلتك في مكان واحد.",
    "location": "طريق الملك فهد",
    "images": [
      "{APP_URL}/assets/dashboard/media/placeholders/default.svg"
    ],
    "doctors_count": 2,
    "specializations": [
      "<<SpecializationResource>>"
    ],
    "offers": [
      "<<PatientOfferResource>>"
    ],
    "ratings": "<<PlaceRatings>>",
    "is_favorite": false
  },
  "message": ""
}
```

_Note: Send lat/lng for medical_center.distance_km. is_favorite needs a patient token (false for guests)._

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | unknown id, or no doctor patients can see works there | `{"success": false, "message": "المركز غير متاح"}` |

Objects: [MedicalCenterCardResource](#medicalcentercardresource), [PatientOfferResource](#patientofferresource), [PlaceRatings](#placeratings), [SpecializationResource](#specializationresource)

---

#### 10.1.23 Doctors at Center

`GET /api/v2/patient/medical-centers/{medical_center}/doctors`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Path parameters:** `medical_center`

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `specialization_id` | integer | optional | the selected chip |

**Notes:** "Doctors at center": header (name, image, doctors_count, specializations_count), the specialization chips and the doctors (highest rated first)

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "medical_center": {
      "id": 1,
      "name": "مجمع النور الطبي",
      "image": "{APP_URL}/assets/dashboard/media/placeholders/default.svg",
      "doctors_count": 2,
      "specializations_count": 2
    },
    "specializations": [
      "<<SpecializationResource>>"
    ],
    "doctors_count": 2,
    "doctors": [
      "<<DoctorCardResource>>"
    ]
  },
  "message": ""
}
```

_Note: medical_center.doctors_count / specializations_count describe the whole center; doctors_count next to the list counts the filtered doctors._

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | unknown id, or no doctor patients can see works there | `{"success": false, "message": "المركز غير متاح"}` |

Objects: [DoctorCardResource](#doctorcardresource), [SpecializationResource](#specializationresource)

---

#### 10.1.24 Clinic Details

`GET /api/v2/patient/clinics/{doctor}`

| | |
|---|---|
| **Authorization** | Optional patient Bearer token — without it the response is still returned for guests |
| **Content-Type** | — |

**Path parameters:** `doctor`

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `lat` | numeric | optional |  |
| `lng` | numeric | optional |  |

**Notes:** Clinic screen: {doctor} is the doctor id. The card, about, address, all clinic photos, the doctor's offers, ratings {count, average, latest 10}, is_favorite (the doctor saved as favorite)

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "clinic": "<<ClinicCardResource>>",
    "description": "عيادة أسنان",
    "location": "address",
    "images": [
      "{APP_URL}/assets/dashboard/media/placeholders/default.svg"
    ],
    "offers": [
      "<<PatientOfferResource>>"
    ],
    "ratings": "<<PlaceRatings>>",
    "is_favorite": false
  },
  "message": ""
}
```

_Note: {doctor} is the doctor id (the id of the clinic card). 404 for a doctor who has no clinic._

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | unknown id, or no doctor patients can see works there | `{"success": false, "message": "العيادة غير متاحة"}` |

Objects: [ClinicCardResource](#cliniccardresource), [PatientOfferResource](#patientofferresource), [PlaceRatings](#placeratings)

---

#### 10.1.25 Booking Days

`GET /api/v2/patient/booking/days`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `doctor_id` | integer | optional | the chosen doctor; leave out for "any available doctor" |
| `medical_center_id` | integer | required without doctor_id; empty with a doctor = the doctor's own clinic |  |
| `specialization_id` | integer | required without doctor_id |  |

**Notes:** Booking step "date & time": the next 28 days with status available / full / closed

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "days": [
      "<<BookingDay>>"
    ]
  },
  "message": ""
}
```

_Note: 28 days from today. status: available (a free time left), full (working, everything taken or passed), closed (day off / nobody works)._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | doctor does not work at that place / no doctor and no specialization_id + medical_center_id | `{"message": "The doctor does not work at this place.", "errors": {"doctor_id": ["The doctor does not work at this place."]}}` |

Objects: [BookingDay](#bookingday)

---

#### 10.1.26 Booking Slots

`GET /api/v2/patient/booking/slots`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `date` | Y-m-d | required |  |
| `doctor_id` |  |  |  |
| `medical_center_id` |  |  |  |
| `specialization_id` | as booking/days |  |  |

**Notes:** One day's times split into morning (before 12:00) and evening: time ("09:00 AM", send it to reservations), label ("9:00 ص"), available, doctor_id

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "date": "2026-11-05",
    "morning": [
      "<<BookingSlot>>"
    ],
    "evening": [
      "<<BookingSlot>>"
    ]
  },
  "message": ""
}
```

_Note: Send time and doctor_id of the chosen slot to booking/preview and reservations. With "any available doctor" each free time names the doctor it is with._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | date missing | `{"message": "حقل ( date ) مطلوب", "errors": {"date": ["حقل ( date ) مطلوب"]}}` |
| 422 | doctor does not work at that place / no doctor and no specialization_id + medical_center_id | `{"message": "The doctor does not work at this place.", "errors": {"doctor_id": ["The doctor does not work at this place."]}}` |

Objects: [BookingSlot](#bookingslot)

---

#### 10.1.27 Offers

`GET /api/v2/patient/offers`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `city_id` | int | optional |  |
| `sub_specializations[]` | array of int | optional |  |
| `availability` |  | optional | any\|today\|tomorrow |
| `title` | string | optional | LIKE on title_{locale} |
| `gender` |  | optional | male\|female, other values ignored |
| `title_ids[]` | array of int | optional | doctor title ids |
| `arrange_by` |  | optional | most_recommended\|lowest_price\|highest_price |
| `minPrice` | numeric | optional |  |
| `maxPrice` | numeric | optional; both needed; camelCase names |  |
| `page` | int | optional |  |

**Notes:** OfferController __invoke; no validation (unvalidated query); only is_active offers; data.offers {data,links,meta}, data.max_price, data.min_price; each offer has place {type, id, name}: the doctor's medical center, or their clinic when they work at no center

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "offers": {
      "data": [
        "<<PatientOfferResource>>"
      ],
      "links": "<<PaginationLinks>>",
      "meta": "<<PaginationMeta>>"
    },
    "max_price": "400.00",
    "min_price": "50.00"
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta), [PatientOfferResource](#patientofferresource)

---

#### 10.1.28 Countries

`GET /api/v2/patient/countries`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Notes:** data = CountryResource list

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<CountryResource>>"
  ],
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [CountryResource](#countryresource)

---

#### 10.1.29 Main Specializations

`GET /api/v2/patient/main-specializations`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `name` | string | optional | LIKE on name_{locale} |

**Notes:** data = specialization list (parent_id null)

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<SpecializationResource>>"
  ],
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [SpecializationResource](#specializationresource)

---

#### 10.1.30 Sub Specializations

`GET /api/v2/patient/main-specializations/{specialization}/sub-specializations`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Path parameters:** `specialization`

**Notes:** path {specialization}=id; data = sub specializations list

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<SpecializationResource>>"
  ],
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no Specialization with that id | `{"message": "No query results for model [App\\Models\\Specialization] 999"}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [SpecializationResource](#specializationresource)

---

#### 10.1.31 Areas

`GET /api/v2/patient/areas`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `name` | string | optional | LIKE on name_{locale} |

**Notes:** data = all areas

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<AreaResource>>"
  ],
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [AreaResource](#arearesource)

---

#### 10.1.32 City Areas

`GET /api/v2/patient/cities/{city}/areas`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Path parameters:** `city`

**Notes:** path {city}=id; data = areas of city

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<AreaResource>>"
  ],
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no City with that id | `{"message": "No query results for model [App\\Models\\City] 999"}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [AreaResource](#arearesource)

---

### 10.2 Patient App — Authenticated (auth:patient)

#### 10.2.1 Current Patient

`GET /api/v2/patient/current`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Notes:** closure; returns the raw Patient model JSON (no envelope), social_id/fcm_token/deleted_at hidden

**Success response — 200**

```json
"<<PatientModelRaw>>"
```

_Note: raw model JSON, no envelope_

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PatientModelRaw](#patientmodelraw)

---

#### 10.2.2 Rate Doctor

`POST /api/v2/patient/ratings`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `doctor_id` | int | required | exists:doctors |
| `rate` | integer | required | 1..5 |
| `comment` | string | optional |  |

**Notes:** StoreRateApiRequest; 403 unless the patient has a visit the doctor marked completed; 422 errors.doctor_id if already rated

**Request example**

```json
{
  "doctor_id": "{{doctor_id}}",
  "rate": 5,
  "comment": "Excellent"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<PatientRatingResource>>",
  "message": "created successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 403 | no confirmed appointment with this doctor | `{"success": false, "message": "You can review a doctor only after a confirmed appointment with them."}` |
| 422 | already rated this doctor | `{"message": "You have already reviewed this doctor.", "errors": {"doctor_id": ["You have already reviewed this doctor."]}}` |
| 422 | rate missing / not 1..5, doctor_id missing or unknown | `{"message": "يجب عليك تحديد التقيم", "errors": {"rate": ["يجب عليك تحديد التقيم"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PatientRatingResource](#patientratingresource)

---

#### 10.2.3 Change Phone

`POST /api/v2/patient/change-phone`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |
| **Extra rate limit** | OTP send limit (`throttle:otp-send`) |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `phone` | string | required | 05XXXXXXXX, max:255, unique:patients except self |

**Notes:** throttle:otp-send; updates phone then sends OTP

**Request example**

```json
{
  "phone": "0500000002"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "phone updated and otp sent successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | phone invalid format or taken | `{"message": "قيمة ( الهاتف ) مُستخدمة من قبل", "errors": {"phone": ["قيمة ( الهاتف ) مُستخدمة من قبل"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | throttle:otp-send (3 per account / 20 per IP per 10 min) or api 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.2.4 Resend OTP

`POST /api/v2/patient/resend-otp`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |
| **Extra rate limit** | OTP send limit (`throttle:otp-send`) |

**Notes:** throttle:otp-send

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "otp sent successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | throttle:otp-send (3 per account / 20 per IP per 10 min) or api 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.2.5 Verify Phone

`POST /api/v2/patient/verify`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |
| **Extra rate limit** | OTP verify limit (`throttle:otp-verify`) |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `otp` | string | required in practice - no validation rule; must equal stored OTP or 1995 |  |

**Notes:** throttle:otp-verify; wrong -> 422 {message, errors.otp}; success data = PatientResource

**Request example**

```json
{
  "otp": "{{otp}}"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<PatientResource>>",
  "message": "verified successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | otp not the stored code nor 1995 (validationFailure; errors.otp is a string, not an array) | `{"message": "The given data was invalid.", "errors": {"otp": "wrong code"}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | throttle:otp-verify (5 per account / 30 per IP per 10 min) or api 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PatientResource](#patientresource)

---

#### 10.2.6 Logout

`POST /api/v2/patient/logout`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Notes:** revokes current Passport token

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "You have been successfully logged out!"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.2.7 Delete Account

`POST /api/v2/patient/delete-account`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Notes:** "Delete account" on personal info: cancels upcoming appointments (doctors are notified), revokes every token, soft-deletes the patient

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "account deleted successfully"
}
```

_Note: Upcoming pending / confirmed appointments are cancelled and their doctors notified; all tokens are revoked; the patient is soft-deleted (history kept)._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |

---

#### 10.2.8 Complete Profile Data

`POST /api/v2/patient/complete-profile-data`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `name` | string | optional | max:255 |
| `email` | string | optional | email, unique:patients except self |
| `gender` |  | optional | in:male, female |
| `weight` | string | optional | max:255 |
| `height` | string | optional | max:255 |
| `birth_date` | date | optional | Y-m-d |
| `city_id` | integer | optional | exists:cities |

**Notes:** Complete-profile screen after the first sign in (Auth 06); every field optional, send only what the patient filled. data = PatientResource

**Request example**

```json
{
  "name": "سارة أحمد",
  "email": "sara@example.com"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<PatientResource>>",
  "message": "profile completed successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | email invalid / taken, gender not male/female | `{"message": "قيمة ( البريد الإلكتروني ) مُستخدمة من قبل", "errors": {"email": ["قيمة ( البريد الإلكتروني ) مُستخدمة من قبل"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PatientResource](#patientresource)

---

#### 10.2.9 Book Reservation

`POST /api/v2/patient/reservations`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `doctor_id` | int | required | exists:doctors |
| `medical_center_id` | int | optional | exists:medical_centers; omit/null = doctor's clinic |
| `date` | string | required | Y-m-d |
| `time` | string | required | format "h:i A" e.g. 05:30 PM |
| `day_of_week` | string | optional | taken from the date when left out |
| `note` | string | optional | max:500, shown to the doctor |

**Notes:** PatientAppRequests\StoreReservationApiRequest; 422 errors.doctor_id if doctor not bookable/closed; 422 errors.time if slot taken / not offered / already started; the response has booking_number (DR-00042), date_label, time_label, service, place {name, branch, phone}, payment_method, can_cancel, can_reschedule; the patient gets a "booking received" push

**Request example — Book Reservation**

```json
{
  "doctor_id": "{{doctor_id}}",
  "medical_center_id": "{{medical_center_id}}",
  "date": "2026-11-05",
  "time": "04:30 PM",
  "note": "أرجو التواصل معي"
}
```

**Request example — Book at Clinic**

```json
{
  "doctor_id": "{{doctor_id}}",
  "medical_center_id": null,
  "date": "2026-11-05",
  "time": "04:30 PM"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<PatientReservationResource>>",
  "message": "reservation created successfully"
}
```

_Note: The doctor gets "new booking" and the patient "booking received" (push + notifications list)._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | slot taken meanwhile | `{"message": "This time slot is no longer available.", "errors": {"time": ["This time slot is no longer available."]}}` |
| 422 | not one of the offered times / day off / past / more than 4 weeks ahead | `{"message": "This time is outside the doctor's working hours.", "errors": {"time": ["This time is outside the doctor's working hours."]}}` |
| 422 | doctor closed bookings / not bookable | `{"message": "This doctor is not accepting bookings at the moment.", "errors": {"doctor_id": ["This doctor is not accepting bookings at the moment."]}}` |

Objects: [PatientReservationResource](#patientreservationresource)

---

#### 10.2.10 Upcoming Reservations

`GET /api/v2/patient/reservations/upcoming`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** "Upcoming" tab: pending and confirmed appointments that have not started yet, soonest first (cancelled ones are not here). Each item: display_status, status_label (badge), place, doctor, service, can_cancel, can_reschedule

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<PatientReservationResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

_Note: Pending and confirmed appointments that have not started yet, soonest first. Cancelled ones are in reservations/cancelled._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta), [PatientReservationResource](#patientreservationresource)

---

#### 10.2.11 Past Reservations

`GET /api/v2/patient/reservations/past`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** "Past" tab: appointments whose time has passed, latest first, without cancelled ones. display_status completed (confirmed) or expired (never confirmed); can_rate = show "add rating"

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<PatientReservationResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

_Note: Appointments whose time has passed, latest first, each with its real status: completed, no_show, or still pending / confirmed when the doctor did not mark it. can_rate is true for a completed visit while the doctor is not rated yet._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta), [PatientReservationResource](#patientreservationresource)

---

#### 10.2.12 Cancel Reservation

`POST /api/v2/patient/reservations/cancel-reservation`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `id` | integer | required | reservation id of this patient |
| `reason` | string | optional | a key of general.cancellation_reasons: schedule_conflict, feeling_better, found_earlier, other |
| `note` | string | optional | max:255 |

**Notes:** 404 if not own; pending or confirmed, until 4 hours before the appointment (config booking.change_hours_before); otherwise 422 errors.id

**Request example**

```json
{
  "id": "{{reservation_id}}",
  "reason": "schedule_conflict",
  "note": null
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<PatientReservationResource>> with display_status cancelled and cancellation <<ReservationCancellation>>",
  "message": "status changed successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | reason not in general.cancellation_reasons | `{"message": "القيمة المحددة ( reason ) غير موجودة", "errors": {"reason": ["القيمة المحددة ( reason ) غير موجودة"]}}` |
| 422 | less than 4 hours before the appointment (config booking.change_hours_before) | `{"message": "يمكن إلغاء الموعد أو تعديله حتى 4 ساعات قبل موعده فقط.", "errors": {"id": ["يمكن إلغاء الموعد أو تعديله حتى 4 ساعات قبل موعده فقط."]}}` |
| 422 | already cancelled | `{"message": "لم يعد هذا الموعد متاحاً للتعديل.", "errors": {"id": ["لم يعد هذا الموعد متاحاً للتعديل."]}}` |
| 404 | unknown id or another patient's appointment | `{"success": false, "message": "reservation not found"}` |
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |

Objects: [PatientReservationResource](#patientreservationresource), [ReservationCancellation](#reservationcancellation)

---

#### 10.2.13 Cancelled Reservations

`GET /api/v2/patient/reservations/cancelled`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** "Cancelled" tab, latest date first; each item has cancellation {reason, label, note}

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<PatientReservationResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

_Note: Cancelled by the patient or the doctor, latest date first; cancellation holds the reason the patient picked._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta), [PatientReservationResource](#patientreservationresource)

---

#### 10.2.14 Booking Preview (review step)

`POST /api/v2/patient/booking/preview`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `doctor_id` | int | required |  |
| `medical_center_id` | int | optional; null = doctor's clinic |  |
| `date` | Y-m-d | required |  |
| `time` | string | required | "h:i A" |
| `day_of_week` | string | optional | taken from the date |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `Review step: checks the slot and returns the summary (doctor, service, date_label, time_label, place + branch, patient_name, amount, payment_method) without booking` |  |  |  |

**Request example — Booking Preview (review step)**

```json
{
  "doctor_id": "{{doctor_id}}",
  "medical_center_id": "{{medical_center_id}}",
  "date": "2026-11-05",
  "time": "04:30 PM"
}
```

**Request example — Booking Preview (clinic)**

```json
{
  "doctor_id": "{{doctor_id}}",
  "medical_center_id": null,
  "date": "2026-11-05",
  "time": "04:30 PM"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<PatientReservationResource>> without id and booking_number",
  "message": ""
}
```

_Note: Nothing is booked. Same checks as POST reservations._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | slot taken meanwhile | `{"message": "This time slot is no longer available.", "errors": {"time": ["This time slot is no longer available."]}}` |
| 422 | not one of the offered times / day off / past / more than 4 weeks ahead | `{"message": "This time is outside the doctor's working hours.", "errors": {"time": ["This time is outside the doctor's working hours."]}}` |
| 422 | doctor closed bookings / not bookable | `{"message": "This doctor is not accepting bookings at the moment.", "errors": {"doctor_id": ["This doctor is not accepting bookings at the moment."]}}` |

Objects: [PatientReservationResource](#patientreservationresource)

---

#### 10.2.15 Reservation Details

`GET /api/v2/patient/reservations/{reservation}`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Path parameters:** `reservation`

**Notes:** Confirmation / details screen of one own appointment: booking_number, labels, place, can_cancel, can_reschedule, change_deadline

**Success response — 200**

```json
{
  "success": true,
  "data": "<<PatientReservationResource>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | unknown id or another patient's appointment | `{"success": false, "message": "reservation not found"}` |
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |

Objects: [PatientReservationResource](#patientreservationresource)

---

#### 10.2.16 Reschedule Reservation

`POST /api/v2/patient/reservations/{reservation}/reschedule`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |

**Path parameters:** `reservation`

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `date` | Y-m-d | required |  |
| `time` | string | required | "h:i A", a free time from booking/slots |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `Moves the appointment (same doctor and place) until 4 hours before it; it goes back to pending and the doctor is notified` |  |  |  |

**Request example**

```json
{
  "date": "2026-11-07",
  "time": "09:30 AM"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<PatientReservationResource>>",
  "message": "reservation rescheduled successfully"
}
```

_Note: Same doctor and place. The appointment goes back to pending and the doctor is notified._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | slot taken meanwhile | `{"message": "This time slot is no longer available.", "errors": {"time": ["This time slot is no longer available."]}}` |
| 422 | not one of the offered times / day off / past / more than 4 weeks ahead | `{"message": "This time is outside the doctor's working hours.", "errors": {"time": ["This time is outside the doctor's working hours."]}}` |
| 422 | doctor closed bookings / not bookable | `{"message": "This doctor is not accepting bookings at the moment.", "errors": {"doctor_id": ["This doctor is not accepting bookings at the moment."]}}` |
| 422 | less than 4 hours before the appointment (config booking.change_hours_before) | `{"message": "يمكن إلغاء الموعد أو تعديله حتى 4 ساعات قبل موعده فقط.", "errors": {"date": ["يمكن إلغاء الموعد أو تعديله حتى 4 ساعات قبل موعده فقط."]}}` |
| 422 | already cancelled | `{"message": "لم يعد هذا الموعد متاحاً للتعديل.", "errors": {"date": ["لم يعد هذا الموعد متاحاً للتعديل."]}}` |
| 404 | unknown id or another patient's appointment | `{"success": false, "message": "reservation not found"}` |
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |

Objects: [PatientReservationResource](#patientreservationresource)

---

#### 10.2.17 Update Profile

`POST /api/v2/patient/update-profile`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `name` | string | optional | max:255 |
| `email` | string | optional | email, unique except self |
| `gender` |  | optional | in:male, female |
| `birth_date` | date | optional | Y-m-d, before today |
| `city_id` | integer | optional | exists:cities, the city picked in the profile |
| `weight` | string | optional |  |
| `height` | string | optional |  |
| `phone` | string | optional | 05XXXXXXXX, unique except self; normally changed with change-phone + OTP |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `Personal info screen; send only what changed. data = PatientResource` | with full_phone |  | birth_date, city |

**Request example**

```json
{
  "name": "سارة أحمد",
  "email": "sara@example.com",
  "gender": "female",
  "birth_date": "1995-03-15",
  "city_id": "{{city_id}}"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<PatientResource>>",
  "message": "patient updated successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | name/phone missing, phone format or taken, email taken | `{"message": "رقم الهاتف يجب ان يبدأ ب 05 متبوعاً ب 8 ارقام ", "errors": {"phone": ["رقم الهاتف يجب ان يبدأ ب 05 متبوعاً ب 8 ارقام "]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PatientResource](#patientresource)

---

#### 10.2.18 Rate App

`POST /api/v2/patient/app-ratings`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `rate` | integer | required | min:1, no max |
| `comment` | string | optional |  |

**Notes:** AppRatingController __invoke

**Request example**

```json
{
  "rate": 5,
  "comment": "Great app"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "rate saved successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | rate missing / not integer >= 1 | `{"message": "يجب عليك تحديد التقيم", "errors": {"rate": ["يجب عليك تحديد التقيم"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.2.19 Profile

`GET /api/v2/patient/profile`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Notes:** returns PatientResource directly ({data:{...}}, no success/message keys)

**Success response — 200**

```json
{
  "data": "<<PatientResource>>"
}
```

_Note: bare JsonResource, no success/message_

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PatientResource](#patientresource)

---

#### 10.2.20 Toggle Notifications

`POST /api/v2/patient/toggle-notifications`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `allow_notifications` |  | required | in:0, 1 |

**Notes:** registered twice; the later definition wins -> NotificationController@toggleNotificationsStatus (same field as PatientController@toggleNotifications)

**Request example**

```json
{
  "allow_notifications": 1
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "notifications updated successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | allow_notifications missing or not 0/1 | `{"message": "حقل ( allow notifications ) مطلوب", "errors": {"allow_notifications": ["حقل ( allow notifications ) مطلوب"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.2.21 Add Doctor to Favorites

`POST /api/v2/patient/add-doctor-to-favorite/{doctor}`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Path parameters:** `doctor`

**Notes:** path {doctor}=doctor id; no duplicate check

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "doctor added to favorite successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no Doctor with that id | `{"message": "No query results for model [App\\Models\\Doctor] 999"}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.2.22 Remove Doctor from Favorites

`POST /api/v2/patient/remove-doctor-from-favorite/{doctor}`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Path parameters:** `doctor`

**Notes:** path {doctor}=doctor id

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "doctor removed from favorite successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no Doctor with that id | `{"message": "No query results for model [App\\Models\\Doctor] 999"}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.2.23 Add Offer to Favorites

`POST /api/v2/patient/add-offer-to-favorite/{offer}`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Path parameters:** `offer`

**Notes:** path {offer}=offer id; no duplicate check

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "offer added to favorite successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no Offer with that id | `{"message": "No query results for model [App\\Models\\Offer] 999"}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.2.24 Remove Offer from Favorites

`POST /api/v2/patient/remove-offer-from-favorite/{offer}`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Path parameters:** `offer`

**Notes:** path {offer}=offer id

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "offer removed from favorite successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no Offer with that id | `{"message": "No query results for model [App\\Models\\Offer] 999"}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.2.25 Add Medical Center to Favorites

`POST /api/v2/patient/add-medical-center-to-favorite/{medical_center}`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Path parameters:** `medical_center`

**Notes:** The heart on the medical center screen. Saving twice keeps one favorite. A clinic is saved with add-doctor-to-favorite/{doctor}

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "medical center added to favorite successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |
| 404 | unknown medical center | `{"message": "No query results for model [App\\Models\\MedicalCenter] 99"}` |

---

#### 10.2.26 Remove Medical Center from Favorites

`POST /api/v2/patient/remove-medical-center-from-favorite/{medical_center}`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Path parameters:** `medical_center`

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `- \|` |  |  |  |

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "medical center removed from favorite successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |
| 404 | unknown medical center | `{"message": "No query results for model [App\\Models\\MedicalCenter] 99"}` |

---

#### 10.2.27 Favorites List

`GET /api/v2/patient/favorites`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `type(string,optional, doctor` |  |  |  |

**Notes:** offer | medical_center; "favourite centers" screen = medical_center) | returns FavoriteResource collection directly ({data:[{type, item}]}, no envelope, not paginated)

**Success response — 200**

```json
{
  "data": [
    "<<FavoriteResource>>",
    {
      "type": "offer",
      "item": "<<PatientOfferResource>>"
    }
  ]
}
```

_Note: bare collection, not paginated, no success/message type is doctor, offer or medical_center; a medical_center item is a MedicalCenterCardResource (null once no visible doctor works there)._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [FavoriteResource](#favoriteresource), [PatientOfferResource](#patientofferresource)

---

#### 10.2.28 Notifications

`GET /api/v2/patient/notifications`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** NotificationResource paginated collection, no success/message envelope (data, links, meta)

**Success response — 200**

```json
{
  "data": [
    "<<NotificationResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>"
}
```

_Note: No success/message envelope. group = today / this_week / earlier (the headings). type: reservation_reminder, reservation_received, reservation_confirmed, reservation_cancel, new_offer, rate_visit, general. target tells what to open: reservation_id, offer_id, doctor_id._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |

Objects: [NotificationResource](#notificationresource), [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta)

---

#### 10.2.29 Unread Notifications

`GET /api/v2/patient/unread-notifications`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** same shape as notifications

**Success response — 200**

```json
{
  "data": [
    "<<NotificationResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [NotificationResource](#notificationresource), [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta)

---

#### 10.2.30 Mark Notification as Read

`POST /api/v2/patient/notifications/{id}/mark-as-read`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Path parameters:** `id`

**Notes:** path {id}=notification UUID; 404 failure if not own

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "Notification has been read successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | notification id not found or not the caller's | `{"success": false, "message": "notification not found"}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.2.31 Mark All Notifications as Read

`POST /api/v2/patient/notifications/mark-all-as-read`

| | |
|---|---|
| **Authorization** | Bearer token — patient (`Authorization: Bearer {{patient_token}}`) |
| **Content-Type** | — |

**Notes:** "Mark all as read" on the notifications screen

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "Notifications have been read successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid patient token | `{"error": "Unauthenticated."}` |

---

### 10.3 Doctor App — Public

#### 10.3.1 Send OTP

`POST /api/v2/doctor/send-otp`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | `application/json` |
| **Extra rate limit** | OTP send limit (`throttle:otp-send`) |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `phone` | string | required | Saudi mobile; 5XXXXXXXX / 05XXXXXXXX / +9665XXXXXXXX, with spaces; must be a phone the administration added |

**Notes:** Step 1 of doctor sign in (no password). Sends a 4-digit SMS code valid 5 minutes; a new request replaces the previous code. Also used for Resend code. throttle:otp-send (3 per phone / 20 per IP every 10 minutes)

**Request example**

```json
{
  "phone": "{{doctor_phone}}"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "phone": "0550002468",
    "full_phone": "+966550002468",
    "resend_after": 45,
    "expires_in": 300
  },
  "message": "otp sent successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | phone not added by the administration | `{"message": "هذا الرقم غير مسجل كطبيب. تواصل مع الإدارة لتفعيل حسابك.", "errors": {"phone": ["هذا الرقم غير مسجل كطبيب. تواصل مع الإدارة لتفعيل حسابك."]}}` |
| 422 | phone missing or not a Saudi mobile | `{"message": "رقم الهاتف يجب ان يبدأ ب 05 متبوعاً ب 8 ارقام ", "errors": {"phone": ["رقم الهاتف يجب ان يبدأ ب 05 متبوعاً ب 8 ارقام "]}}` |
| 429 | OTP limit reached (3 per phone / 20 per IP in 10 minutes) | `{"message": "Too Many Attempts."}` |

---

#### 10.3.2 Verify OTP (Sign In)

`POST /api/v2/doctor/check-otp`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | `application/json` |
| **Extra rate limit** | OTP verify limit (`throttle:otp-verify`) |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `phone` | string | required | same formats as send-otp |
| `otp` | string | required | 4-digit code from the SMS or fixed 1995 |
| `fcm_token` | string | optional | max:255 |

**Notes:** Step 2. Returns token, doctor, account_completed and name_locked. The code works once. The first sign-in starts the free trial. The phone may also be sent in the URL: POST /api/v2/doctor/check-otp/{phone}. throttle:otp-verify (5 per phone / 30 per IP every 10 minutes); a refused code answers 422 with reason (wrong / expired) and attempts_left

**Request example**

```json
{
  "phone": "{{doctor_phone}}",
  "otp": "{{otp}}",
  "fcm_token": "{{fcm_token}}"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "account_completed": false,
    "name_locked": true,
    "doctor": "<<DoctorResource>>",
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
  },
  "message": "logged in successfully"
}
```

_Note: account_completed false = show "complete your account". name_locked true = the administration entered the name: show it read-only. The first sign-in starts the 14-day free trial._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | wrong code; attempts_left = tries before 429 | `{"message": "الرمز غير صحيح. تبقت لديك محاولتان.", "errors": {"otp": ["الرمز غير صحيح. تبقت لديك محاولتان."]}, "reason": "wrong", "attempts_left": 2}` |
| 422 | code expired (5 minutes) or already used | `{"message": "انتهت صلاحية الرمز. اطلب رمزاً جديداً.", "errors": {"otp": ["انتهت صلاحية الرمز. اطلب رمزاً جديداً."]}, "reason": "expired", "attempts_left": 4}` |
| 429 | OTP limit reached (5 per phone / 30 per IP in 10 minutes) | `{"message": "Too Many Attempts."}` |

Objects: [DoctorResource](#doctorresource)

---

#### 10.3.3 General Data

`GET /api/v2/doctor/general`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Notes:** data.application_subscription_status (always true), data.titles, data.cities (only cities with areas), data.main_specializations, data.whatsapp_number (international format)

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "application_subscription_status": true,
    "titles": [
      "<<TitleResource>>"
    ],
    "cities": [
      "<<CityResource>>"
    ],
    "main_specializations": [
      "<<SpecializationResource>>"
    ],
    "whatsapp_number": "+966512345678"
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [CityResource](#cityresource), [SpecializationResource](#specializationresource), [TitleResource](#titleresource)

---

#### 10.3.4 Medical Centers

`GET /api/v2/doctor/medical-centers`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `search` | string | optional | LIKE on name_{locale} |

**Notes:** data = all medical centers (not paginated)

**Success response — 200**

```json
{
  "success": true,
  "data": [
    {
      "id": 2,
      "logo": "{APP_URL}/storage/Images/MedicalCenters/center.png",
      "name": "مجمع النخبة الطبي",
      "description": "مجمع طبي متكامل"
    }
  ],
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.3.5 Terms of Service

`GET /api/v2/doctor/terms-of-service`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Notes:** data.terms

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "terms": "<p>الشروط والأحكام...</p>"
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.3.6 Privacy Policy

`GET /api/v2/doctor/privacy-policy`

| | |
|---|---|
| **Authorization** | None (public) |
| **Content-Type** | — |

**Notes:** data.privacy

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "privacy": "<p>سياسة الخصوصية...</p>"
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

### 10.4 Doctor App — Authenticated (auth:doctor)

#### 10.4.1 Complete Account

`POST /api/v2/doctor/complete-account`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `name` | string | required when no name is on file | max:255; ignored when name_locked |
| `email` | string | required | email, unique among doctors |
| `accepted` |  | required | must be true: the terms and privacy policy |

**Notes:** "Complete your account" screen, shown while account_completed is false

**Request example**

```json
{
  "name": "د. فهد العتيبي",
  "email": "fahad.alotaibi@example.com",
  "accepted": true
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "account_completed": true,
    "name_locked": true,
    "doctor": "<<DoctorResource>>"
  },
  "message": "account completed successfully"
}
```

_Note: A name already on file is kept and anything sent instead is ignored. The first completion tells the admins; the doctor stays pending until an admin reviews them._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | name missing (only when none is on file) | `{"message": "الاسم بالكامل مطلوب", "errors": {"name": ["الاسم بالكامل مطلوب"]}}` |
| 422 | email missing | `{"message": "البريد الإلكتروني مطلوب", "errors": {"email": ["البريد الإلكتروني مطلوب"]}}` |
| 422 | invalid email | `{"message": "صيغة البريد الإلكتروني غير صحيحة. مثال: name@example.com", "errors": {"email": ["صيغة البريد الإلكتروني غير صحيحة. مثال: name@example.com"]}}` |
| 422 | terms not accepted | `{"message": "يجب الموافقة على شروط الخدمة وسياسة الخصوصية", "errors": {"accepted": ["يجب الموافقة على شروط الخدمة وسياسة الخصوصية"]}}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorResource](#doctorresource)

---

#### 10.4.2 Current Doctor Medical Centers

`GET /api/v2/doctor/current`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** closure; returns DoctorMedicalsResource collection of the doctor's medical centers ({data:[...]}, no envelope)

**Success response — 200**

```json
{
  "data": [
    "<<DoctorMedicalsResource>>"
  ]
}
```

_Note: bare collection of the doctor's medical centers, no envelope_

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorMedicalsResource](#doctormedicalsresource)

---

#### 10.4.3 Resend OTP

`POST /api/v2/doctor/resend-otp`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |
| **Extra rate limit** | OTP send limit (`throttle:otp-send`) |

**Notes:** throttle:otp-send

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "otp sent successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | throttle:otp-send (3 per account / 20 per IP per 10 min) or api 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.4.4 Change Phone

`POST /api/v2/doctor/change-phone`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |
| **Extra rate limit** | OTP send limit (`throttle:otp-send`) |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `phone` | string | required | 05XXXXXXXX, max:255, unique:doctors except self |

**Notes:** throttle:otp-send

**Request example**

```json
{
  "phone": "0500000003"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "phone updated and otp sent successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | phone format invalid or taken | `{"message": "قيمة ( الهاتف ) مُستخدمة من قبل", "errors": {"phone": ["قيمة ( الهاتف ) مُستخدمة من قبل"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | throttle:otp-send (3 per account / 20 per IP per 10 min) or api 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.4.5 Verify Phone

`POST /api/v2/doctor/verify`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |
| **Extra rate limit** | OTP verify limit (`throttle:otp-verify`) |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `otp` | string | required in practice - no rule; stored OTP or 1995 |  |

**Notes:** throttle:otp-verify; wrong -> 422 errors.otp; data = DoctorResource (message text is a copy/paste "phone updated and otp sent successfully")

**Request example**

```json
{
  "otp": "{{otp}}"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorResource>>",
  "message": "phone updated and otp sent successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | otp not the stored code nor 1995 | `{"message": "wrong code", "errors": {"otp": ["wrong code"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | throttle:otp-verify (5 per account / 30 per IP per 10 min) or api 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorResource](#doctorresource)

---

#### 10.4.6 Logout

`POST /api/v2/doctor/logout`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** revokes token

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "You have been successfully logged out!"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.4.7 Sub Specializations

`GET /api/v2/doctor/main-specializations/{specialization}/sub-specializations`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Path parameters:** `specialization`

**Notes:** data.sub_specializations

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "sub_specializations": [
      "<<SpecializationResource>>"
    ]
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no Specialization with that id | `{"message": "No query results for model [App\\Models\\Specialization] 999"}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [SpecializationResource](#specializationresource)

---

#### 10.4.8 City Areas

`GET /api/v2/doctor/cities/{city}/areas`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Path parameters:** `city`

**Notes:** data = areas

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<AreaResource>>"
  ],
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no City with that id | `{"message": "No query results for model [App\\Models\\City] 999"}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [AreaResource](#arearesource)

---

#### 10.4.9 Home

`GET /api/v2/doctor/home`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** Home screen: doctor, unread_notifications_count, today_appointments {count, earnings, date_label, reservations}, center_queues, recent_ratings, news

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "doctor": {
      "id": 1,
      "name": "د. فهد العتيبي",
      "image": "{APP_URL}/storage/Images/Doctors/doctor.png"
    },
    "unread_notifications_count": 2,
    "news": [
      "<<NewsletterResource>>"
    ],
    "recent_ratings": [
      "<<RatingResource>>"
    ],
    "today_appointments": {
      "total_amount": "1,500",
      "earnings": "500",
      "count": 10,
      "date": "الخميس 29 أكتوبر, 2026",
      "date_label": "الخميس، 29 أكتوبر 2026",
      "reservations": [
        "<<ReservationResource>>"
      ]
    },
    "center_queues": [
      "<<CenterQueue>>"
    ]
  },
  "message": ""
}
```

_Note: earnings = amounts of today's completed visits. count skips cancelled and no_show. reservations are in time order, all statuses. center_queues has one entry per medical center with visits today; next is null when nobody is waiting._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [CenterQueue](#centerqueue), [NewsletterResource](#newsletterresource), [RatingResource](#ratingresource), [ReservationResource](#reservationresource)

---

#### 10.4.10 Ratings

`GET /api/v2/doctor/ratings`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** Patient reviews, newest first; paginated, no envelope; summary {average, count}

**Success response — 200**

```json
{
  "data": [
    "<<RatingResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "summary": {
    "average": 4.8,
    "count": 32
  }
}
```

_Note: No success/message envelope. summary is the card at the top of the screen; average is null with no ratings._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta), [RatingResource](#ratingresource)

---

#### 10.4.11 Today

`GET /api/v2/doctor/reservations/today`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `medical_center_id` | integer | optional | the place chip; 0 = own clinic |

**Notes:** "Today" tab: groups by place [{date, title, count, reservations}], time order

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<DoctorDayGroup>>"
  ],
  "message": ""
}
```

_Note: Grouped by place: title is the place name._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorDayGroup](#doctordaygroup)

---

#### 10.4.12 Upcoming

`GET /api/v2/doctor/reservations/upcoming`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `medical_center_id` | integer | optional | the place chip; 0 = own clinic |

**Notes:** "Upcoming" tab: from tomorrow, groups by date

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<DoctorDayGroup>>"
  ],
  "message": ""
}
```

_Note: From tomorrow, soonest first, grouped by date: title is the date ("السبت 31 أكتوبر")._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorDayGroup](#doctordaygroup)

---

#### 10.4.13 Past

`GET /api/v2/doctor/reservations/past`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `medical_center_id` | integer | optional | the place chip; 0 = own clinic |

**Notes:** "Past" tab: before today, latest date first, groups by date

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<DoctorDayGroup>>"
  ],
  "message": ""
}
```

_Note: Before today, latest date first, grouped by date._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorDayGroup](#doctordaygroup)

---

#### 10.4.14 Appointment Details

`GET /api/v2/doctor/reservations/{reservation}`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Path parameters:** `reservation`

**Notes:** Appointment details screen: patient, date, time or turn, place, how it was booked, price, patient note

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorReservationDetailsResource>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | unknown id or another doctor's appointment | `{"success": false, "message": "reservation not found"}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorReservationDetailsResource](#doctorreservationdetailsresource)

---

#### 10.4.15 Booking Days (manual booking)

`GET /api/v2/doctor/booking/days`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `medical_center_id` | integer | optional; empty or 0 = own clinic |  |

**Notes:** Manual booking, workplace & date: 28 days with status available / full / closed

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "days": [
      "<<BookingDay>>"
    ]
  },
  "message": ""
}
```

_Note: Not affected by the online booking switch._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [BookingDay](#bookingday)

---

#### 10.4.16 Booking Slots (manual booking)

`GET /api/v2/doctor/booking/slots`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `date` | Y-m-d | required |  |
| `medical_center_id` | integer | optional; empty or 0 = own clinic |  |

**Notes:** Fixed-time place: morning / evening times. First-come place: next_queue_number, queue_label, starts_label

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "reservation_type": "specified_time",
    "duration_minutes": 20,
    "date": "2026-11-03",
    "morning": [
      "<<BookingSlot>>"
    ],
    "evening": [
      "<<BookingSlot>>"
    ]
  },
  "message": ""
}
```

**Alternative success response**

```json
{
  "success": true,
  "data": {
    "reservation_type": "advance",
    "date": "2026-11-03",
    "next_queue_number": 5,
    "queue_label": "دور 5",
    "starts_label": "4:00 م"
  },
  "message": ""
}
```

_Note: The alternative example is a first-come place: show the turn instead of times._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [BookingSlot](#bookingslot)

---

#### 10.4.17 My Workplaces

`GET /api/v2/doctor/workplaces`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** "My workplaces": the own clinic (id 0) and the medical centers, with system, duration and price

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<Workplace>>"
  ],
  "message": ""
}
```

_Note: id 0 is the own clinic. An empty list is the "no workplaces" screen._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [Workplace](#workplace)

---

#### 10.4.18 Workplace Details

`GET /api/v2/doctor/workplaces/{place}`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Path parameters:** `place`

**Notes:** Workplace details; {place} = 0 for the own clinic or a medical center id. Address and phone are managed by the administration

**Success response — 200**

```json
{
  "success": true,
  "data": "<<WorkplaceDetails>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | not one of the doctor's places | `{"message": "The doctor does not work at this place."}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [WorkplaceDetails](#workplacedetails)

---

#### 10.4.19 Booking Settings

`POST /api/v2/doctor/workplaces/{place}/settings`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Path parameters:** `place`

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `reservation_type` | string | required | in:specified_time, advance |
| `examination_duration` | integer | required for specified_time | in:10, 15, 20, 30 |
| `examination_price` | numeric | required | 0..999999 |

**Notes:** Booking settings of this place only

**Request example**

```json
{
  "reservation_type": "specified_time",
  "examination_duration": 20,
  "examination_price": 250
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<WorkplaceDetails>>",
  "message": ""
}
```

_Note: Existing bookings keep their system, time and price._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | duration not 10, 15, 20 or 30 | `{"message": "The selected examination duration is invalid.", "errors": {"examination_duration": ["The selected examination duration is invalid."]}}` |
| 404 | not one of the doctor's places | `{"message": "The doctor does not work at this place."}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [WorkplaceDetails](#workplacedetails)

---

#### 10.4.20 Weekly Schedule

`GET /api/v2/doctor/workplaces/{place}/schedule`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Path parameters:** `place`

**Notes:** The week of this place: days with is_available and up to two periods

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "days": [
      "<<ScheduleDay>>"
    ]
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | not one of the doctor's places | `{"message": "The doctor does not work at this place."}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [ScheduleDay](#scheduleday)

---

#### 10.4.21 Save Weekly Schedule

`POST /api/v2/doctor/workplaces/{place}/schedule`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Path parameters:** `place`

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `days` | array | required |  |
| `days.*.day` | string | required |  |
| `days.*.is_available` | boolean | required |  |
| `days.*.periods` | array |  | max 2 |
| `days.*.periods.*.start_time` | H:i | required |  |
| `days.*.periods.*.end_time` | H:i | required |  |
| `confirm_affected` | boolean | optional | save although confirmed appointments fall outside the new hours |

**Notes:** Saves the week; the gap between the two periods is the break

**Request example**

```json
{
  "days": [
    {
      "day": "saturday",
      "is_available": true,
      "periods": [
        {
          "start_time": "09:00",
          "end_time": "13:00"
        },
        {
          "start_time": "16:00",
          "end_time": "21:00"
        }
      ]
    },
    {
      "day": "sunday",
      "is_available": true,
      "periods": [
        {
          "start_time": "09:00",
          "end_time": "13:00"
        },
        {
          "start_time": "16:00",
          "end_time": "21:00"
        }
      ]
    },
    {
      "day": "monday",
      "is_available": true,
      "periods": [
        {
          "start_time": "09:00",
          "end_time": "13:00"
        },
        {
          "start_time": "16:00",
          "end_time": "21:00"
        }
      ]
    },
    {
      "day": "tuesday",
      "is_available": true,
      "periods": [
        {
          "start_time": "09:00",
          "end_time": "13:00"
        },
        {
          "start_time": "16:00",
          "end_time": "21:00"
        }
      ]
    },
    {
      "day": "wednesday",
      "is_available": true,
      "periods": [
        {
          "start_time": "09:00",
          "end_time": "13:00"
        },
        {
          "start_time": "16:00",
          "end_time": "21:00"
        }
      ]
    },
    {
      "day": "thursday",
      "is_available": true,
      "periods": [
        {
          "start_time": "09:00",
          "end_time": "13:00"
        },
        {
          "start_time": "16:00",
          "end_time": "21:00"
        }
      ]
    },
    {
      "day": "friday",
      "is_available": false,
      "periods": []
    }
  ],
  "confirm_affected": false
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "days": [
      "<<ScheduleDay>>"
    ]
  },
  "message": ""
}
```

_Note: A 409 means nothing was saved: show the warning, then send the same body with confirm_affected true. The appointments stay as they are._

**Error responses**

| Status | When | Body |
|---|---|---|
| 409 | confirmed appointments fall outside the new hours | `{"success": false, "message": "التغيير يؤثر على مواعيد مؤكدة", "affected_count": 1, "affected": [{"id": 2044, "booking_number": "DR-02044", "date_label": "السبت، 31 أكتوبر 2026", "time_label": "2:00 م", "patient_name": "سارة"}]}` |
| 422 | a period ends before it starts, the periods overlap, more than two periods, or a working day has none | `{"message": "وقت النهاية يجب أن يكون بعد وقت البداية", "errors": {"days.1.periods.0.end_time": ["وقت النهاية يجب أن يكون بعد وقت البداية"]}}` |
| 404 | not one of the doctor's places | `{"message": "The doctor does not work at this place."}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [ScheduleDay](#scheduleday)

---

#### 10.4.22 Today's Queue

`GET /api/v2/doctor/queue`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `medical_center_id` | integer | optional; empty or 0 = own clinic |  |

**Notes:** Today's queue at a first-come place

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorQueue>>",
  "message": ""
}
```

_Note: Today's turns in order. total_count skips cancelled turns._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorQueue](#doctorqueue)

---

#### 10.4.23 Call Next

`POST /api/v2/doctor/queue/call-next`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `medical_center_id` | integer | optional; empty or 0 = own clinic |  |

**Notes:** The "next" button: calls the first turn not called yet

**Request example**

```json
{
  "medical_center_id": "{{medical_center_id}}"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorQueue>>",
  "message": "تم استدعاء هيا السبيعي (دور 2)"
}
```

_Note: Calls the first turn not called yet. The status does not change. The patient gets "جه دورك". message is the toast text._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | nobody is waiting | `{"message": "لا يوجد مرضى بالانتظار", "errors": {"queue": ["لا يوجد مرضى بالانتظار"]}}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorQueue](#doctorqueue)

---

#### 10.4.24 Test (debug)

`GET /api/v2/doctor/reservations/test`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** past reservations as paginated ReservationResource collection, no envelope (test/debug endpoint)

**Success response — 200**

```json
{
  "data": [
    "<<ReservationResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta), [ReservationResource](#reservationresource)

---

#### 10.4.25 Manual Booking

`POST /api/v2/doctor/reservations`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `name` | string | required |  |
| `phone` | string | required | 5XXXXXXXX or 05XXXXXXXX |
| `medical_center_id` | int | optional; empty or 0 = own clinic |  |
| `date` | string | required | Y-m-d |
| `time` | string |  | "h:i A"; required at a fixed-time place, left out at a first-come place |
| `day_of_week` | string | optional | taken from the date |

**Notes:** Manual booking: confirmed at once

**Request example**

```json
{
  "name": "فيصل القرني",
  "phone": "553007788",
  "medical_center_id": null,
  "date": "2026-11-05",
  "time": "09:40 AM"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorReservationDetailsResource>>",
  "message": "reservation created successfully"
}
```

_Note: Confirmed at once, source manual. At a first-come place leave time out: the booking gets queue_number. An existing patient keeps their name._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | slot taken meanwhile | `{"message": "حُجز موعد 9:40 ص قبل لحظات. اختر وقتاً آخر.", "errors": {"time": ["حُجز موعد 9:40 ص قبل لحظات. اختر وقتاً آخر."]}}` |
| 422 | name missing | `{"message": "الاسم بالكامل مطلوب", "errors": {"name": ["الاسم بالكامل مطلوب"]}}` |
| 422 | phone missing or invalid | `{"message": "رقم الموبايل غير صحيح. يجب أن يتكوّن من ٩ أرقام ويبدأ بالرقم ٥", "errors": {"phone": ["رقم الموبايل غير صحيح. يجب أن يتكوّن من ٩ أرقام ويبدأ بالرقم ٥"]}}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorReservationDetailsResource](#doctorreservationdetailsresource)

---

#### 10.4.26 Doctor Places

`GET /api/v2/doctor/doctor-places`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** data = places list (own clinic id 0 and/or attached medical centers)

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<DoctorPlace>>"
  ],
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorPlace](#doctorplace)

---

#### 10.4.27 Change Reservation Status

`POST /api/v2/doctor/reservations/change-status`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `id` | integer | required | own reservation id |
| `status` | string | required | in:confirmed, cancelled, completed, no_show; completed / no_show only once the appointment started |

**Notes:** The "..." menu. No status is final. 404 if not own; the patient is notified of confirmed / cancelled

**Request example**

```json
{
  "id": "{{reservation_id}}",
  "status": "confirmed"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<ReservationResource>>",
  "message": "status changed successfully"
}
```

_Note: status: confirmed, cancelled, completed (the patient came) or no_show (the patient did not come). No status is final: the doctor can change any of them. completed / no_show only once the appointment started. Bringing back a cancelled fixed-time appointment needs its slot to be free. The patient is notified of confirmed and cancelled._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | completed / no_show before the appointment started | `{"message": "لا يمكن تحديد حضور المريض قبل موعد الكشف.", "errors": {"status": ["لا يمكن تحديد حضور المريض قبل موعد الكشف."]}}` |
| 404 | reservation not found or not this doctor's | `{"success": false, "message": "reservation not found"}` |
| 422 | status not confirmed/cancelled / id missing | `{"message": " اختيارك ل status غير صحيح.", "errors": {"status": [" اختيارك ل status غير صحيح."]}}` |
| 422 | confirming a cancelled reservation whose slot is now taken (SlotBooking::changeStatus) | `{"message": "This time slot is no longer available.", "errors": {"status": ["This time slot is no longer available."]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [ReservationResource](#reservationresource)

---

#### 10.4.28 Change Booking Status

`POST /api/v2/doctor/change-booking-status`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `is_booking_available` | boolean | required |  |

**Notes:** data = DoctorResource

**Request example**

```json
{
  "is_booking_available": true
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorResource>>",
  "message": "status changed successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | is_booking_available missing / not boolean | `{"message": "حقل ( is booking available ) مطلوب", "errors": {"is_booking_available": ["حقل ( is booking available ) مطلوب"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorResource](#doctorresource)

---

#### 10.4.29 Complete Profile (steps 0–2)

`POST /api/v2/doctor/complete-information/{step?}`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `multipart/form-data` |

**Path parameters:** `step`

**Body fields — step 0**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `image` | file | required | mimes:jpeg, jpg, png, gif, svg, max 4096KB |
| `name` | string | required | max:255 |
| `bio` | string | required | max:255 |
| `title_id` | int | required | exists:titles |
| `main_specialization_id` | integer | required | exists:specializations |
| `specializations[]` | array | required | min:1; items integer exists:specializations |
| `gender` |  | required | in:male, female |
| `ad_id` | int | optional | exists:ads - not saved |
| `phone` | string | required | 05XXXXXXXX, unique:doctors except self |
| `email` | string | required | email:rfc, dns, unique except self |
| `examination_price` | numeric | required | max:999999 |
| `examination_duration` | numeric | required | min:15 - minutes |
| `experience_years` | integer | optional | 0..70 |

**Body fields — step 1**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `work_for` |  | required | in:clinic, medical_center, both |
| `medical_centers[]` | array | required_if work_for=medical_center\|both; items exists:medical_centers |  |
| `clinic_images[]` | array of image files | required_if work_for=clinic\|both | 1..10 files, each image mimes:jpeg, jpg, png, gif, svg max 4096KB |
| `clinic_name` | string | required_if clinic\|both | max:255, unique:doctors |
| `clinic_phone` | string | required_if clinic\|both | 05XXXXXXXX, unique:doctors.clinic_phone |
| `clinic_info` | string | required_if clinic\|both | max:255 |
| `clinic_address` | string | required_if clinic\|both | max:255 |
| `lat` | string | required_if clinic\|both | max:255 |
| `lng` | string | required_if clinic\|both | max:255 |
| `area_id` | int | required_if clinic\|both | exists:areas |

**Body fields — step 2**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `main_specialization_id` | integer | optional | exists |
| `specializations[]` | array | optional; items integer exists |  |
| `schedules` | array | required | min:1, keyed by place id: 0 = own clinic, otherwise medical_center_id |
| `schedules.{place}` |  | required | must contain keys for all 7 days |
| `schedules.{place}.reservation_type` |  | required | in:advance, specified_time |
| `schedules.{place}.{day}.is_available` | optional; "on" or any non-0 = available |  | absent/0 = off |
| `schedules.{place}.{day}.start_time` |  | required_if is_available=on | nullable, H:i 24h |
| `schedules.{place}.{day}.end_time` |  | required_if is_available=on | nullable, H:i, after start_time |
| `schedules.{place}.{day}.break_start_time` |  | optional | H:i |
| `schedules.{place}.{day}.break_end_time` |  | optional | H:i, after break_start_time |
| `plus resend step 0/1 fields` | image |  | name, bio, title_id, gender, phone, email, examination_price, examination_duration, work_for, clinic_images[], clinic_name, clinic_phone, clinic_info, clinic_address, lat, lng, area_id) and optional deleted_images (JSON string array |
| `every place in schedules with valid reservation_type is attached (sync) \| response data = DoctorResource` |  |  |  |

**Notes:** StoreDoctorApiRequest; {step} is 0-based index 0|1|2; steps 0 and 1 only validate (response "validated successfully"); step 2 saves EVERYTHING from the request (personal + clinic fields + schedules), so the client must resend all earlier-step fields together with step 2 (but only step-2 rules are enforced on them); missing/other step value -> no rules, returns "validated successfully"

**Request example — Step 0 - Personal (validate)** (form-data)

```text
image: <file>
name: Dr. Test
bio: Consultant cardiologist
title_id: 1
main_specialization_id: 1
specializations[0]: 2
gender: male
phone: {{doctor_phone}}
email: doctor@example.com
examination_price: 200
examination_duration: 30
experience_years: 12
```

**Request example — Step 1 - Workplace (validate)** (form-data)

```text
work_for: clinic
clinic_images[0]: <file>
clinic_name: Test Clinic
clinic_phone: 0500000009
clinic_info: Clinic description
clinic_address: Riyadh
lat: 24.7136
lng: 46.6753
area_id: 1
medical_centers[0]: 
```

**Request example — Step 2 - Schedules (save all)** (form-data)

```text
image: <file>
name: Dr. Test
bio: Consultant cardiologist
title_id: 1
main_specialization_id: 1
specializations[0]: 2
gender: male
phone: {{doctor_phone}}
email: doctor@example.com
examination_price: 200
examination_duration: 30
experience_years: 12
work_for: clinic
clinic_images[0]: <file>
clinic_name: Test Clinic
clinic_phone: 0500000009
clinic_info: Clinic description
clinic_address: Riyadh
lat: 24.7136
lng: 46.6753
area_id: 1
medical_centers[0]: 
schedules[0][reservation_type]: specified_time
schedules[0][saturday][is_available]: on
schedules[0][saturday][start_time]: 09:00
schedules[0][saturday][end_time]: 17:00
schedules[0][saturday][break_start_time]: 13:00
schedules[0][saturday][break_end_time]: 14:00
schedules[0][sunday][is_available]: on
schedules[0][sunday][start_time]: 09:00
schedules[0][sunday][end_time]: 17:00
schedules[0][sunday][break_start_time]: 13:00
schedules[0][sunday][break_end_time]: 14:00
schedules[0][monday][is_available]: on
schedules[0][monday][start_time]: 09:00
schedules[0][monday][end_time]: 17:00
schedules[0][monday][break_start_time]: 13:00
schedules[0][monday][break_end_time]: 14:00
schedules[0][tuesday][is_available]: on
schedules[0][tuesday][start_time]: 09:00
schedules[0][tuesday][end_time]: 17:00
schedules[0][tuesday][break_start_time]: 13:00
schedules[0][tuesday][break_end_time]: 14:00
schedules[0][wednesday][is_available]: on
schedules[0][wednesday][start_time]: 09:00
schedules[0][wednesday][end_time]: 17:00
schedules[0][wednesday][break_start_time]: 13:00
schedules[0][wednesday][break_end_time]: 14:00
schedules[0][thursday][is_available]: on
schedules[0][thursday][start_time]: 09:00
schedules[0][thursday][end_time]: 17:00
schedules[0][thursday][break_start_time]: 13:00
schedules[0][thursday][break_end_time]: 14:00
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorResource>>",
  "message": "doctor created successfully"
}
```

**Alternative success response**

```json
{
  "success": true,
  "data": [],
  "message": "validated successfully"
}
```

_Note: steps 0 and 1 (and missing/other step) return {"success":true,"data":[],"message":"validated successfully"}; only step 2 saves and returns DoctorResource_

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | rules of the given step fail | `{"message": "حقل ( الأسم ) مطلوب (and 3 more errors)", "errors": {"name": ["حقل ( الأسم ) مطلوب"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorResource](#doctorresource)

---

#### 10.4.30 Update Personal Information

`POST /api/v2/doctor/update-personal-information`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `multipart/form-data` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `image` | file | optional | mimes:jpeg, jpg, png, gif, svg, max 4096KB |
| `name` | string | required | max:255 |
| `bio` | file |  | PDF only, max 4096KB; required only while doctor has no bio yet, else optional |
| `title_id` | int | required | exists:titles |
| `main_specialization_id` | integer | required | exists |
| `specializations[]` | array | required | min:1; items exists:specializations |
| `gender` |  | required | in:male, female |
| `ad_id` |  | optional | exists:ads - not saved |
| `password` | string | optional | min:6 |
| `password_confirmation` |  | optional | required_with:password, min:6, same:password |
| `phone` | string | required | 05XXXXXXXX, unique except self |
| `email` | string | required | email:rfc, dns, unique except self |
| `examination_price` | numeric | required | max:999999 |
| `examination_duration` | numeric | required | min:15 |
| `experience_years` | integer | optional | 0..70, shown on the patient app profile |

**Notes:** UpdateDoctorPersonalInfoApiRequest; note bio here is a PDF file whereas complete-information step 0 bio is a string

**Request example** (form-data)

```text
image: <file>
name: Dr. Test
bio: <file>
title_id: 1
main_specialization_id: 1
specializations[0]: 2
gender: male
phone: {{doctor_phone}}
email: doctor@example.com
examination_price: 200
examination_duration: 30
experience_years: 12
password: 
password_confirmation: 
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorResource>>",
  "message": "doctor information updated successfully"
}
```

_Note: experience_years (0..70, optional) is saved and returned in data.experience_years._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | required fields missing, phone/email taken, bio not PDF | `{"message": "حقل ( اللقب ) مطلوب", "errors": {"title_id": ["حقل ( اللقب ) مطلوب"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorResource](#doctorresource)

---

#### 10.4.31 Update Clinic Information

`POST /api/v2/doctor/update-clinic-information`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `multipart/form-data` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `clinic_images[]` | array of files | required only when all old images are deleted and work_for is clinic\|both and no new images | else optional; max 10; each mimes:jpeg, jpg, png, gif, svg max 4096KB |
| `deleted_images` | string | optional | JSON array of existing image file names to remove, e.g. ["a.png"] |
| `work_for` |  | optional | clinic\|medical_center\|both - not validated but saved |
| `clinic_name` | string | required | max:255, unique except self |
| `clinic_phone` | string | required | 05XXXXXXXX, unique except self |
| `clinic_info` | string | required | max:255 |
| `clinic_address` | string | optional | max:255 |
| `lat` | string | optional | max:255 |
| `lng` | string | optional | max:255 |
| `area_id` | int | required | exists:areas |

**Notes:** UpdateClinicInfoApiRequest; data = DoctorResource

**Request example** (form-data)

```text
clinic_images[0]: <file>
deleted_images: []
work_for: clinic
clinic_name: Test Clinic
clinic_phone: 0500000009
clinic_info: Clinic description
clinic_address: Riyadh
lat: 24.7136
lng: 46.6753
area_id: 1
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorResource>>",
  "message": "clinic information updated successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | clinic_name/clinic_phone/clinic_info/area_id missing or taken, images invalid | `{"message": "حقل ( الإسم ) مطلوب", "errors": {"clinic_name": ["حقل ( الإسم ) مطلوب"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorResource](#doctorresource)

---

#### 10.4.32 Update Clinic Schedules

`POST /api/v2/doctor/update-clinic-schedules`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `schedules` | object | required |  |
| `schedules.reservation_type` |  | required | in:advance, specified_time |
| `schedules.{day}.is_available` | in:0 |  | 1 |
| `schedules.{day}.start_time` |  | required_if is_available=1 | nullable, H:i |
| `schedules.{day}.end_time` |  | required_if is_available=1 | nullable, H:i, after start_time |
| `schedules.{day}.break_start_time` |  | optional | H:i |
| `schedules.{day}.break_end_time` |  | optional | H:i, after break_start |

**Notes:** {day} = all 7 days must be present (code reads every day's keys; missing day -> 500); here schedules is flat (no place key); data = clinic ScheduleResource list. reservation_type is validated but NOT saved by this endpoint

**Request example**

```json
{
  "schedules": {
    "reservation_type": "specified_time",
    "saturday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "sunday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "monday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "tuesday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "wednesday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "thursday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "friday": {
      "is_available": 0,
      "start_time": null,
      "end_time": null,
      "break_start_time": null,
      "break_end_time": null
    }
  }
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<ScheduleResource>>"
  ],
  "message": "clinic schedules updated successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | reservation_type missing, times invalid / end before start | `{"message": "حقل ( schedules.reservation type ) مطلوب", "errors": {"schedules.reservation_type": ["حقل ( schedules.reservation type ) مطلوب"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [ScheduleResource](#scheduleresource)

---

#### 10.4.33 Doctor With All Schedules

`GET /api/v2/doctor/doctor-with-all-schedules`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** data.doctor, data.clinic_schedules, data.doctor_medicals

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "doctor": "<<DoctorResource>>",
    "clinic_schedules": [
      "<<ScheduleResource>>"
    ],
    "doctor_medicals": [
      "<<DoctorMedicalsResource>>"
    ]
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorMedicalsResource](#doctormedicalsresource), [DoctorResource](#doctorresource), [ScheduleResource](#scheduleresource)

---

#### 10.4.34 Attach Medical Center

`POST /api/v2/doctor/attaching-doctor-medical`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `medical_center_id` | int | required | exists:medical_centers, not already attached |
| `schedules.reservation_type` |  | required | in:advance, specified_time |
| `schedules.{day}.is_available` | in:0 |  | 1 - effectively required, read directly |
| `schedules.{day}.start_time` |  | required_if is_available=1 | nullable, H:i |
| `schedules.{day}.end_time` |  | required_if 1 | nullable, H:i, after start |
| `schedules.{day}.break_start_time` |  | optional | H:i |
| `schedules.{day}.break_end_time` |  | optional | H:i, after break_start |

**Notes:** AttachMedicalApiRequest; all 7 days keys with all 5 sub-keys must be sent (missing -> 500); data = DoctorMedicalsResource

**Request example**

```json
{
  "medical_center_id": "{{medical_center_id}}",
  "schedules": {
    "reservation_type": "specified_time",
    "saturday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "sunday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "monday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "tuesday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "wednesday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "thursday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "friday": {
      "is_available": 0,
      "start_time": null,
      "end_time": null,
      "break_start_time": null,
      "break_end_time": null
    }
  }
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorMedicalsResource>>",
  "message": "new schedules added to doctor "
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | medical_center_id missing / unknown / already attached | `{"message": "قيمة ( المركز الطبى ) مُستخدمة من قبل", "errors": {"medical_center_id": ["قيمة ( المركز الطبى ) مُستخدمة من قبل"]}}` |
| 422 | schedule times invalid | `{"message": "يجب على ( تاريخ البداية ) أن يكون وقتاً لاحقًا لوقت تاريخ البداية", "errors": {"schedules.saturday.end_time": ["يجب على ( تاريخ البداية ) أن يكون وقتاً لاحقًا لوقت تاريخ البداية"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorMedicalsResource](#doctormedicalsresource)

---

#### 10.4.35 Update Medical Center Schedules

`POST /api/v2/doctor/updating-medical-schedules`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `medical_center_id` | int | required | must be in this doctor's places |
| `schedules` | object | required |  |
| `schedules.reservation_type` |  | required | in:advance, specified_time |
| `schedules.{day}.is_available/start_time/end_time/break_start_time/break_end_time` | same rules as attaching |  |  |

**Notes:** UpdateMedicalApiRequest; all 7 days required in practice

**Request example**

```json
{
  "medical_center_id": "{{medical_center_id}}",
  "schedules": {
    "reservation_type": "specified_time",
    "saturday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "sunday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "monday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "tuesday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "wednesday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "thursday": {
      "is_available": 1,
      "start_time": "09:00",
      "end_time": "17:00",
      "break_start_time": "13:00",
      "break_end_time": "14:00"
    },
    "friday": {
      "is_available": 0,
      "start_time": null,
      "end_time": null,
      "break_start_time": null,
      "break_end_time": null
    }
  }
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorMedicalsResource>>",
  "message": "new schedules added to doctor "
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | medical_center_id not one of this doctor's places | `{"message": "القيمة المحددة ( المركز الطبى ) غير موجودة", "errors": {"medical_center_id": ["القيمة المحددة ( المركز الطبى ) غير موجودة"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [DoctorMedicalsResource](#doctormedicalsresource)

---

#### 10.4.36 Detach Medical Center

`POST /api/v2/doctor/detaching-medical`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `medical_center_id` | int | required | must be in this doctor's places |

**Notes:** detaches center

**Request example**

```json
{
  "medical_center_id": "{{medical_center_id}}"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "medical deleted successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | medical_center_id missing / not attached | `{"message": "القيمة المحددة ( المركز الطبى ) غير موجودة", "errors": {"medical_center_id": ["القيمة المحددة ( المركز الطبى ) غير موجودة"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.4.37 My Offers

`GET /api/v2/doctor/offers`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `status(string,optional, active` |  |  |  |

**Notes:** inactive | expired: the chips) ; city_id(int,optional) ; page(int,optional) | Own offers, newest first; paginated envelope

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<OfferResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [OfferResource](#offerresource), [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta)

---

#### 10.4.38 Create Offer

`POST /api/v2/doctor/offers`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `multipart/form-data` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `main_pic` | file | required | mimes:jpeg, jpg, png, gif, svg, max 4096KB |
| `city_id` | int | optional | exists:cities; default: the city of the workplace |
| `title_ar` | string | required | max:255 |
| `title_en` | string | required | max:255 |
| `description_ar` | string | required | max:400 |
| `description_en` | string | required | max:400 |
| `is_price_shown` | boolean | optional | default true |
| `price_after` | numeric | required unless is_price_shown=0/false | min:0, lt:price_before |
| `price_before` | numeric | required unless is_price_shown=0/false | min:0 |
| `from_date` | date | required | Y-m-d, after_or_equal:today |
| `to_date` | date | required | after:from_date |
| `is_active` | boolean | required |  |

**Notes:** StoreOfferApiRequest; data = OfferResource; an active offer with a city sends "new offer near you" to the patients who picked that city

**Request example** (form-data)

```text
main_pic: <file>
city_id: 
title_ar: عرض خاص
title_en: Special offer
description_ar: وصف العرض
description_en: Offer description
is_price_shown: 1
price_before: 300
price_after: 200
from_date: 2026-11-01
to_date: 2026-11-30
is_active: 1
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<OfferResource>>",
  "message": "Offer created successfully"
}
```

_Note: city_id is optional: the city of the doctor's workplace is used. is_price_shown is optional and defaults to true._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | a required field is missing, or the discounted price is not below the original | `{"message": "العنوان بالإنجليزية مطلوب", "errors": {"title_en": ["العنوان بالإنجليزية مطلوب"]}}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [OfferResource](#offerresource)

---

#### 10.4.39 Change Offer Price Visibility

`POST /api/v2/doctor/offers/change-price-visibility`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `offer_id` | int | required | exists:offers, must be own -> else 404 |
| `is_price_shown` | boolean | required |  |

**Notes:** data = OfferResource

**Request example**

```json
{
  "offer_id": "{{offer_id}}",
  "is_price_shown": false
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<OfferResource>>",
  "message": "Offer price visibility changed successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | the offer has expired | `{"message": "العرض المنتهي للعرض فقط. يمكنك حذفه أو إنشاء عرض جديد.", "errors": {"offer": ["العرض المنتهي للعرض فقط. يمكنك حذفه أو إنشاء عرض جديد."]}}` |
| 404 | offer exists but belongs to another doctor (findOrFail) | `{"message": "No query results for model [App\\Models\\Offer] 12"}` |
| 422 | offer_id missing / unknown, is_price_shown not boolean | `{"message": "القيمة المحددة ( offer id ) غير موجودة", "errors": {"offer_id": ["القيمة المحددة ( offer id ) غير موجودة"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [OfferResource](#offerresource)

---

#### 10.4.40 Delete Offer

`DELETE /api/v2/doctor/offers/{offer}`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Path parameters:** `offer`

**Notes:** path {offer}=id, 404 if not own; response is a bare JSON array ["offer deleted successfully"], not the envelope

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "offer deleted successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | another doctor's offer | `{"message": ""}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

---

#### 10.4.41 Update Offer

`POST /api/v2/doctor/offers/{offer}`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `multipart/form-data` |

**Path parameters:** `offer`

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `main_pic` | file | optional | same mimes/size |
| `city_id` | int | optional | exists:cities |
| `title_ar` | string | required |  |
| `title_en` | string | required |  |
| `description_ar` | string | required | max:400 |
| `description_en` | string | required | max:400 |
| `is_price_shown` | boolean | optional |  |
| `price_after` | numeric | required unless is_price_shown=0/false | lt:price_before |
| `price_before` | numeric | required unless is_price_shown=0/false |  |
| `from_date` | date | required | no after_or_equal:today on update |
| `to_date` | date | required | after:from_date |
| `is_active` | boolean | required |  |

**Notes:** update offer (POST, not PUT; same StoreOfferApiRequest in update mode); 404 if not own; an expired offer answers 422 errors.offer

**Request example** (form-data)

```text
main_pic: <file>
city_id: 1
title_ar: عرض خاص
title_en: Special offer
description_ar: وصف العرض
description_en: Offer description
is_price_shown: 1
price_before: 300
price_after: 200
from_date: 2026-11-01
to_date: 2026-11-30
is_active: 1
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<OfferResource>>",
  "message": "Offer updated successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | the offer has expired | `{"message": "العرض المنتهي للعرض فقط. يمكنك حذفه أو إنشاء عرض جديد.", "errors": {"offer": ["العرض المنتهي للعرض فقط. يمكنك حذفه أو إنشاء عرض جديد."]}}` |
| 404 | offer belongs to another doctor (abort 404) | `{"message": ""}` |
| 404 | no Offer with that id | `{"message": "No query results for model [App\\Models\\Offer] 999"}` |
| 422 | title/description/dates missing, price_after >= price_before | `{"message": "حقل ( العنوان بالعربى ) مطلوب", "errors": {"title_ar": ["حقل ( العنوان بالعربى ) مطلوب"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [OfferResource](#offerresource)

---

#### 10.4.42 Change Offer Status

`POST /api/v2/doctor/offers/{offer}/change-status`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Path parameters:** `offer`

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `is_active` | boolean | required |  |

**Notes:** 404 if not own; an expired offer answers 422 errors.offer

**Request example**

```json
{
  "is_active": true
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "Offer status changed successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | the offer has expired | `{"message": "العرض المنتهي للعرض فقط. يمكنك حذفه أو إنشاء عرض جديد.", "errors": {"offer": ["العرض المنتهي للعرض فقط. يمكنك حذفه أو إنشاء عرض جديد."]}}` |
| 404 | offer belongs to another doctor (abort 404) | `{"message": ""}` |
| 404 | no Offer with that id | `{"message": "No query results for model [App\\Models\\Offer] 999"}` |
| 422 | is_active missing / not boolean | `{"message": "حقل ( is active ) مطلوب", "errors": {"is_active": ["حقل ( is active ) مطلوب"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.4.43 Monthly Report

`GET /api/v2/doctor/monthly-report/{table}/{year}`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Path parameters:** `table`, `year`

**Notes:** path {table} in reservations|ratings|offers|views ; {year} integer 2000..2100; else 422 errors.table/errors.year; data = {data:[12 monthly counts], min, max, has_data, years}

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "data": [
      3,
      5,
      0,
      8,
      12,
      7,
      4,
      9,
      6,
      10,
      2,
      1
    ],
    "min": 0,
    "max": 12,
    "has_data": true,
    "years": [
      2026,
      2025,
      2024
    ]
  },
  "message": "monthly report of reservations"
}
```

_Note: data has 12 monthly counts, January first. has_data false = "no data for this year". years fills the year picker._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | unknown table or year | `{"message": "The given data was invalid.", "errors": {"table": ["unsupported report, allowed: reservations, offers, views, ratings"]}}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

---

#### 10.4.44 Ad Packages

`GET /api/v2/doctor/ads`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** data = all ads

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<ADResource>>"
  ],
  "message": "All ads"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [ADResource](#adresource)

---

#### 10.4.45 Subscribe to Ad

`POST /api/v2/doctor/ads/{ad}/subscribe`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `multipart/form-data` |

**Path parameters:** `ad`

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `payment_method_id` | int | required; bank transfer or cash |  |
| `payment_receipt` | file | required for a bank transfer; jpg | png or pdf, up to 5 MB |

**Notes:** path {ad}=package id. Pay for or renew a package; waits for the administration

**Request example** (form-data)

```text
payment_method_id: 2
payment_receipt: <file>
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<MySubscription>>",
  "message": "تم إرسال الإيصال للمراجعة"
}
```

_Note: Nothing is activated: the administration confirms cash and transfers from the dashboard. A row is added per request, so the history stays._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | receipt type or size | `{"message": "نوع الملف غير مدعوم أو حجمه أكبر من 5 ميجابايت", "errors": {"payment_receipt": ["نوع الملف غير مدعوم أو حجمه أكبر من 5 ميجابايت"]}}` |
| 422 | transfer with no receipt | `{"message": "إيصال التحويل مطلوب", "errors": {"payment_receipt": ["إيصال التحويل مطلوب"]}}` |
| 422 | online or any other method | `{"message": "الدفع متاح نقداً أو بالتحويل البنكي فقط", "errors": {"payment_method_id": ["الدفع متاح نقداً أو بالتحويل البنكي فقط"]}}` |
| 422 | another package while one is running | `{"message": "يمكنك تغيير باقتك عبر الإدارة أو بعد انتهائها", "errors": {"ad": ["يمكنك تغيير باقتك عبر الإدارة أو بعد انتهائها"]}}` |
| 422 | a request is already under review | `{"message": "لديك طلب قيد المراجعة", "errors": {"ad": ["لديك طلب قيد المراجعة"]}}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [MySubscription](#mysubscription)

---

#### 10.4.46 My Subscription

`GET /api/v2/doctor/my-subscription`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** "My subscription": the doctor's package (an ad), dates, payment method, a request under review, bank details

**Success response — 200**

```json
{
  "success": true,
  "data": "<<MySubscription>>",
  "message": ""
}
```

_Note: status: active, expired or none. pending_request is null with nothing under review. can_choose_package true = show the packages from GET ads._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [MySubscription](#mysubscription)

---

#### 10.4.47 My Ads

`GET /api/v2/doctor/my-ads`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** The ads this doctor subscribed to, newest first: package, amount, status, payment method, dates

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<DoctorAdRequest>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

_Note: status: active, expired, under_review or rejected. Dates are null until the administration confirms._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorAdRequest](#doctoradrequest), [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta)

---

#### 10.4.48 Consultation Invoices

`GET /api/v2/doctor/invoices`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `status(string,optional, pending` |  |  |  |

**Notes:** paid | cancelled: the chips) ; page(int,optional) | Consultation invoices, one per booking, latest first; paginated

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<DoctorInvoice>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorInvoice](#doctorinvoice), [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta)

---

#### 10.4.49 Invoice Details

`GET /api/v2/doctor/invoices/{invoice}`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Path parameters:** `invoice`

**Notes:** Invoice details; {invoice} is the booking id

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorInvoice>>",
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | unknown id or another doctor's booking | `{"success": false, "message": "invoice not found"}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorInvoice](#doctorinvoice)

---

#### 10.4.50 Profile

`GET /api/v2/doctor/profile`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** "My account" and the profile screen

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorProfile2>>",
  "message": ""
}
```

_Note: deletion_request is {requested_at_label} while a request is under review._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorProfile2](#doctorprofile2)

---

#### 10.4.51 Edit Profile

`POST /api/v2/doctor/profile`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `multipart/form-data` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `image` | file | optional | jpg or png, max 4096KB |
| `bio` | string | optional | max:500 |
| `email` | string | required | email, unique among doctors |
| `contact_phone` | string | optional | 5XXXXXXXX or 05XXXXXXXX, shown to patients |

**Notes:** Edit profile

**Request example** (form-data)

```text
image: <file>
bio: طبيب أسنان بخبرة 12 عاماً
email: doctor@example.com
contact_phone: 511000000
```

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorProfile2>>",
  "message": "profile updated successfully"
}
```

_Note: Name, specialization and the sign-in phone are managed by the administration and are ignored here._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | invalid or taken email, invalid contact phone, bio over 500 characters | `{"message": "صيغة البريد الإلكتروني غير صحيحة", "errors": {"email": ["صيغة البريد الإلكتروني غير صحيحة"]}}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorProfile2](#doctorprofile2)

---

#### 10.4.52 Request Account Deletion

`POST /api/v2/doctor/deletion-request`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** Asks the administration to delete the account

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorProfile2>>",
  "message": "deletion request sent successfully"
}
```

_Note: The account stays active. The admins are notified and see it on the doctor page._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | a request is already under review | `{"message": "لديك طلب حذف قيد المراجعة", "errors": {"deletion": ["لديك طلب حذف قيد المراجعة"]}}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorProfile2](#doctorprofile2)

---

#### 10.4.53 Withdraw Deletion Request

`POST /api/v2/doctor/deletion-request/withdraw`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** Withdraws the request

**Success response — 200**

```json
{
  "success": true,
  "data": "<<DoctorProfile2>>",
  "message": "deletion request withdrawn successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

Objects: [DoctorProfile2](#doctorprofile2)

---

#### 10.4.54 Support

`GET /api/v2/doctor/support`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** Official contacts and the subjects of the form

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "phone": "920000000",
    "email": "support@dorak.sa",
    "hours": "9 ص - 5 م",
    "subjects": [
      {
        "key": "appointments",
        "label": "مشكلة في المواعيد"
      }
    ]
  },
  "message": ""
}
```

_Note: phone, email and hours are set in the dashboard (Settings > Contact); null until then._

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

---

#### 10.4.55 Send Support Message

`POST /api/v2/doctor/support`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `subject` | string | required | a key from GET support |
| `message` | string | required | max:500 |

**Notes:** Sends a message to the administration

**Request example**

```json
{
  "subject": "appointments",
  "message": "لا تظهر لي حجوزات يوم السبت"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "message sent successfully"
}
```

_Note: Lands in the dashboard contact messages._

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | message missing | `{"message": "هذا الحقل مطلوب", "errors": {"message": ["هذا الحقل مطلوب"]}}` |
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

---

#### 10.4.56 Mark All Notifications as Read

`POST /api/v2/doctor/notifications/mark-all-as-read`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** Marks every notification read

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "Notifications have been read successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid doctor token | `{"error": "Unauthenticated."}` |

---

#### 10.4.57 Subscriptions History

`GET /api/v2/doctor/subscriptions`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** SubscriptionResource paginated collection, no envelope

**Success response — 200**

```json
{
  "data": [
    "<<SubscriptionResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta), [SubscriptionResource](#subscriptionresource)

---

#### 10.4.58 Subscription Options

`GET /api/v2/doctor/subscription-options`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** data.subscription_type, data.days_left, data.monthly {price, price_after_discount}, data.yearly {...}

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "subscription_type": "free_trail",
    "days_left": 0,
    "monthly": {
      "price": "299",
      "price_after_discount": null
    },
    "yearly": {
      "price": "2999",
      "price_after_discount": "2499"
    }
  },
  "message": "All options"
}
```

_Note: prices are setting() values (strings); price_after_discount null outside its date window_

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.4.59 Create App Subscription

`POST /api/v2/doctor/create-application-subscription`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `multipart/form-data` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `subscription_type` |  | required | in:monthly, yearly |
| `payment_method_id` | int | required; bank transfer or cash |  |
| `payment_receipt` | file | required for a bank transfer | up to 5 MB |

**Notes:** Waits for the administration; online is refused

**Request example** (form-data)

```text
subscription_type: monthly
payment_method_id: 2
payment_receipt: <file>
```

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "subscription added successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | subscription_type not monthly/yearly, payment_method_id unknown, receipt missing for method 2 | `{"message": "حقل ( نوع الإشتراك ) مطلوب", "errors": {"subscription_type": ["حقل ( نوع الإشتراك ) مطلوب"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.4.60 Payment Methods

`GET /api/v2/doctor/payment-methods`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Notes:** data = payment methods with status=available

**Success response — 200**

```json
{
  "success": true,
  "data": [
    "<<PaymentMethodResource>>"
  ],
  "message": "All methods"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [PaymentMethodResource](#paymentmethodresource)

---

#### 10.4.61 Rate App

`POST /api/v2/doctor/app-ratings`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `rate` |  | required | between:1, 5 - no integer rule |
| `comment` | string | optional |  |

**Notes:** StoreAppRatingApiRequest

**Request example**

```json
{
  "rate": 5,
  "comment": "Great app"
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "rate saved successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | rate missing or not between 1 and 5 | `{"message": "يجب عليك تحديد التقيم", "errors": {"rate": ["يجب عليك تحديد التقيم"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.4.62 Available Schedules (clinic)

`GET /api/v2/doctor/available-schedules/{medical_center?}`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Path parameters:** `medical_center`

**Notes:** path {medical_center} optional id (omit = own clinic); data.places [{id,name}], data.schedules

**Success response — 200**

```json
{
  "success": true,
  "data": {
    "places": [
      {
        "id": 0,
        "name": "عيادة د. أحمد"
      }
    ],
    "schedules": [
      "<<TimeSlotsWeek>>"
    ]
  },
  "message": ""
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | no MedicalCenter with that id | `{"message": "No query results for model [App\\Models\\MedicalCenter] 999"}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [TimeSlotsWeek](#timeslotsweek)

---

#### 10.4.63 Notifications

`GET /api/v2/doctor/notifications`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** paginated NotificationResource, no envelope

**Success response — 200**

```json
{
  "data": [
    "<<NotificationResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [NotificationResource](#notificationresource), [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta)

---

#### 10.4.64 Unread Notifications

`GET /api/v2/doctor/unread-notifications`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `page` | int | optional |  |

**Notes:** same shape

**Success response — 200**

```json
{
  "data": [
    "<<NotificationResource>>"
  ],
  "links": "<<PaginationLinks>>",
  "meta": "<<PaginationMeta>>"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

Objects: [NotificationResource](#notificationresource), [PaginationLinks](#paginationlinks), [PaginationMeta](#paginationmeta)

---

#### 10.4.65 Mark Notification as Read

`POST /api/v2/doctor/notifications/{id}/mark-as-read`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | — |

**Path parameters:** `id`

**Notes:** path {id}=notification UUID; 404 if not own

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "Notification has been read successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 404 | notification not found or not the caller's | `{"success": false, "message": "notification not found"}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

#### 10.4.66 Toggle Notifications

`POST /api/v2/doctor/toggle-notifications`

| | |
|---|---|
| **Authorization** | Bearer token — doctor (`Authorization: Bearer {{doctor_token}}`) |
| **Content-Type** | `application/json` |

**Body fields**

| Field | Type | Required | Rules / notes |
|---|---|---|---|
| `allow_notifications` |  | required | in:0, 1 |

**Query parameters**

| Param | Type | Required | Rules / notes |
|---|---|---|---|
| `- \|` |  |  |  |

**Request example**

```json
{
  "allow_notifications": 1
}
```

**Success response — 200**

```json
{
  "success": true,
  "data": [],
  "message": "notifications updated successfully"
}
```

**Error responses**

| Status | When | Body |
|---|---|---|
| 422 | allow_notifications missing or not 0/1 | `{"message": "حقل ( allow notifications ) مطلوب", "errors": {"allow_notifications": ["حقل ( allow notifications ) مطلوب"]}}` |
| 401 | missing / invalid / revoked bearer token (or a token of the other app) | `{"error": "Unauthenticated."}` |
| 429 | api group throttle 60/min | `{"message": "Too Many Attempts."}` |

---

## 11. Response objects

Shapes of the objects referenced as `<<Name>>` in the examples above.

### PaginationLinks

```json
{
  "first": "{APP_URL}/api/v2/...?page=1",
  "last": "{APP_URL}/api/v2/...?page=3",
  "prev": null,
  "next": "{APP_URL}/api/v2/...?page=2"
}
```

### PaginationMeta

```json
{
  "current_page": 1,
  "from": 1,
  "last_page": 3,
  "links": [
    {
      "url": null,
      "label": "&laquo; Previous",
      "active": false
    },
    {
      "url": "{APP_URL}/api/v2/...?page=1",
      "label": "1",
      "active": true
    },
    {
      "url": "{APP_URL}/api/v2/...?page=2",
      "label": "Next &raquo;",
      "active": false
    }
  ],
  "path": "{APP_URL}/api/v2/...",
  "per_page": 15,
  "to": 15,
  "total": 40
}
```

### SpecializationResource

```json
{
  "id": 3,
  "name": "طب الأسنان",
  "icon": "{APP_URL}/storage/Images/Specializations/teeth.png"
}
```

### TitleResource

```json
{
  "id": 1,
  "name": "استشاري"
}
```

### CityResource

```json
{
  "id": 1,
  "name": "الرياض"
}
```

### AreaResource

```json
{
  "id": 5,
  "name": "العليا"
}
```

### CountryResource

```json
{
  "id": 1,
  "name": "السعودية"
}
```

### MedicalCenterResource

```json
{
  "id": 2,
  "logo": "{APP_URL}/storage/Images/MedicalCenters/center.png",
  "name": "مجمع النخبة الطبي",
  "description": "مجمع طبي متكامل",
  "distance_km": 3.42,
  "_note": "distance_km only present when the query selected a distance (nearest-medical-centers); absent elsewhere"
}
```

### ScheduleResource

```json
{
  "id": 11,
  "day_of_week": "saturday",
  "is_available": 1,
  "start_time": "09:00",
  "end_time": "17:00",
  "break_start_time": "13:00",
  "break_end_time": "14:00"
}
```

### DoctorMedicalsResource

```json
{
  "id": 2,
  "logo": "{APP_URL}/storage/Images/MedicalCenters/center.png",
  "name": "مجمع النخبة الطبي",
  "description": "مجمع طبي متكامل",
  "reservation_type": "specified_time",
  "schedules": [
    "<<ScheduleResource>>"
  ]
}
```

Uses: [ScheduleResource](#scheduleresource)

### DoctorResource

```json
{
  "_class": "App\\Http\\Resources\\DoctorResource (doctor app)",
  "id": 7,
  "title_id": 1,
  "ad_id": null,
  "area_id": 5,
  "city_id": 1,
  "city_name": "الرياض",
  "area_name": "العليا",
  "main_specialization_id": 3,
  "main_specialization_name": "طب الأسنان",
  "name": "د. أحمد علي",
  "title": "استشاري",
  "email": "ahmed@example.com",
  "phone": "0512345678",
  "gender": "male",
  "image": "{APP_URL}/storage/Images/Doctors/ahmed.png",
  "bio": "{APP_URL}/storage/Files/Doctors/bio_9f2c.pdf",
  "is_booking_available": 1,
  "allow_notifications": 1,
  "examination_price": "150.00",
  "examination_duration": 30,
  "experience_years": 12,
  "rate": "5.0",
  "total_views": 12,
  "status": "approved",
  "subscription_end_date": "free_trail",
  "subscription_status": true,
  "rejection_reason": null,
  "ad_expiration_date": null,
  "reservation_type": "specified_time",
  "work_for": "both",
  "clinic_name": "عيادة د. أحمد",
  "clinic_phone": "0587654321",
  "clinic_images": [
    "{APP_URL}/storage/Images/Doctors/clinic1.png"
  ],
  "clinic_info": "عيادة أسنان",
  "clinic_address": "طريق الملك فهد، الرياض",
  "lat": "24.7136",
  "lng": "46.6753",
  "verified_at": "2026-10-01 10:00:00",
  "created_at": "2025",
  "specializations": [
    "<<SpecializationResource>>"
  ],
  "_notes": "bio = PDF URL when a bio file exists, else the legacy text. rate = '5.0' when no ratings else number_format(rate,2). subscription_end_date actually holds subscription_type (monthly|yearly|free_trail). subscription_status bool (free_trail: created_at+14d >= now). status pending|approved|rejected. ad_expiration_date Carbon (ISO string) or null. created_at = year only."
}
```

Uses: [SpecializationResource](#specializationresource)

### PatientResource

```json
{
  "id": 1,
  "name": "سارة أحمد",
  "phone": "0551234567",
  "full_phone": "+966551234567",
  "email": "sara@example.com",
  "gender": "female",
  "birth_date": "1995-03-15",
  "city": {
    "id": 1,
    "name": "الدمام"
  },
  "weight": null,
  "height": null,
  "allow_notifications": 1,
  "country_id": null,
  "verified_at": "2026-11-01 12:00:00"
}
```

### PatientModelRaw

```json
{
  "_note": "Patient model toArray (GET patient/current): password, otp, social_id, fcm_token, deleted_at hidden; full_phone appended",
  "id": 21,
  "name": "محمد سالم",
  "email": "mohammed@example.com",
  "phone": "0551234567",
  "gender": "male",
  "weight": "75",
  "height": "175",
  "country_id": null,
  "allow_notifications": 1,
  "verified_at": "2026-10-28 10:15:00",
  "created_at": "2026-10-01",
  "updated_at": "2026-10-28",
  "full_phone": "+966551234567"
}
```

### PatientDoctorResource

```json
{
  "_class": "App\\Http\\Resources\\PatientApp\\DoctorResource",
  "id": 7,
  "name": "د. أحمد علي",
  "image": "{APP_URL}/storage/Images/Doctors/ahmed.png",
  "bio": "{APP_URL}/storage/Files/Doctors/bio_9f2c.pdf",
  "examination_price": "150.00",
  "examination_duration": 30,
  "address": "الرياض العليا",
  "rate": "4.50",
  "ratings_count": 2,
  "ad_order": 99999,
  "is_sponsored": false,
  "can_rate": false,
  "_notes": "address = '<city> <area>' of doctor or first medical center, else 'غير متاح حتى الأن'. ad_order = ad.order when sponsored else 99999. can_rate false for guests."
}
```

### PatientOfferResource

```json
{
  "_class": "App\\Http\\Resources\\PatientApp\\OfferResource",
  "id": 4,
  "city_id": 1,
  "city_name": "الرياض",
  "main_pic": "{APP_URL}/storage/Images/Offers/offer.png",
  "title": "خصم تنظيف الأسنان",
  "description": "خصم 30% على تنظيف الأسنان",
  "is_price_shown": true,
  "price_after": "100.00",
  "price_before": "150.00",
  "is_active": 1,
  "place": {
    "type": "medical_center",
    "id": 1,
    "name": "مركز العناية الطبي"
  },
  "doctor": "<<PatientDoctorResource>>",
  "_notes": "price_after/price_before are null when is_price_shown is false. title/description follow locale."
}
```

Uses: [PatientDoctorResource](#patientdoctorresource)

### OfferResource

```json
{
  "_class": "App\\Http\\Resources\\OfferResource (doctor app)",
  "id": 4,
  "city_id": 1,
  "city_name": "الرياض",
  "main_pic": "{APP_URL}/storage/Images/Offers/offer.png",
  "title_ar": "خصم تنظيف الأسنان",
  "title_en": "Teeth cleaning discount",
  "description_ar": "خصم 30% على تنظيف الأسنان",
  "description_en": "30% off teeth cleaning",
  "is_price_shown": true,
  "price_after": "100.00",
  "price_before": "150.00",
  "from_date": "2026-11-01",
  "to_date": "2026-11-30",
  "is_active": 1,
  "_notes": "prices null when is_price_shown false. Right after create/update is_active may echo the request value (e.g. \"1\"/true) since the model is not refreshed.",
  "status": "active",
  "status_label": "منشور",
  "can_edit": true,
  "date_label": "1 نوفمبر - 30 نوفمبر 2026",
  "place": {
    "type": "clinic",
    "id": 1,
    "name": "عيادة النخبة"
  }
}
```

### PatientReservationResource

```json
{
  "id": 2,
  "main_specialization": "طب الأسنان",
  "full_image_path": "{APP_URL}/assets/dashboard/media/placeholders/default.svg",
  "name": "د. أحمد العلي",
  "rate": "5.0",
  "phone": "0510000005",
  "status": "confirmed",
  "date": "05 Nov, 2026, 12:00 AM",
  "day": "05",
  "month": "نوفمبر",
  "booking_number": "DR-00002",
  "date_value": "2026-11-05",
  "time_value": "04:30 PM",
  "date_label": "الخميس، 5 نوفمبر 2026",
  "time_label": "4:30 م",
  "doctor": {
    "id": 1,
    "name": "د. أحمد العلي",
    "image": "{APP_URL}/assets/dashboard/media/placeholders/default.svg",
    "headline": "استشاري طب الأسنان"
  },
  "service": "كشف واستشارة طب الأسنان",
  "specialization": {
    "id": 1,
    "name": "طب الأسنان"
  },
  "place": {
    "type": "medical_center",
    "id": 1,
    "name": "مجمع النور الطبي",
    "image": "{APP_URL}/assets/dashboard/media/placeholders/default.svg",
    "branch": "فرع الفيصلية · الدمام",
    "phone": "+966510000005",
    "address": "فرع الفيصلية · شارع الملك فهد، الدمام",
    "lat": 26.43,
    "lng": 50.09
  },
  "patient_name": "سارة أحمد",
  "amount": "150.00",
  "payment_type": "cash",
  "payment_method": "الدفع في العيادة",
  "can_cancel": true,
  "can_reschedule": true,
  "change_deadline": "2026-11-05T12:30:00+00:00",
  "display_status": "confirmed",
  "status_label": "مؤكد",
  "can_rate": false,
  "cancellation": null
}
```

### ReservationResource

```json
{
  "_class": "App\\Http\\Resources\\ReservationResource (doctor app)",
  "id": 55,
  "date": "الخميس 05 نوفمبر, 2026",
  "name": "محمد سالم",
  "phone": "0551234567",
  "status": "pending",
  "status_label": "مؤكد",
  "booking_number": "DR-02044",
  "time_label": "10:30 ص",
  "service": "كشف واستشارة طب الأسنان",
  "medical_center_id": null,
  "time": "05:30 م",
  "day": "05",
  "month": "نوفمبر",
  "place_name": "عيادة د. أحمد",
  "_notes": "name/phone are the patient's. date 'l d M, Y' and time 'h:i A' are translatedFormat (Arabic by default; en: 'Thursday 05 Nov, 2026', '05:30 PM'). place_name = medical center name, else clinic_name, else 'في العيادة'.",
  "queue_number": null,
  "queue_label": null,
  "queue_status": null,
  "queue_status_label": null,
  "actions": [
    "completed",
    "no_show",
    "cancelled"
  ],
  "attendance_available": true,
  "attendance_available_from": "10:30 ص",
  "cancellation_reason": null
}
```

### RatingResource

```json
{
  "_class": "App\\Http\\Resources\\RatingResource (Patient model with ratings pivot)",
  "id": 9,
  "name": "محمد سالم",
  "comment": "طبيب ممتاز",
  "rating": 5,
  "time": "منذ يومين",
  "_notes": "id = ratings.id (pivot), name = patient name, time = diffForHumans"
}
```

### PatientRatingResource

```json
{
  "_class": "App\\Http\\Resources\\PatientApp\\RatingResource (Rating model)",
  "id": 9,
  "name": "محمد سالم",
  "comment": "طبيب ممتاز",
  "rating": 5,
  "time": "منذ ثانية واحدة"
}
```

### NotificationResource

```json
{
  "id": "14de56ac-7305-4ff9-93ce-6cae8398ff95",
  "type": "reservation_reminder",
  "title": "تذكير بموعدك",
  "description": "موعدك مع الدكتور د. أحمد العلي غداً 2026-11-05 04:30 PM",
  "date": "منذ ثانية",
  "read_at": null,
  "is_read": false,
  "group": "today",
  "target": {
    "reservation_id": 1
  },
  "date_label": "الخميس، 29 أكتوبر 2026 · 9:00 ص"
}
```

### NewsletterResource

```json
{
  "id": 1,
  "description": "نص الخبر"
}
```

### ADResource

```json
{
  "id": 1,
  "name": "الباقة الذهبية",
  "description": "ظهور في أعلى نتائج البحث",
  "price": "500.00",
  "subscription_days": 30,
  "order": 3,
  "status": "unsubscribed",
  "_notes": "status subscribed|pending|unsubscribed for the current doctor"
}
```

### BankAccountResource

```json
{
  "logo": "bank_logo.png",
  "owner": "شركة دورك",
  "bank_name": "البنك الأهلي",
  "iban_number": "SA0380000000608010167519",
  "_note": "logo is the raw stored file name (no URL)"
}
```

### PaymentMethodResource

```json
{
  "id": 2,
  "name": "تحويل بنكي",
  "type": "bank_account",
  "bank_accounts": [
    "<<BankAccountResource>>"
  ],
  "_note": "type cash|bank_account|online; bank_accounts empty for non-bank methods"
}
```

Uses: [BankAccountResource](#bankaccountresource)

### SubscriptionResource

```json
{
  "id": 3,
  "amount": "299.00",
  "description": "اشتراك التطبيق",
  "is_paid": 0,
  "create_at": "2026-10-20",
  "_notes": "description = '<ad name> اشتراك في إعلان' when type=='ads', else 'اشتراك التطبيق'. Key is spelled create_at."
}
```

### FavoriteResource

```json
{
  "type": "doctor",
  "item": "<<PatientDoctorResource>>",
  "_note": "type 'doctor' -> item PatientDoctorResource; type 'offer' -> item PatientOfferResource"
}
```

Uses: [PatientDoctorResource](#patientdoctorresource)

### DoctorPlace

```json
{
  "_class": "array from Doctor::prepareClinicData()/prepareMedicalData() (no Resource)",
  "id": 0,
  "images": [
    "{APP_URL}/storage/Images/Doctors/clinic1.png"
  ],
  "name": "عيادة د. أحمد",
  "phone": "0587654321",
  "description": "عيادة أسنان",
  "short_address": "العليا , الرياض",
  "long_address": "طريق الملك فهد، الرياض",
  "lat": "24.7136",
  "lng": "46.6753",
  "examination_price": "150.00",
  "examination_duration": 30,
  "reservation_status": true,
  "_notes": "id 0 = own clinic; medical centers use their id, images [logo URL], short_address null (no short_location column), long_address = center location. reservation_status = doctor accepts online booking."
}
```

### TimeSlotsWeek

```json
{
  "_class": "array from Schedule::doctorTimeSlotsOfPlace() (4 weeks; [] when the doctor has no schedule for that place)",
  "interval": "2026-10-28 - 2026-11-04",
  "week": [
    {
      "name": "wednesday",
      "short_name": "We",
      "number": "28",
      "date": "2026-10-28",
      "status": 1,
      "time_slots": [
        {
          "time": "09:00 AM",
          "available": true
        }
      ]
    }
  ],
  "_notes": "7 days per week; status = schedule is_available (false when no shift); time_slots [] on days off"
}
```

### MedicalCenterCardResource

```json
{
  "type": "medical_center",
  "id": 1,
  "name": "مركز العناية الطبي",
  "image": "{APP_URL}/storage/Images/MedicalCenters/center.png",
  "rating": 4.8,
  "ratings_count": 120,
  "distance_km": 1.7,
  "specializations": [
    {
      "id": 1,
      "name": "الأسنان"
    },
    {
      "id": 2,
      "name": "الجلدية"
    }
  ],
  "city": "الدمام",
  "area": "حي الفيصلية",
  "address": "الدمام - حي الفيصلية",
  "available_today": true,
  "phone": "+966551234567",
  "lat": 26.4357,
  "lng": 50.0888
}
```

### ClinicCardResource

```json
{
  "type": "clinic",
  "id": 1,
  "name": "عيادة دكتور احمد",
  "image": "{APP_URL}/storage/Images/Doctors/clinic.png",
  "rating": 4.6,
  "ratings_count": 35,
  "distance_km": 1,
  "specializations": [
    {
      "id": 1,
      "name": "الأسنان"
    }
  ],
  "city": "الدمام",
  "area": "حي الفيصلية",
  "address": "الدمام - حي الفيصلية",
  "available_today": false,
  "phone": "+966559876543",
  "lat": 26.43,
  "lng": 50.09,
  "is_sponsored": false,
  "doctor": {
    "id": 1,
    "name": "د. أحمد",
    "image": "{APP_URL}/storage/Images/Doctors/doctor.png"
  }
}
```

### Location

```json
{
  "area_id": 1,
  "area": "حي الفيصلية",
  "city_id": 1,
  "city": "الدمام",
  "label": "الدمام، حي الفيصلية",
  "lat": 26.42,
  "lng": 50.09
}
```

### DoctorCardResource

```json
{
  "id": 1,
  "name": "د. أحمد العلي",
  "image": "{APP_URL}/assets/dashboard/media/placeholders/default.svg",
  "title": "استشاري",
  "specialization": {
    "id": 1,
    "name": "طب الأسنان"
  },
  "headline": "استشاري طب الأسنان",
  "rating": 4.8,
  "ratings_count": 1,
  "examination_price": "150.00",
  "is_sponsored": false
}
```

### DoctorProfile

```json
{
  "id": 1,
  "name": "د. أحمد العلي",
  "image": "{APP_URL}/assets/dashboard/media/placeholders/default.svg",
  "title": "استشاري",
  "specialization": {
    "id": 1,
    "name": "طب الأسنان"
  },
  "headline": "استشاري طب الأسنان · مجمع النور الطبي",
  "rating": 4.8,
  "ratings_count": 1,
  "experience_years": 12,
  "patients_count": 500,
  "bio": "استشاري في طب وجراحة الأسنان",
  "bio_url": null,
  "branches": [
    {
      "city": "الدمام",
      "areas": [
        "الفيصلية"
      ],
      "places": [
        {
          "type": "clinic",
          "id": 1,
          "name": "عيادة دكتور احمد",
          "area": "الفيصلية"
        },
        {
          "type": "medical_center",
          "id": 1,
          "name": "مجمع النور الطبي",
          "area": "الفيصلية"
        }
      ]
    }
  ],
  "services": [
    {
      "name": "كشف واستشارة طب الأسنان",
      "price": "150.00"
    }
  ],
  "is_favorite": false
}
```

### PlaceRatings

```json
{
  "count": 5,
  "average": 4.6,
  "data": [
    "<<PatientRatingResource>>"
  ]
}
```

Uses: [PatientRatingResource](#patientratingresource)

### BookingDay

```json
{
  "date": "2026-11-05",
  "day_of_week": "thursday",
  "day_name": "الخميس",
  "day_number": 5,
  "month": "نوفمبر 2026",
  "is_today": false,
  "status": "available"
}
```

### BookingSlot

```json
{
  "time": "09:00 AM",
  "available": true,
  "doctor_id": 1,
  "label": "9:00 ص"
}
```

### ReservationCancellation

```json
{
  "reason": "schedule_conflict",
  "label": "تعارض في الموعد",
  "note": null
}
```

### CenterQueue

```json
{
  "medical_center_id": 1,
  "name": "مركز الرعاية الطبي",
  "waiting_count": 3,
  "next": {
    "reservation_id": 2044,
    "turn": 2,
    "patient_name": "ريا السبيعي",
    "time_label": "10:30 ص"
  }
}
```

### DoctorReservationDetailsResource

```json
{
  "...": "<<ReservationResource>> fields, plus:",
  "patient_full_phone": "+966553007788",
  "date_label": "الأحد، 1 نوفمبر 2026",
  "source": "online",
  "source_label": "حجز إلكتروني",
  "reservation_system": "fixed",
  "reservation_system_label": "موعد محدد",
  "amount": "250.00",
  "patient_note": "أرجو التواصل معي في حال تأخر الموعد"
}
```

Uses: [ReservationResource](#reservationresource)

### DoctorDayGroup

```json
{
  "date": "الأحد 01 نوفمبر, 2026",
  "title": "عيادة النخبة لطب الأسنان",
  "count": 6,
  "reservations": [
    "<<ReservationResource>>"
  ]
}
```

Uses: [ReservationResource](#reservationresource)

### Workplace

```json
{
  "id": 0,
  "type": "clinic",
  "type_label": "عيادة",
  "name": "عيادة النخبة لطب الأسنان",
  "location": "الرياض، العليا",
  "reservation_type": "specified_time",
  "reservation_type_label": "مواعيد محددة",
  "examination_duration": 20,
  "duration_label": "20 دقيقة",
  "examination_price": "250.00"
}
```

### WorkplaceDetails

```json
{
  "...": "<<Workplace>> fields, plus:",
  "working_days_count": 6,
  "address": "حي العليا، طريق العليا العام",
  "area": "العليا",
  "phone": "0110000000"
}
```

Uses: [Workplace](#workplace)

### ScheduleDay

```json
{
  "day": "saturday",
  "day_label": "السبت",
  "is_available": true,
  "periods": [
    {
      "start_time": "09:00",
      "end_time": "13:00"
    },
    {
      "start_time": "16:00",
      "end_time": "21:00"
    }
  ]
}
```

### DoctorQueue

```json
{
  "medical_center_id": 1,
  "name": "مركز الرعاية الطبي",
  "date_label": "الخميس، 29 أكتوبر 2026",
  "starts_label": "4:00 م",
  "waiting_count": 3,
  "total_count": 4,
  "can_call_next": true,
  "reservations": [
    "<<ReservationResource>>"
  ]
}
```

Uses: [ReservationResource](#reservationresource)

### MySubscription

```json
{
  "package": {
    "id": 1,
    "name": "الباقة الذهبية"
  },
  "status": "active",
  "status_label": "نشط",
  "duration_days": 25,
  "start_date_label": "الخميس، 15 أكتوبر 2026",
  "end_date_label": "الأحد، 8 نوفمبر 2026",
  "payment_method": "bank_account",
  "payment_method_label": "تحويل بنكي",
  "can_renew_by_transfer": true,
  "can_choose_package": false,
  "pending_request": {
    "id": 7,
    "package_name": "الباقة الذهبية",
    "payment_method": "bank_account",
    "file_name": "ايصال-تحويل-اكتوبر.pdf",
    "sent_at_label": "الخميس، 29 أكتوبر 2026",
    "status_label": "قيد المراجعة"
  },
  "bank_accounts": [
    "<<BankAccountResource>>"
  ]
}
```

Uses: [BankAccountResource](#bankaccountresource)

### DoctorInvoice

```json
{
  "id": 3108,
  "invoice_number": "INV-03108",
  "booking_number": "DR-03108",
  "patient_name": "سارة القحطاني",
  "place_name": "عيادة النخبة لطب الأسنان",
  "amount": "250.00",
  "date_label": "الخميس، 29 أكتوبر 2026",
  "status": "paid",
  "status_label": "مدفوعة"
}
```

### DoctorProfile2

```json
{
  "id": 1,
  "name": "د. فهد العتيبي",
  "image": "{APP_URL}/storage/Images/Doctors/doctor.png",
  "specialization": "طب الأسنان",
  "sign_in_phone": "+966550123456",
  "bio": "طبيب أسنان بخبرة 12 عاماً",
  "bio_url": null,
  "email": "fahad@example.com",
  "contact_phone": "0511000000",
  "contact_phone_full": "+966511000000",
  "allow_notifications": true,
  "workplaces_count": 2,
  "rating": 4.8,
  "package_name": "الباقة الذهبية",
  "deletion_request": null
}
```

### DoctorAdRequest

```json
{
  "id": 7,
  "ad": {
    "id": 1,
    "name": "الباقة الذهبية",
    "description": "ظهور مميز",
    "subscription_days": 25
  },
  "amount": "500.00",
  "status": "active",
  "status_label": "نشط",
  "payment_method_label": "تحويل بنكي",
  "start_date_label": "الخميس، 15 أكتوبر 2026",
  "end_date_label": "الاثنين، 9 نوفمبر 2026"
}
```

