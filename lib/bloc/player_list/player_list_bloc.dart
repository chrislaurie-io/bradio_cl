import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bradio_cl/Model/StationStream/radio_stream.dart';
import 'package:bradio_cl/Services/stream_service.dart';
import 'package:bradio_cl/bloc/radio_player/radio_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'player_list_event.dart';
part 'player_list_state.dart';

class PlayerListBloc extends Bloc<PlayerListEvent, PlayerListState> {

  RadioPlayerBloc radioPlayerBloc;
  late StreamSubscription streamSubscription;
   String _currentStation = '';
   String get currentStation => _currentStation;
 
  PlayerListBloc(this.radioPlayerBloc) : super(PlayerListInitial()) {
    

    int results = 0;
    streamSubscription = radioPlayerBloc.stream.listen((state){
      if(state is RadioPlayerStreamLoadError){
        debugPrint('playerListBloc.radioPlayerBloc.listener.RadioPlayerStreamLoadError');
        add(LoadStationStreamsEvent());
      } else if(state is RadioPlayerWhatsOn){
        _currentStation = state.stationName;
        debugPrint('playerListBloc.radioPlayerBloc.listener.RadioPlayerWhatsOn=$_currentStation');
        add(LoadStationStreamsEvent());
      }
    });

    on<LoadStationStreamsEvent>((event, emit) async {
      debugPrint('playerListBloc.LoadStreamsEvent');
      emit(PlayerListLoading());
      
      if (results <= 0){
        results = await StreamService.getStreams();
      }
      
      emit(PlayerListLoaded(
        radioStreams: StreamService.streamList,
        stationCount: StreamService.streamList.length,
        playingStation: _currentStation
      ));
    });

    
  }
}
