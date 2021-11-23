import 'package:bradio_cl/bloc/player_list/player_list_bloc.dart';
import 'package:bradio_cl/bloc/radio_player/radio_player_bloc.dart';
import 'package:bradio_cl/ui/player/player_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RadioPlayerBloc>(
          create: (_) => RadioPlayerBloc(),
        ),

        BlocProvider<PlayerListBloc>(
          create: (context) {
            final bloc = PlayerListBloc(BlocProvider.of<RadioPlayerBloc>(context));
            bloc.add(LoadStationStreamsEvent());
            return bloc;
          },
        ),
      ],
      child:  const PlayerView(),
    );
  }
}
