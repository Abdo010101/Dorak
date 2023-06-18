class NetworkConstant {
  static const int kPageSize = 8;
  static const String kPageSizeParam = 'paginate';
  static const String kPageNumberParam = 'page';
  static const int kPageNumberValue = 1;

  static const _kDevBaseUrl = 'https://dev.dorak-app.com/api/patient/';

  static const _kReleaseBaseUrl = 'https://dorak-app.com/api/patient/';
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
  static const String kDoctorProfileRequest = "doctors";
  static const String kBestDoctors = "best-doctors";
  static const String kAllOffers = "offers";
  static const String kLoginRequest = "login";
  static const String kRegisterRequest = "register";
  static const String kGeneralRequest = "general";
  static const String kAreaRequest = "areas";
  static const String kDoctorsRequest = "doctors";
  static const String kAvailableSchedulesRequest = "available-schedules";
  static const String kUpdateProfile = "update-profile";
  static const String kNotifications = "notifications";
  static const String kUpdateNotificationsStatus = "toggle-notifications";
  static const String kLogout = "logout";
  static const String kSocialLogin = "social-login";
  static const String kAppointment = "reservations";
  static const String kAppRatings = "app-ratings";
  static const String kRatings = "ratings";
  static const String kCancelReservation = "$kAppointment/cancel-reservation";
  static const String kCheckOtp = "check-otp";
  static const String kVerifyOtp = "verify";
  static const String kSendOtp = "send-otp";
  static const String kChangePassword = "change-password";
  static const String kSendOtpRequest = "resend-otp";
  static const String kVerifyOtpRequest = "verify";
  static const String kTerms = "terms-of-service";
  static const String kPolicy = "privacy-policy";
  static const String kCompleteData = "complete-profile-data";
  static const String kProfile = "profile";
}
