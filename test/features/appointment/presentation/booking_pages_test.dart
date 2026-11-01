import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:dorakpattient/features/appointment/logic/booking_cubit.dart';
import 'package:dorakpattient/features/appointment/logic/booking_state.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/booking_confirmed_page.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/booking_date_time_page.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/booking_review_page.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/booking_specialty_doctor_page.dart';
import 'package:dorakpattient/features/appointment/presentation/widgets/booking_stepper.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_harness.dart';

class _MockBookingRepo extends Mock implements BookingRepository {}

class _MockAuthRepo extends Mock implements AuthenticationRepository {}

class _MockPrefs extends Mock implements SharedPref {}

class _FakeBookingCubit extends BookingCubit {
  _FakeBookingCubit(BookingState seed, BookingRepository repo)
      : super(bookingRepository: repo) {
    emit(seed);
  }

  @override
  Future<void> loadDays() async {}

  @override
  Future<void> loadSlots() async {}

  @override
  Future<void> loadPreview() async {}

  @override
  Future<void> confirm() async {}
}

class _FakeAuthCubit extends AuthCubit {
  _FakeAuthCubit(AuthState seed, AuthenticationRepository repo, SharedPref prefs)
      : super(authenticationRepository: repo, sharedPref: prefs) {
    emit(seed);
  }

  @override
  Future<void> loadCurrentUser() async {}
}

void main() {
  setUpAll(setUpTestHarness);

  late _MockBookingRepo bookingRepo;
  late _MockAuthRepo authRepo;
  late _MockPrefs prefs;

  setUp(() {
    silenceOverflowErrors();
    bookingRepo = _MockBookingRepo();
    authRepo = _MockAuthRepo();
    prefs = _MockPrefs();
  });

  AuthState _signedIn() => AuthState(
        user: UserResponse(
          token: 'Bearer t.o.k.e.n',
          patient: Patient(id: 1, name: 'أحمد', phone: '555123456'),
        ),
      );

  Future<void> pumpPage(
    WidgetTester tester,
    Widget page, {
    BookingState bookingState = const BookingState(),
  }) async {
    final cubit = _FakeBookingCubit(bookingState, bookingRepo);
    final authCubit = _FakeAuthCubit(_signedIn(), authRepo, prefs);
    addTearDown(() async {
      await cubit.close();
      await authCubit.close();
    });
    await pumpApp(
      tester,
      page,
      surfaceSize: const Size(412, 1800),
      providers: [
        BlocProvider<BookingCubit>.value(value: cubit),
        BlocProvider<AuthCubit>.value(value: authCubit),
      ],
    );
  }

  testWidgets('specialty-doctor page renders stepper on step 1',
      (tester) async {
    await pumpPage(tester, const BookingSpecialtyDoctorPage());
    final stepper =
        tester.widget<BookingStepper>(find.byType(BookingStepper));
    expect(stepper.current, BookingStep.specialtyDoctor);
  });

  testWidgets('date-time page renders stepper on step 2', (tester) async {
    final state = const BookingState(
      doctorId: 7,
      daysStatus: Status.success,
    );
    await pumpPage(tester, const BookingDateTimePage(), bookingState: state);
    final stepper =
        tester.widget<BookingStepper>(find.byType(BookingStepper));
    expect(stepper.current, BookingStep.dateTime);
  });

  testWidgets('review page renders stepper on step 3 (preview success)',
      (tester) async {
    final preview = AppointmentResponse(
      id: 999,
      bookingNumber: 'RSV-999',
      status: 'pending',
      dateLabel: 'الأحد 2 نوفمبر',
      timeLabel: '10:30 ص',
    );
    final state = BookingState(
      doctorId: 7,
      previewStatus: Status.success,
      preview: preview,
    );
    await pumpPage(tester, const BookingReviewPage(), bookingState: state);
    final stepper =
        tester.widget<BookingStepper>(find.byType(BookingStepper));
    expect(stepper.current, BookingStep.review);
  });

  testWidgets('confirmed page renders booking number when confirmed set',
      (tester) async {
    final confirmed = AppointmentResponse(
      id: 999,
      bookingNumber: 'RSV-999',
      status: 'pending',
      dateLabel: 'الأحد 2 نوفمبر',
      timeLabel: '10:30 ص',
    );
    final state = BookingState(
      doctorId: 7,
      confirmStatus: Status.success,
      confirmed: confirmed,
      booked: true,
    );
    await pumpPage(
      tester,
      const BookingConfirmedPage(),
      bookingState: state,
    );
    expect(
      find.textContaining('RSV-999', findRichText: true),
      findsWidgets,
    );
  });
}
