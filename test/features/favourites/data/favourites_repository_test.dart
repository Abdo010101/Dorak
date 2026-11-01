import 'package:dorakpattient/data/models/response/favourite_response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements FavouritesClient {}

void main() {
  installRepoHarness();
  late _MockClient client;
  late FavouritesRepository repo;

  setUp(() {
    client = _MockClient();
    repo = FavouritesRepository(client: client);
  });

  test('list(doctor) success — parses list', () async {
    final fx = jsonFixture('favourites/doctors_list.json');
    final items = (fx['data'] as List)
        .map((e) => FavouriteItem.fromJson(e as Map<String, dynamic>))
        .toList();
    when(() => client.list(any())).thenAnswer((_) async => items);

    final result = await repo.list(FavouriteType.doctor);

    expect(result.error, isNull);
    expect(result.data, hasLength(2));
    verify(() => client.list('doctor')).called(1);
  });

  test('add(doctor, id) delegates to addDoctor', () async {
    when(() => client.addDoctor(any())).thenAnswer((_) async {});

    final result = await repo.add(FavouriteType.doctor, 7);

    expect(result.error, isNull);
    verify(() => client.addDoctor(7)).called(1);
  });

  test('remove(medicalCenter, id) delegates to removeMedicalCenter', () async {
    when(() => client.removeMedicalCenter(any())).thenAnswer((_) async {});

    final result = await repo.remove(FavouriteType.medicalCenter, 3);

    expect(result.error, isNull);
    verify(() => client.removeMedicalCenter(3)).called(1);
  });
}
