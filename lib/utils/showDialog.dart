import 'package:flutter/material.dart';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';

showExerciseDetails(context, message, items) {
  final _controller = YoutubePlayerController(
    params: YoutubePlayerParams(
      mute: false,
      showControls: true,
      showFullscreenButton: true,
    ),
  );
  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        content: Builder(builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
            height: height / 1.5,
            width: width / 1.5,
            child: YoutubePlayerScaffold(
              controller: _controller,
              aspectRatio: 16 / 9,
              builder: (context, player) {
                return Column(
                  children: [
                    player,
                    Text('Youtube Player'),
                  ],
                );
              },
            ),
          );
        })),
  );
}
