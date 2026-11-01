import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/discovery_response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/discovery_repo.dart';
import 'package:dorakpattient/features/search/logic/search_cubit.dart';
import 'package:dorakpattient/features/search/logic/search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDiscoveryRepo extends Mock implements DiscoveryRepository {}

void main() {
  late _MockDiscoveryRepo repo;

  setUp(() {
    repo = _MockDiscoveryRepo();
    registerFallbackValue(<String, dynamic>{});
  });

  group('SearchCubit', () {
    blocTest<SearchCubit, SearchState>(
      'setFilter / clearFilters mutate map',
      build: () => SearchCubit(
        discoveryRepository: repo,
        debounce: const Duration(seconds: 10),
      ),
      act: (c) {
        c.setFilter('city_id', 5);
        c.setFilter('gender', 'male');
        c.setFilter('gender', null);
      },
      verify: (c) {
        expect(c.state.filters, {'city_id': 5});
      },
    );

    blocTest<SearchCubit, SearchState>(
      'search success emits result',
      setUp: () {
        when(() => repo.search(
              search: any(named: 'search'),
              lat: any(named: 'lat'),
              lng: any(named: 'lng'),
              specializationId: any(named: 'specializationId'),
              perPage: any(named: 'perPage'),
            )).thenAnswer(
          (_) async => BaseModel<SearchResponse>(data: SearchResponse()),
        );
      },
      build: () => SearchCubit(
        discoveryRepository: repo,
        debounce: const Duration(seconds: 10),
      ),
      seed: () => const SearchState(query: 'skin'),
      act: (c) => c.search(),
      verify: (c) => expect(c.state.status, Status.success),
    );
  });
}
