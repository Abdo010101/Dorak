import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/status.dart';
import '../../../../data/repository/centers_repo.dart';
import '../../data/center_entity_mapper.dart';
import '../../data/mock/center_mock.dart';
import '../../domain/entities/center_entity.dart';
import 'doctors_at_center_state.dart';

/// `GET /patient/medical-centers/{id}/doctors` + specialty-chip filter.
///
/// Falls back to [CenterMock.sample] when the call fails.
class DoctorsAtCenterCubit extends Cubit<DoctorsAtCenterState> {
  DoctorsAtCenterCubit({required CentersRepository repo})
      : _repo = repo,
        super(const DoctorsAtCenterState());

  final CentersRepository _repo;
  int? _centerId;

  Future<void> load(int centerId) async {
    _centerId = centerId;
    await _fetch();
  }

  Future<void> setSpecialty(String key) async {
    emit(state.copyWith(selectedSpecialty: key));
    await _fetch();
  }

  Future<void> _fetch() async {
    final id = _centerId;
    if (id == null) return;
    emit(state.copyWith(status: Status.loading, clearError: true));
    final specId = int.tryParse(state.selectedSpecialty);
    final result = await _repo.doctorsAtCenter(id, specializationId: specId);
    if (result.data != null) {
      final data = result.data!;
      final doctors = CenterEntityMapper.fromDoctorsResponse(data);
      // Reuse the mock center scaffolding but swap in the doctor list.
      final mockCenter = CenterMock.sample();
      final enriched = CenterEntity(
        id: mockCenter.id,
        name: mockCenter.name,
        heroImageAsset: mockCenter.heroImageAsset,
        address: mockCenter.address,
        city: mockCenter.city,
        distanceKm: mockCenter.distanceKm,
        about: mockCenter.about,
        specialties: mockCenter.specialties,
        offers: mockCenter.offers,
        reviews: mockCenter.reviews,
        pinLabel: mockCenter.pinLabel,
        doctors: doctors,
      );
      emit(state.copyWith(status: Status.success, center: enriched));
      return;
    }
    emit(state.copyWith(
      status: Status.success,
      center: CenterMock.sample(),
      errorMessage: result.error?.message,
    ));
  }
}
