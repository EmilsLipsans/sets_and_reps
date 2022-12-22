import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  'Shoulders',
  'Triceps',
  'Other',
];
showExerciseDetails(context, exercise) {
  String? videoId;
  videoId = YoutubePlayer.convertUrlToId("${exercise.url}");
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '$videoId',
    flags: YoutubePlayerFlags(
      hideThumbnail: true,
      autoPlay: false,
      mute: false,
    ),
  );

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
                      Text('${exercise.name}'),
                      SizedBox(height: 5),
                      const Divider(
                        color: Colors.grey,
                        height: 20,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          child: exercise.description.length != 0
                              ? Text('${exercise.description}')
                              : Text('No description added'),
                        ),
                      ),
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
                          Text('${items[exercise.category - 1]}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Spacer(),
                      videoId != null
                          ? Text('',
                              style: TextStyle(fontWeight: FontWeight.bold))
                          : Text('No Video Example',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      videoId != null
                          ? YoutubePlayer(
                              bottomActions: [
                                CurrentPosition(),
                                ProgressBar(isExpanded: true),
                              ],
                              controller: _controller,
                              showVideoProgressIndicator: true,
                            )
                          : SizedBox(height: 20),
                      SizedBox(height: 5),
                      MaterialButton(
                        color: Color.fromARGB(255, 230, 230, 230),
                        child: const Text("Close"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ));
}

showWorkoutDetails(context, workout, exerciseList) {
  int count = 0;
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
                      Expanded(
                        child: Column(children: [
                          Text('${workout.name}'),
                          SizedBox(height: 5),
                          const Divider(
                            color: Colors.grey,
                            height: 20,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                          ),
                        ]),
                      ),
                      Expanded(
                        flex: 6,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            for (var exercise in exerciseList)
                              Card(
                                clipBehavior: Clip.hardEdge,
                                child: SizedBox(
                                  height: 42,
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color:
                                              Color.fromRGBO(68, 138, 255, 1)),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, bottom: 14),
                                            child: Text(
                                              "${count++ + 1}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 14,
                                                left: 10.0,
                                              ),
                                              child: Text(
                                                "${exercise.name}",
                                                textAlign: TextAlign.left,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        color: Color.fromARGB(255, 230, 230, 230),
                        child: const Text("Close"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ));
}
