part of 'player_list_bloc.dart';

@immutable
abstract class PlayerListState {}

class PlayerListInitial extends PlayerListState {}

class PlayerListLoading extends PlayerListState {}

class PlayerListLoadingFailure extends PlayerListState {}

class PlayerListLoaded extends PlayerListState {
  final List<RadioStream> radioStreams;
  final int stationCount;
  final String playingStation;

  PlayerListLoaded({
    required this.radioStreams,
    required this.stationCount,
    required this.playingStation
  });
}


