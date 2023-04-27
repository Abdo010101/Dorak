class NetworkConstant {
  static const int kPageSize = 8;
  static const String kPageSizeParam = 'paginate';
  static const String kPageNumberParam = 'page';
  static const int kPageNumberValue = 1;

  static const _kDevBaseUrl = 'http://192.168.1.105:8000/api/doctor/';

  // static const _kDevBaseUrl = 'http://192.168.1.109:8000/api/';
  static const _kReleaseBaseUrl = 'https://dorak-dev.webstdy.net/api/doctor/';
  static const kAppleStoreUrl = '';
  static const kGooglePlayUrl = '';
  static const kAndroidPackage = '';
  static const kAppleId = '';
  static const kAuthorizationHeader = "authorization";
  static const kBaseUrl = _kReleaseBaseUrl;
  static const kGoogleApiKey = 'AIzaSyBZFRav3jNg1pH9RAQxO1IhOGb7keLaoDM';

/*  static const kTestToken =
      'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiZmY4MmZjNTdiYTQ2Mzk3YjM2NTI4MDFiZjNhMzZkZWEwOWJhNGJmMmNjMjgzYmQyNDQzNDMyMmYxMjZiOWM4ZThkYWRmYzBkOGU1MjBmOTgiLCJpYXQiOjE2NzcwNjczNTIuNjUyMjkxLCJuYmYiOjE2NzcwNjczNTIuNjUyMjkzLCJleHAiOjE3MDg2MDMzNTIuNjM3MjExLCJzdWIiOiIyMyIsInNjb3BlcyI6W119.i3H1gqw1ANIHTwEy4PJrFmjlgmYewVvxjJL3aYx3OXqAwY3kczXiP_hgm4YM2dlktmTxi5gKQ55gpzeGfNi_OVyLh0tA-lYet7VfAbfrHLX7goLeg9AmaQtDc4l8qtHrlwxywZDlR1D0SC3OxcaKUd8HCVX61wRbb9W3NgKgcm6-aO4ijPXoEb1dHymD8JvxXFntZNiCNoHpmDCVXwdSyoCewJEfHAm_VE7H_FolN8zBC2CXufgWePqC3SgqvfO2xZ7dYqk_zXu1Cgt5PQcCD_5cNM38tT4YMlpVoKirwGSfS-RMl4rogn2fpxceDEFmUwFFU4zX-6eQhrOFfHpEyTMskICuUFXuP7J3WimpVfN0tJySZD-nFIivYCU-uiE9WlhnFoA6PxlorE6mb59eAETBgQr1TYJkylomldc5MkYqM4ov_IBUIIvxlQrQ0zAdi6ByVjkFCdcfwgBLHNe5TJ3EZQdQcuGbxvVXLmL8zvCFntiQjgkPw60xz6HtpJMSiSSr6A1P9qwnVag1-Vr96ywxMaHd2TfGvWFUKuxY1J0FZsQw11JfWpjZeK2-AbofuC2LXs-JDh4d7ViJV1sJNW5asdjNA3U4hpMM_-2q90DHCh7Xq8Hxd_DegViSkK_QF7Lf9I6-HxJopIFm3qw6eSsX4vEL4Wxr2jx0OSU_ZjY';*/

  static String tokenBuilder(String token) => 'Bearer $token';

  static const String kHomeRequest = "home";
  static const String kAllOffers = "offers";
  static const String kLoginRequest = "login";
  static const String kRegisterRequest = "register";
  static const String kSendOtpRequest = "resend-otp";
  static const String kVerifyOtpRequest = "verify";
  static const String kCompleteInfoRequest = "complete-information";
  static const String kGeneralRequest = "general";
  static const String kProductRequest = "products";
  static const String kSpecializationRequest = "main-specializations";
  static const String kSubSpecializationRequest = "sub-specializations";
  static const String kCitiesRequest = "cities";
  static const String kAreasRequest = "areas";
  static const String kSingleCollectionRequest = "collections";
  static const String kAllReview = "ratings";
  static const String kUpcomingApp = "reservations/upcoming";
  static const String kTodayApp = "reservations/today";
  static const String kPastApp = "reservations/past";
  static const String kHomeData = "home";
  static const String kReports = "monthly-report/";
  static const String kDoctorSchedules = "doctor-with-all-schedules";
  static const String kSubscriptions = "subscriptions";
  static const String kAds = "ads";
  static const String kMedicalCenterRequest = "medical-centers";
  static const String kChangeBookingStatus = "change-booking-status";
  static const String kAppRatings = "app-ratings";
  static const String kUpdateProfile = "update-personal-information";
  static const String kTerms = "terms-of-service";
  static const String kPolicy = "privacy-policy";
  static const String kChangeAppointmentStatus = "reservations/change-status";
  static const String kChangeOfferStatus = "change-status";
  static const String kUpdateClinicInfo = "update-clinic-information";
  static const String kUpdateClinicSchedules = "update-clinic-schedules";
  static const String kUpdateMedicalSchedules = "updating-medical-schedules";
  static const String kDeleteMedicalCenter = 'detaching-medical';
  static const String kLogout = "logout";
  static const String kNotifications = "notifications";
  static const String kSubscriptionOptions = "subscription-options";
  static const String kPaymentMethods = "payment-methods";
  static const String kCheckOtp = "check-otp";
  static const String kSendOtp = "send-otp";
  static const String kChangePassword = "change-password";
  static const String kSocialLogin = "social-login";
  static const String kCreateApplicationSubscription =
      "create-application-subscription";
  static const String kUpdateNotificationsStatus = "toggle-notifications";
}
