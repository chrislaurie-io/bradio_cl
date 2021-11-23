import 'package:bradio_cl/ui/player/player_page.dart';
import 'package:flutter/material.dart';


class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlayerPage(),
    );
  }
}
