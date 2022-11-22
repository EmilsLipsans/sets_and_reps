import 'package:flutter/material.dart';
import 'package:gtk_flutter/pages/workout_create.dart';

class StartWorkoutDetailsRoute extends StatefulWidget {
  StartWorkoutDetailsRoute({super.key, required this.workoutID});

  final workoutID;

  State<StartWorkoutDetailsRoute> createState() =>
      StartWorkoutDetailsRouteState();
}

class StartWorkoutDetailsRouteState extends State<StartWorkoutDetailsRoute> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Exercise ($count/${widget.workoutID})'),
      ),
      body: Text(widget.workoutID),
    );
  }
}

class RecordWorkout extends StatefulWidget {
  const RecordWorkout({
    super.key,
    required this.exercises,
  });
  final List<Exrecises> exercises;
  @override
  State<RecordWorkout> createState() => _RecordWorkoutState();
}

class _RecordWorkoutState extends State<RecordWorkout> {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 40.0, bottom: 40.0, left: 20.0, right: 20.0),
      ),
    );
  }
}
