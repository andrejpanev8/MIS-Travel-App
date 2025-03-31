part of 'home_screen_bloc.dart';

sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class ToggleActiveScreen extends HomeScreenEvent {
  final bool ridesActive;

  const ToggleActiveScreen({this.ridesActive = true});
}
