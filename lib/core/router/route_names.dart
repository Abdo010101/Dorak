/// Named routes consumed by `AppRouter`. Strings preserved verbatim
/// from the pre-Phase-3 `NameRoutes` constants so FCM deep links
/// (`action` payload) and any client code that hand-wrote `/home/...`
/// paths keep resolving unchanged.
abstract class RouteNames {
  static const splash = '/';
  static const welcome = '$splash/welcome';
  static const intro = '$splash/intro';
  static const login = '$splash/login';
  static const register = '$welcome/register';
  static const completeInfo = '$splash/complete-info';
  static const signedIn = '$splash/signed-in';
  static const otp = '$register/otp';
  static const home = '$splash/home';
  static const notification = '$home/notification';
  static const offers = '$home/offers';
  static const setting = '$profile/setting';
  static const forgetPassword = '$login/forget_password';
  static const appointments = '$login/appointments_screen';
  static const review = '$home/reviews_screen';
  static const searchForCity = '$home/search_for_city_screen';
  static const searchForArea = '$home/search_for_area_screen';
  static const resultOfSearch = '$searchForCity/result_of_search';
  static const searchForSpecialties = '$home/search_for_specialties_screen';
  static const searchForSubSpecialties =
      '$home/search_for_sub_specialties_screen';
  static const doctor = '$home/doctor_Screen';
  static const report = '$home/report_Screen';
  static const profile = '$home/profile_screen';
  static const profileDetails = '$profile/profile_details_screen';
  static const editProfile = '$profileDetails/edit_profile_screen';
  static const success = '$otp/success_screen';
  static const signUpFinger = '$success/sign_up_finger_screen';
  static const medicalCenter = '$profile/medical_center_screen';
  static const appReview = '$profile/app_review';
  static const changePassword = '$otp/changePassword';
  static const mainTest = 'main_test_screen';
  static const gender = '$otp/gender_screen';
  static const language = '$profile/language_screen';
  static const addAppointment = '$home/add_appointment_screen';
  static const bookingReview = '$home/booking_review_screen';
  static const bookingConfirmed = '$home/booking_confirmed_screen';
  static const bestDoctors = '$home/best_doctors_screen';
  static const doctorReview = '$doctor/doctor_review_screen';
  static const changePhone = '$welcome/change_phone_screen';
  static const searchDoctor = '$home/search_doctor_screen';
  static const discoveryExploreMap = '$home/discovery/explore_map';
  static const discoveryLocationPicker = '$home/discovery/location_picker';
}
