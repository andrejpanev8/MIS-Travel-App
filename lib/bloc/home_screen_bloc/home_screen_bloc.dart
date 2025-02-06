import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<HomeScreenEvent>((event, emit) async {
      if (event is ToggleActiveScreen) {
        event.ridesActive ? emit(RidesActive()) : emit(DeliveriesActive());
      }
    });
  }
}
