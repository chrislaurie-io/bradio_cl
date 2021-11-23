import 'package:bradio_cl/Model/StationStream/radio_stream.dart';
import 'package:bradio_cl/bloc/player_list/player_list_bloc.dart';
import 'package:bradio_cl/bloc/radio_player/radio_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final _nowPlayingHeight = MediaQuery.of(context).size.height / 6;
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Amazing Radio Player'),
        actions: [_pauseButton()],
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _nowPlaying(_nowPlayingHeight),
            Expanded(
              child: BlocBuilder<PlayerListBloc, PlayerListState>(
                builder: (context, state) {
                  if (state is PlayerListLoaded) {
                    return _buildListView(state.stationCount, state.radioStreams, state.playingStation);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pauseButton(){
    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      builder: (context, state){
        debugPrint('PlayerVIew._pauseButton.${state.runtimeType}');
        if(state is RadioPlayerPlayingStream  || state is RadioPlayerWhatsOn || state is RadioPlayerResumed){
          return IconButton(
            onPressed: () => context.read<RadioPlayerBloc>().add(PauseStreamEvent()), 
            icon: const Icon(FontAwesomeIcons.pause)
          ); 
        } else if (state is RadioPlayerPaused){
          return IconButton(
            onPressed: () => context.read<RadioPlayerBloc>().add(ResumeStreamEvent()), 
            icon: const Icon(FontAwesomeIcons.play)
          ); 
        }
        return Container();
      });
    
  }

  Widget _nowPlaying(double playerHeight) {
    return SizedBox(
      height: playerHeight,
      child: Center(
        child: BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
          builder: (context, state) {
            // if(state is RadioPlayerWhatsOn){
              debugPrint('_nowPlaying.state.${state.runtimeType}');
            // }
            // return Text('$_stationName${_title.isNotEmpty ? ':\n\n' : ''}$_title');
            var bloc = context.read<RadioPlayerBloc>();
            if(state is RadioPlayerLoadingStream){
              return const CircularProgressIndicator();
            }
            return Text('${bloc.currentStation}${bloc.title.isNotEmpty ? ':\n\n' : ''}${bloc.title}');
          },
        )
      ),
    );
  }

  ListView _buildListView(
    int stationCount,
    List<RadioStream> radioStreams,
    String playingStation,
  ) {
    return ListView.builder(
      itemCount: stationCount,
      itemBuilder: (context, index) {
        final RadioStream radioStream = radioStreams[index];
        bool isActive = radioStream.name == playingStation;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: isActive ? Colors.purple.shade400 : Colors.grey, width: isActive ? 4 : 0),
          ),
          elevation: isActive ? 0 : 8,
          child: ListTile(
            onTap: (){
              context.read<RadioPlayerBloc>().add(PlayStreamEvent(radioStream.urlResolved, radioStream.name));
            },
            title: Text(radioStream.name),
            subtitle: Text(radioStream.tags),
          ),
        );
      },
    );
  }
}
