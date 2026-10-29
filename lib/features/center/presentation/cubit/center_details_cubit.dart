import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/status.dart';
import '../../data/mock/center_mock.dart';
import 'center_details_state.dart';

/// Static-mock cubit until `getMedicalCenters` endpoint lands.
class CenterDetailsCubit extends Cubit<CenterDetailsState> {
  CenterDetailsCubit() : super(const CenterDetailsState());

  Future<void> load(int centerId) async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 120));
    emit(state.copyWith(status: Status.success, center: CenterMock.sample()));
  }
}
