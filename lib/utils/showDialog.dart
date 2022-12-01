import 'package:flutter/material.dart';
import 'package:gtk_flutter/pages/workout_start.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

showExerciseDetails(context, workout) {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );
  const List<String> items = [
    'Abs',
    'Back',
    'Biceps',
    'Calves',
    'Cardio',
    'Chest',
    'Forearms',
    'Full Body',
    'Glutes',
    'Hamstrings',
    'Quads',
    'Triceps',
    'Other',
  ];
  return showDialog(
      useSafeArea: true,
      context: context,
      builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            content: Builder(
              builder: (context) {
                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                var height = MediaQuery.of(context).size.height;
                var width = MediaQuery.of(context).size.width;
                return Container(
                  height: height / 1.5,
                  width: width / 1.5,
                  child: Column(
                    children: [
                      Text('${workout.name}'),
                      SizedBox(height: 5),
                      const Divider(
                        color: Colors.grey,
                        height: 20,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      SizedBox(height: 5),
                      workout.description.length != 0
                          ? Text('${workout.description}')
                          : Text('No description added'),
                      SizedBox(height: 5),
                      const Divider(
                        color: Colors.grey,
                        height: 20,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Category: '),
                          Text('${items[workout.category - 1]}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Spacer(),
                      Text('Video Example',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      YoutubePlayer(
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(isExpanded: true),
                        ],
                        controller: _controller,
                        showVideoProgressIndicator: true,
                      ),
                    ],
                  ),
                );
              },
            ),
          ));
}
