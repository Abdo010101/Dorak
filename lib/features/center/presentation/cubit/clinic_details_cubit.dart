import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/status.dart';
import '../../data/mock/center_mock.dart';
import 'clinic_details_state.dart';

class ClinicDetailsCubit extends Cubit<ClinicDetailsState> {
  ClinicDetailsCubit() : super(const ClinicDetailsState());

  Future<void> load(int clinicId) async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 120));
    emit(state.copyWith(
      status: Status.success,
      clinic: CenterMock.sampleClinic(),
    ));
  }
}
