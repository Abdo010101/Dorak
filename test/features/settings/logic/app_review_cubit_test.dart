import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/doctor_profile_response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/settings/logic/app_review_cubit.dart';
import 'package:dorakpattient/features/settings/logic/app_review_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRateRepository extends Mock implements RateRepository {}

void main() {
  late _MockRateRepository repo;

  setUp(() {
    repo = _MockRateRepository();
  });

  group('AppReviewCubit', () {
    blocTest<AppReviewCubit, AppReviewState>(
      'setRating emits new rating',
      build: () => AppReviewCubit(rateRepository: repo),
      act: (c) => c.setRating(4),
      expect: () => const [AppReviewState(rating: 4)],
    );

    blocTest<AppReviewCubit, AppReviewState>(
      'submit without rating emits failure',
      build: () => AppReviewCubit(rateRepository: repo),
      act: (c) => c.submit(),
      expect: () => const [
        AppReviewState(
          status: Status.failure,
          errorMessage: 'rating_required',
        ),
      ],
    );

    blocTest<AppReviewCubit, AppReviewState>(
      'submit with rating emits loading then success',
      setUp: () {
        when(() => repo.doctorRate(any())).thenAnswer(
          (_) async => BaseModel<Ratings>(data: Ratings()),
        );
      },
      build: () => AppReviewCubit(rateRepository: repo),
      seed: () => const AppReviewState(rating: 5, comment: 'ok'),
      act: (c) => c.submit(),
      expect: () => [
        const AppReviewState(
          rating: 5,
          comment: 'ok',
          status: Status.loading,
        ),
        const AppReviewState(
          rating: 5,
          comment: 'ok',
          status: Status.success,
          submitted: true,
        ),
      ],
    );

    blocTest<AppReviewCubit, AppReviewState>(
      'reset returns to initial',
      build: () => AppReviewCubit(rateRepository: repo),
      seed: () => const AppReviewState(rating: 3, comment: 'x'),
      act: (c) => c.reset(),
      expect: () => const [AppReviewState()],
    );
  });
}
