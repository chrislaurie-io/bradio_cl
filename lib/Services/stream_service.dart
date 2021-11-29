
import 'dart:convert';

import 'package:bradio_cl/Model/StationStream/radio_stream.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StreamService{
  static final List<RadioStream> _streamList = [];

  static bool isLoading = false;
  static List<RadioStream> get streamList => _streamList;

  static Future<int> getStreams() async {
    isLoading = true;
    const url ='https://nl1.api.radio-browser.info/json/stations/bycountrycodeexact/NL?hidebroken=true&order=bitrate';
    try {
      var response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        var utf = utf8.decode(response.bodyBytes);
        var jsonList = jsonDecode(utf);
        for(var stream in jsonList){
          var radioStream = RadioStream.fromJson(stream);
          int idx = _streamList.indexWhere((element) => element.name == radioStream.name);
          if(idx < 0){
            _streamList.add(radioStream);
          } else if (_streamList[idx].bitrate < radioStream.bitrate){
            _streamList[idx] = radioStream;
          }
        }
        _streamList.sort((a,b)=> a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }
   
    } catch (e) {
      debugPrint('getStrteams::ERROR:: $e');
    }
    debugPrint('getSTreams.done.streamCount=${_streamList.length}');
    isLoading = false;
    return _streamList.length;
  }

  static void removeStreamByName(String stationName) {
    _streamList.removeWhere((element) =>  element.name == stationName);
    debugPrint('StreamService.removeStreamByName($stationName).idx=${_streamList.indexWhere((element) =>  element.name == stationName)}');
  }


 }