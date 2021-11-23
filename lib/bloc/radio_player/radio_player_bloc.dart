import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bradio_cl/Services/stream_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

part 'radio_player_event.dart';
part 'radio_player_state.dart';

class RadioPlayerBloc extends Bloc<RadioPlayerEvent, RadioPlayerState> {
  final player = AudioPlayer();
  late final Timer _metadataTimer;

  String _title = '';
  String get title => _title;
  String _currentStation = '';
  String get currentStation => _currentStation;


  RadioPlayerBloc() : super(RadioPlayerInitial()) {
    _metadataTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) { 
      if(_metaDataChanged()) {
        add(MetaDataChangedEvent()); 
      }
    });

    on<PlayStreamEvent>((event, emit) async {
      if (_currentStation != event.stationName) {
        debugPrint('radioPlayerBloc.PlayStreamEevent=${event.stationName}');
        emit(RadioPlayerLoadingStream()); 
        _currentStation = event.stationName;
        _title = '';
        add(MetaDataChangedEvent());
        try {
          if(player.playing){
            await player.stop();
          }
          await player.setUrl(event.radioStreamUrl);
          await player.load();
          await player.play();
        } on Exception catch (e) {
          debugPrint('PlayStreamEvent :: ERROR :: $e');
          StreamService.removeStreamByName(event.stationName);
          _title = 'Error playing stream';
          add(RadioPlayerStreamLoadErrorEvent());
        } 

        emit(RadioPlayerPlayingStream());
      }
    });


    on<MetaDataChangedEvent>((event, emit){
      debugPrint('MetaDataChangedEvent.station=$_currentStation; title=$_title');
      emit(RadioPlayerWhatsOn(_currentStation, _title));
    });

    on<RadioPlayerStreamLoadErrorEvent>((event, emit){
      debugPrint('RadioPlayerStreamLoadErrorEvent');
      emit(RadioPlayerStreamLoadError());
    });

    on<PauseStreamEvent>((event, emit) async {
      debugPrint('RadioPlayerBloc.PauseStreamEvent');
      try {
        await player.pause();
        emit(RadioPlayerPaused());
      }  catch (e) {
        debugPrint('RadioPlayerBloc.PauseTreamEvent :: ERROR :: $e');
      }
    });


    on<ResumeStreamEvent>((event, emit) async {
      debugPrint('RadioPlayerBloc.ResumeStreamEvent');
      try {
        emit(RadioPlayerResumed());
        await player.play();  
      } catch (e) {
        debugPrint('radioPlayerBloc.ResumeStreamEvent :: ERROR :: $e');
      }
    });
  }

  @override
  Future<void> close() {
    _metadataTimer.cancel();
    return super.close();
  }

  bool _metaDataChanged() {
    if (!player.playing || player.processingState == ProcessingState.loading){
      return false;
    }
    var _titleNow = '';    
    if(player.playing && player.icyMetadata != null){
      _titleNow = player.icyMetadata?.info?.title ?? '';
    }
    if(_title != _titleNow){
      debugPrint('_metaDataChanged=$_titleNow');
      _title = _titleNow;
      // _metaData = _metaNow;
      return true;
    }
    return false;
  }


}
