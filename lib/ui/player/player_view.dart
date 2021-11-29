import 'package:bradio_cl/Model/StationStream/radio_stream.dart';
import 'package:bradio_cl/app_state/radio_player_state.dart';
import 'package:bradio_cl/core/enums/playing_state.dart';
// import 'package:bradio_cl/providers/radio_player/radio_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final _nowPlayingHeight = MediaQuery.of(context).size.height / 6;

    //Slightly irritating of changeNotifier is that you must call it differently depening on whether 
    //you are calling an method (not requiring 'listen to changes') or want a value that may change requiring to listen (the default)
    //Here I create to state varaiables one with listen capability and one without.
    //This is then passed down to other functions in this class
    //You don't need to do it this way. You can bass the build context around and then use that
    //to access your state directly: Provider.of<RadioPlayerState>(context)....
    var _state = Provider.of<RadioPlayerState>(context);
    var _stateNoListen = Provider.of<RadioPlayerState>(context, listen: false );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Player'),
        actions: [_pauseButton(_state, _stateNoListen)],
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _nowPlaying(_nowPlayingHeight, _state),
            Expanded( 
                  child: _state.isLoadingList
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _buildListView(_state, _stateNoListen)
              ),
          ],
        ),
      ),
    );
  }

  Widget _pauseButton(RadioPlayerState state, RadioPlayerState stateNoListen){
    if(state.playingState == PlayingState.playing){
      return IconButton(
        onPressed: () => stateNoListen.pausePlaying(), 
        icon: const Icon(FontAwesomeIcons.pause)
      ); 

    } else if(state.playingState == PlayingState.paused){
      return IconButton(
        onPressed: () => stateNoListen.startPlaying(), 
        icon: const Icon(FontAwesomeIcons.play)
      ); 
    }    
    return Container();    
  }

  Widget _nowPlaying(double playerHeight, RadioPlayerState state) {
    return SizedBox(
      height: playerHeight,
      child: Center(
        child: state.playingState == PlayingState.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Text('${state.station}${state.title.isNotEmpty ? ':\n\n' : ''}${state.title}')
      ),
    );
  }

  ListView _buildListView(RadioPlayerState state, RadioPlayerState stateNoListen) {
    return ListView.builder(
      itemCount: state.stationCount,
      itemBuilder: (context, index) {
        final RadioStream radioStream = state.stationList[index];
        bool isActive = radioStream.name == state.station;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: isActive ? Colors.purple.shade400 : Colors.grey, width: isActive ? 4 : 0),
          ),
          elevation: isActive ? 0 : 8,
          child: ListTile(
            onTap: (){
              stateNoListen.playStream(radioStream.name, radioStream.url);
            },
            title: Text(radioStream.name),
            subtitle: Text(radioStream.tags),
          ),
        );
      },
    );
  }

}
