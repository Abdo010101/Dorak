import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/status.dart';
import '../../data/mock/center_mock.dart';
import 'doctors_at_center_state.dart';

class DoctorsAtCenterCubit extends Cubit<DoctorsAtCenterState> {
  DoctorsAtCenterCubit() : super(const DoctorsAtCenterState());

  Future<void> load(int centerId) async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 120));
    emit(state.copyWith(status: Status.success, center: CenterMock.sample()));
  }

  void setSpecialty(String key) =>
      emit(state.copyWith(selectedSpecialty: key));
}
