import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/all_offers_response.dart';
import 'package:dorakpattient/data/models/response/base/base_response.dart';
import 'package:dorakpattient/data/models/response/offer_response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/offers/logic/offers_cubit.dart';
import 'package:dorakpattient/features/offers/logic/offers_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockOffersRepository extends Mock implements OffersRepository {}

void main() {
  late _MockOffersRepository repo;

  setUp(() {
    repo = _MockOffersRepository();
    registerFallbackValue(<String, dynamic>{});
  });

  group('OffersCubit', () {
    blocTest<OffersCubit, OffersState>(
      'setQuery emits new query',
      build: () => OffersCubit(offersRepository: repo),
      act: (c) => c.setQuery('skin'),
      expect: () => const [OffersState(query: 'skin')],
    );

    blocTest<OffersCubit, OffersState>(
      'loadFirstPage success replaces offers',
      setUp: () {
        final body = AllOffersResponse(
          minPrice: '10',
          maxPrice: '200',
          offers: BaseResponse<List<OfferResponse>>()..data = <OfferResponse>[],
        );
        when(() => repo.getAllOffers(any(), pageKey: any(named: 'pageKey')))
            .thenAnswer((_) async => BaseModel<AllOffersResponse>(data: body));
      },
      build: () => OffersCubit(offersRepository: repo),
      act: (c) => c.loadFirstPage(),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.minPrice, '10');
        expect(c.state.maxPrice, '200');
      },
    );
  });
}
