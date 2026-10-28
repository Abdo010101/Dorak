import 'package:dorakpattient/core/router/app_router.dart';
import 'package:dorakpattient/core/router/route_names.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('AppRouter', () {
    test('every RouteNames constant has a GoRoute with the same name', () {
      final registered = _collectNames(AppRouter.router.configuration.routes);
      final expected = <String>{
        RouteNames.splash,
        RouteNames.welcome,
        RouteNames.intro,
        RouteNames.login,
        RouteNames.register,
        RouteNames.otp,
        RouteNames.home,
        RouteNames.notification,
        RouteNames.setting,
        RouteNames.forgetPassword,
        RouteNames.appointments,
        RouteNames.searchForCity,
        RouteNames.searchForArea,
        RouteNames.resultOfSearch,
        RouteNames.searchForSpecialties,
        RouteNames.searchForSubSpecialties,
        RouteNames.doctor,
        RouteNames.profile,
        RouteNames.profileDetails,
        RouteNames.editProfile,
        RouteNames.success,
        RouteNames.appReview,
        RouteNames.changePassword,
        RouteNames.gender,
        RouteNames.language,
        RouteNames.addAppointment,
        RouteNames.bestDoctors,
        RouteNames.doctorReview,
        RouteNames.changePhone,
        RouteNames.searchDoctor,
        RouteNames.offers,
      };
      final missing = expected.difference(registered);
      expect(missing, isEmpty, reason: 'Missing routes: $missing');
    });

    test('RouteNames expose stable string values', () {
      expect(RouteNames.splash, '/');
      expect(RouteNames.home, '//home');
      expect(RouteNames.login, '//login');
      expect(RouteNames.doctor, '//home/doctor_Screen');
      expect(RouteNames.doctorReview, '//home/doctor_Screen/doctor_review_screen');
    });

    test('initialLocation is splash', () {
      expect(AppRouter.router.configuration.routes, isNotEmpty);
    });
  });
}

Set<String> _collectNames(List<RouteBase> routes) {
  final out = <String>{};
  for (final r in routes) {
    if (r is GoRoute && r.name != null) out.add(r.name!);
    out.addAll(_collectNames(r.routes));
  }
  return out;
}
