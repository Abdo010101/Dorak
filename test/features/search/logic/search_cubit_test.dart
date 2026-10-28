import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/search/logic/search_cubit.dart';
import 'package:dorakpattient/features/search/logic/search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSearchRepo extends Mock implements DoctorsSearchResultRepository {}

void main() {
  late _MockSearchRepo repo;

  setUp(() {
    repo = _MockSearchRepo();
    registerFallbackValue(<String, dynamic>{});
  });

  group('SearchCubit', () {
    blocTest<SearchCubit, SearchState>(
      'setFilter / clearFilters mutate map',
      build: () => SearchCubit(
        searchResultRepository: repo,
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
        when(() => repo.getDoctors(any(), any())).thenAnswer(
          (_) async =>
              BaseModel<SearchResultResponse>(data: SearchResultResponse()),
        );
      },
      build: () => SearchCubit(
        searchResultRepository: repo,
        debounce: const Duration(seconds: 10),
      ),
      seed: () => const SearchState(query: 'skin'),
      act: (c) => c.search(),
      verify: (c) => expect(c.state.status, Status.success),
    );
  });
}
