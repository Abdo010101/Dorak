import 'package:flutter_bloc/flutter_bloc.dart';

/// Owns the current bottom-nav tab index for `MainShellPage`.
/// Replaces `MainScreenController.currentIndex` without the ChangeNotifier
/// baggage. The UI widget still calls `MainShellPage` setState alongside
/// this emission until the shell wires `BlocBuilder` directly.
class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  void setIndex(int index) {
    if (index == state) return;
    emit(index);
  }
}
