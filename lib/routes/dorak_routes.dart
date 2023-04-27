abstract class NameRoutes {
  static const kSplashScreen = "/";
  static const kWelcomeScreen = "$kSplashScreen/welcome";
  static const kIntroScreen = "$kSplashScreen/intro";
  static const kLoginScreen = '$kSplashScreen/login';
  static const kRegisterScreen = '$kSplashScreen/register';
  static const kCompleteInfoScreen = '$kSplashScreen/complete-info';
  static const kOTPScreen = '$kRegisterScreen/otp';
  static const kHomeScreen = '$kSplashScreen/home';
  static const kEditProfileScreen = '$kHomeScreen/edit_profile';
  static const kNotificationScreen = '$kHomeScreen/notification';
  static const kOffersScreen = '$kHomeScreen/offers';
  static const kNewOfferScreen = '$kOffersScreen/new_offer';
  static const kSettingScreen = '$kMenuDrawerScreen/setting';
  static const kForgetPasswordScreen = '$kLoginScreen/forget_password';
  static const kAppointmentsScreen = '$kLoginScreen/appointments_screen';
  static const kReviewScreen = '$kHomeScreen/reviews_screen';
  static const kMenuDrawerScreen = '$kHomeScreen/menu_drawer_screen';
  static const kMyBillScreen = '$kMenuDrawerScreen/my_bill_screen';
  static const kReportScreen = '$kHomeScreen/report_Screen';
  static const kProfileScreen = '$kHomeScreen/profile_screen';
  static const kProfileDetailsScreen = '$kProfileScreen/profile_details_screen';
  static const kClinicProfileScreen = '$kProfileScreen/clinic_profile_screen';
  static const kSuccessScreen = '$kOTPScreen/success_screen';
  static const kSuccessPromotionScreen =
      '$kHomeScreen/success_promotion_screen';
  static const kSignUpFingerScreen = '$kSuccessScreen/sign_up_finger_screen';
  static const kMedicalCenterScreen = '$kProfileScreen/medical_center_screen';
  static const kAppReview = '$kMenuDrawerScreen/app_review';
  static const kPromoteScreen = '$kMenuDrawerScreen/promote';
  static const kGoogleMap = '$kMenuDrawerScreen/google_map';
  static const kSubscriptionScreen = '$kMenuDrawerScreen/subscription';
  static const kChangePasswordScreen = '$kOTPScreen/changePassword';
}
