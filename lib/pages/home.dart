import 'package:flutter/material.dart';
import 'package:gtk_flutter/pages/exercise_create.dart';
import 'package:gtk_flutter/pages/workout_start.dart';

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StartWorkoutRoute()),
              );
            },
            tooltip: 'Start Workout',
            label: const Text('Start'),
            icon: const Icon(Icons.play_circle_outlined)),
        body: Center(child: Text('Home', style: TextStyle(fontSize: 60))),
      );
}
