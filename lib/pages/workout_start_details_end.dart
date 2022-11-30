import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:provider/provider.dart';

class FinishWorkoutDetailsRoute extends StatelessWidget {
  const FinishWorkoutDetailsRoute(
      {super.key,
      required this.workout,
      required this.workoutExercises,
      required this.recordedWorkout});
  final workout;
  final workoutExercises;
  final recordedWorkout;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finish ${workout.name}'),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: FinishWorkoutPage(
                workoutExercises: workoutExercises,
                recordedWorkout: recordedWorkout,
                workout: workout,
                recordWorkout: (String workoutID, List recordList) =>
                    appState.recordWorkout(workoutID, recordList),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FinishWorkoutPage extends StatefulWidget {
  const FinishWorkoutPage({
    super.key,
    required this.workoutExercises,
    required this.recordedWorkout,
    required this.recordWorkout,
    required this.workout,
  });
  final workoutExercises;
  final recordedWorkout;
  final workout;
  final FutureOr<void> Function(String workoutID, List recordList)
      recordWorkout;
  @override
  State<FinishWorkoutPage> createState() => _FinishWorkoutPageState();
}

class _FinishWorkoutPageState extends State<FinishWorkoutPage> {
  List formatData() {
    List formatedWorkoutList = [];
    List sets = [];
    for (var exercise in widget.workoutExercises) {
      for (var record in widget
          .recordedWorkout[widget.workoutExercises.indexOf(exercise)]
          .recordedExercisesList) {
        sets.add({'weight': record.weight, 'reps': record.reps});
      }
      formatedWorkoutList
          .add({'exerciseID': exercise.docID, 'sets': List.from(sets)});
      sets.clear();
    }
    return formatedWorkoutList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 15.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: ListView(
                children: <Widget>[
                  for (var exercise in widget.workoutExercises)
                    Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2,
                          color: Color.fromRGBO(68, 138, 255, 1),
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.create_rounded,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(
                                          context,
                                          widget.workoutExercises
                                              .indexOf(exercise));
                                    }),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "${exercise.name}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            for (var record in widget
                                .recordedWorkout[
                                    widget.workoutExercises.indexOf(exercise)]
                                .recordedExercisesList)
                              Card(
                                clipBehavior: Clip.hardEdge,
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Text(
                                            "${widget.recordedWorkout[widget.workoutExercises.indexOf(exercise)].recordedExercisesList.indexOf(record) + 1}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                        "${record.weight} kgs",
                                        textAlign: TextAlign.right,
                                      )),
                                      Expanded(
                                          child: Text(
                                        "${record.reps} reps",
                                        textAlign: TextAlign.right,
                                      )),
                                    ],
                                  ),
                                  tileColor: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        tileColor: Color.fromRGBO(68, 138, 255, 0.6),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: MaterialButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  await widget.recordWorkout(
                      widget.workout.docID, formatData());
                },
                height: 50,
                minWidth: 300,
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
