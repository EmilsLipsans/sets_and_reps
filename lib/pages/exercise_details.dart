import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseDetailsRoute extends StatefulWidget {
  ExerciseDetailsRoute({super.key, required this.message, required this.items});

  final message;
  final items;
  State<ExerciseDetailsRoute> createState() => ExerciseDetailsRouteState();
}

class ExerciseDetailsRouteState extends State<ExerciseDetailsRoute> {
  late String videoId =
      YoutubePlayer.convertUrlToId('${widget.message.message}') as String;
  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoId,
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  Widget build(BuildContext context) => YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
        ),
        builder: (context, player) => Scaffold(
          appBar: AppBar(
            title: Text('${widget.message.name}'),
          ),
          body: ListView(children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Center(
                child: Text(
                  'Video Example',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            player,
          ]),
        ),
      );
}
