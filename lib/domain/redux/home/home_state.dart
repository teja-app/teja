// lib/domain/redux/home/home_state.dart

class HomeState {
  final DateTime? selectedDate;

  HomeState({this.selectedDate});

  HomeState copyWith({DateTime? selectedDate}) {
    return HomeState(
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  factory HomeState.initialState() {
    return HomeState(
      selectedDate: DateTime.now(),
    );
  }
}
