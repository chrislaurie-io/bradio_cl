// import 'package:bradio_cl/providers/radio_player/radio_player_bloc.dart';
import 'package:bradio_cl/app_state/radio_player_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_app.dart';

void main() async {
  runApp(
    //instantiate the RadioPlayerState class which holds the state for the entire time the app is running
    //Everything in this state class is now universally available wherever you have context.
     ChangeNotifierProvider<RadioPlayerState>(
       create: (_) => RadioPlayerState(),
       child: const CounterApp()
    )
  );
}
