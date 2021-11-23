part of 'radio_player_bloc.dart';

@immutable
abstract class RadioPlayerState {}

class RadioPlayerInitial extends RadioPlayerState {}

class RadioPlayerLoadingStream extends RadioPlayerState {

}


class RadioPlayerWhatsOn extends RadioPlayerState {
  final String stationName;
  final String nowPlaying;
  RadioPlayerWhatsOn(this.stationName, this.nowPlaying);
}

class RadioPlayerPlayingStream extends RadioPlayerState {}
class RadioPlayerPaused extends RadioPlayerState {}
class RadioPlayerResumed extends RadioPlayerState {}
class RadioPlayerStreamLoadError extends RadioPlayerState {}



