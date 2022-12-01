import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseDetailsRoute extends StatefulWidget {
  ExerciseDetailsRoute({super.key, required this.workout, required this.items});

  final workout;
  final items;
  State<ExerciseDetailsRoute> createState() => ExerciseDetailsRouteState();
}

class ExerciseDetailsRouteState extends State<ExerciseDetailsRoute> {
  late String videoId = YoutubePlayer.convertUrlToId(
          'https://www.youtube.com/watch?v=GPDrZwxi338&ab_channel=TrashTaste')
      as String;
  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoId,
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  Widget build(BuildContext context) => YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
        ),
        builder: (context, player) => Scaffold(
          appBar: AppBar(
            title: Text('${widget.workout.name}'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurpleAccent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text('Description', style: TextStyle(fontSize: 18)),
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: Text(
                                '${widget.workout.description}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Row(
                              children: [
                                Text('Category: ',
                                    style: TextStyle(fontSize: 18)),
                                Text('${widget.workout.category}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
