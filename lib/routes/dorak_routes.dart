abstract class NameRoutes {
  static const kSplashScreen = "/";
  static const kWelcomeScreen = "$kSplashScreen/welcome";
  static const kIntroScreen = "$kSplashScreen/intro";
  static const kLoginScreen = '$kSplashScreen/login';
  static const kRegisterScreen = '$kWelcomeScreen/register';
  static const kCompleteInfoScreen = '$kSplashScreen/complete-info';
  static const kOTPScreen = '$kRegisterScreen/otp';
  static const kHomeScreen = '$kSplashScreen/home';
  static const kNotificationScreen = '$kHomeScreen/notification';
  static const kOffersScreen = '$kHomeScreen/offers';
  static const kSettingScreen = '$kProfileScreen/setting';
  static const kForgetPasswordScreen = '$kLoginScreen/forget_password';
  static const kAppointmentsScreen = '$kLoginScreen/appointments_screen';
  static const kReviewScreen = '$kHomeScreen/reviews_screen';
  static const kSearchForCityScreen = '$kHomeScreen/search_for_city_screen';
  static const kResultOfSearch = '$kSearchForCityScreen/result_of_search';
  static const kSearchForSpecialtiesScreen =
      '$kHomeScreen/search_for_specialties_screen';
  static const kDoctorScreen = '$kHomeScreen/doctor_Screen';
  static const kReportScreen = '$kHomeScreen/report_Screen';
  static const kProfileScreen = '$kHomeScreen/profile_screen';
  static const kProfileDetailsScreen = '$kProfileScreen/profile_details_screen';
  static const kEditProfileScreen =
      '$kProfileDetailsScreen/edit_profile_screen';
  static const kSuccessScreen = '$kOTPScreen/success_screen';
  static const kSignUpFingerScreen = '$kSuccessScreen/sign_up_finger_screen';
  static const kMedicalCenterScreen = '$kProfileScreen/medical_center_screen';
  static const kAppReview = '$kProfileScreen/app_review';
  static const kChangePasswordScreen = '$kOTPScreen/changePassword';
  static const kMainTestScreen = 'main_test_screen';
  static const kGenderScreen = '$kOTPScreen/gender_screen';
  static const kLanguageScreen = '$kProfileScreen/language_screen';
  static const kAddAppointmentScreen = '$kHomeScreen/add_appointment_screen';
  static const kBestDoctorsScreen = '$kHomeScreen/best_doctors_screen';
}
