part of 'radio_player_bloc.dart';

@immutable
abstract class RadioPlayerEvent {}

class PlayStreamEvent extends RadioPlayerEvent {
  final String stationName;
  final String radioStreamUrl;

  PlayStreamEvent(this.radioStreamUrl, this.stationName);
}

class PauseStreamEvent extends RadioPlayerEvent {}
class ResumeStreamEvent extends RadioPlayerEvent {}

class StopStreamEvent extends RadioPlayerEvent {}
class MetaDataChangedEvent extends RadioPlayerEvent {}
class RadioPlayerStreamLoadErrorEvent extends RadioPlayerEvent {}



