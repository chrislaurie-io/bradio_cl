import 'dart:async';

import 'package:bradio_cl/Model/StationStream/radio_stream.dart';
import 'package:bradio_cl/Services/stream_service.dart';
import 'package:bradio_cl/core/enums/playing_state.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


//This is the state manager class for the radioplayer page.
class RadioPlayerState extends ChangeNotifier{


  late final Timer _whatsonTimer;

  RadioPlayerState() {
    _init();
    _whatsonTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) { 
      _getWhatson();
    });

  }

  //We can create getters against any lower level service directly
  //There is no need to keep a copy of the streamlist here
  List<RadioStream> get stationList => StreamService.streamList;
  int get stationCount => StreamService.streamList.length;
  bool get isLoadingList => StreamService.isLoading;

  PlayingState _playingState = PlayingState.none;
  PlayingState get playingState => _playingState;

  String _station = 'No station selected';
  String get station => _station;

  String _title = '';
  String get title => _title;

  final _player = AudioPlayer();

  @override
  void dispose() {
    debugPrint('RadioPlayerState.dispose');
    super.dispose();
    _whatsonTimer.cancel();
  }


  void _init() async {
    _setPlayingState(PlayingState.loading);
    notifyListeners();
    await StreamService.getStreams();
    _setPlayingState(PlayingState.none);
  }

  //These methods looks very similar to the bloc 
  //There is no need for events that emit states
  //The properties of this class is the state and is directly available

  void _getWhatson() {
    var _what = '';
    if(_player.playing && _player.icyMetadata != null){
      _what = _player.icyMetadata?.info?.title ?? '';
    }
    if(_what != _title){
      _title = _what;
      debugPrint('RadioPlayerState._getWhatson.changed=$_title');
      notifyListeners();
    }
  }

  Future <void> playStream(String newStation, String url) async {
    if(newStation == _station) {
      return;
    }
    debugPrint('RadioPlayerState.playStream=$newStation');
    _station = newStation;
    _title = '';
    _setPlayingState(PlayingState.loading); //contains a notifyListeners call
    try {
      if(_player.playing) {
        await _player.stop();
      }
      await _player.setUrl(url);
      await _player.load();
      await startPlaying();
    } catch (e) {
      debugPrint('RadioPlayerState.playStream :: ERROR :: $e');
      _station = 'Error: Cannot play $newStation';
      StreamService.removeStreamByName(newStation);
      _setPlayingState(PlayingState.none);
    }
  }

  Future <void> startPlaying() async {

    if(!_player.playing){
      try {
        debugPrint('RadioPlayerState.startPlaying.state=${_player.playerState}');
        _setPlayingState(PlayingState.playing);
        await _player.play();
      } catch (e) {
        debugPrint('RadioPlayerState.startPlaying :: ERROR :: $e');
        _setPlayingState(PlayingState.none);
        _station = 'Error trying to play $station';
      }
    }
  }

  Future <void> pausePlaying() async {
    if(_player.playing){
      try {
        _setPlayingState(PlayingState.paused);
        await _player.pause();
        debugPrint('RadioPlayerState.pausePlaying');
      }  catch (e) {
        debugPrint('RadioPlayerState.pausePlaying :: ERROR :: $e');
        _setPlayingState(PlayingState.none);
      }
    }
  }

  void _setPlayingState(PlayingState newState){
    _playingState = newState;
    notifyListeners();
  }

}
