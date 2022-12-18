import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/workout_start.dart';
import 'package:gtk_flutter/utils/nameLists.dart';
import 'package:jiffy/jiffy.dart';
import 'package:gtk_flutter/pages/workouts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: WorkoutRecordPage(
                recordedWorkouts: appState.latestWorkoutRecordList,
                workouts: appState.workoutList,
                exercises: appState.exreciseList,
                lastWorkout: appState.finalWorkout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutRecord {
  WorkoutRecord({
    required this.workoutID,
    required this.recordedExercises,
    required this.time,
  });
  final String workoutID;
  final int time;
  final List recordedExercises;
}

class WorkoutRecordPage extends StatefulWidget {
  const WorkoutRecordPage({
    super.key,
    required this.recordedWorkouts,
    required this.workouts,
    required this.exercises,
    required this.lastWorkout,
  });
  final List<WorkoutRecord> recordedWorkouts;
  final List<Workout> workouts;
  final exercises;
  final lastWorkout;

  String lastWorkoutName() {
    for (var value in workouts) {
      if (lastWorkout.workoutID == value.docID) return value.name;
    }
    return 'Deleted';
  }

  @override
  State<WorkoutRecordPage> createState() => _WorkoutRecordPageState();
}

class _WorkoutRecordPageState extends State<WorkoutRecordPage> {
  void newWorkoutAdded() {
    setState(() {
      exercisePos = 0;
    });
  }

  void updateUpperCard() {
    setState(() {
      if (widget.lastWorkout.workoutID != '') {
        recordTime =
            DateTime.fromMillisecondsSinceEpoch(widget.lastWorkout.time);
        exerciseDataList = exerciseData(exercisePos);
        exerciseCount = widget.lastWorkout.recordedExercises.length;
        if (exercisePos > exerciseCount - 1) exercisePos = 0;
        for (var value in widget.exercises) {
          if (value.docID == exerciseName) {
            exerciseName = value.name;
            break;
          }
          if (widget.exercises.indexOf(value) == widget.exercises.length - 1)
            exerciseName = '[Deleted]';
        }
      }
      timeAgo = Jiffy(recordTime).fromNow();
      if (widget.lastWorkout.workoutID != '')
        lastWorkoutName = widget.lastWorkoutName();
    });
  }

  void updateCardList() {
    setState(() {
      nameList = workoutNames(widget.recordedWorkouts, widget.workouts);
    });
  }

  List exerciseData(int exercisePos) {
    List data = [];
    for (var workout in widget.lastWorkout.recordedExercises)
      if (exercisePos ==
          widget.lastWorkout.recordedExercises.indexOf(workout)) {
        data.add(workout);
        exerciseName = workout['exerciseID'] as String;
      }
    return data;
  }

  List nameList = [];
  List exerciseDataList = [];
  var recordTime = new DateTime.now();
  String lastWorkoutName = 'No completed workouts';
  var timeAgo = 'No data';
  var exerciseName = '';
  int exercisePos = 0;
  int exerciseCount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: upperCard(),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              textAlign: TextAlign.left,
              'Last 14 Days',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Expanded(
              child: exerciseCardList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget upperCard() {
    updateUpperCard();
    return widget.lastWorkout.workoutID != ''
        ? Card(
            elevation: 0,
            color: Color.fromRGBO(68, 138, 255, 0.6),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                color: Color.fromRGBO(68, 138, 255, 1),
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 10.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Text(
                    '$lastWorkoutName ' +
                        '(${exercisePos + 1}/'
                            '$exerciseCount)',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$exerciseName',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      flex: 2,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          for (var workout in exerciseDataList)
                            for (var set in workout['sets'])
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
                                                left: 20.0,
                                                right: 20.0,
                                                bottom: 14),
                                            child: Text(
                                              "${workout['sets'].indexOf(set) + 1}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 14),
                                              child: Text(
                                                "${set['weight']} kgs",
                                                textAlign: TextAlign.right,
                                              )),
                                        ),
                                        Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 14),
                                              child: Text(
                                                "${set['reps']} reps",
                                                textAlign: TextAlign.right,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Ink(
                            height: 40,
                            width: 40,
                            decoration: const ShapeDecoration(
                              color: Colors.blue,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                                iconSize: 20,
                                icon: const Icon(Icons.arrow_back_ios_rounded),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    if (exercisePos > 0) {
                                      exercisePos--;
                                    }
                                  });
                                }),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Ink(
                            height: 40,
                            width: 40,
                            decoration: const ShapeDecoration(
                              color: Colors.blue,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  if (exercisePos < exerciseCount - 1) {
                                    exercisePos++;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '$timeAgo',
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Card(
            elevation: 0,
            color: Color.fromRGBO(68, 138, 255, 0.6),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                color: Color.fromRGBO(68, 138, 255, 1),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 10.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Text('$lastWorkoutName',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Spacer(),
                  Row(),
                ],
              ),
            ),
          );
  }

  Widget exerciseCardList() {
    int count = 0;
    updateCardList();
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Card(
          clipBehavior: Clip.hardEdge,
          child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color.fromRGBO(68, 138, 255, 1)),
                borderRadius: BorderRadius.circular(4.0),
              ),
              title: Center(
                child: Text(
                  'Workouts completed: ${widget.recordedWorkouts.length}',
                  style: TextStyle(fontSize: 16),
                ),
              )),
        ),
        for (var workout in widget.recordedWorkouts)
          Card(
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              tileColor: Color.fromRGBO(68, 138, 255, 0.6),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color.fromRGBO(68, 138, 255, 1)),
                borderRadius: BorderRadius.circular(4.0),
              ),
              title: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                          "${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(workout.time))}"),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Text(
                        "${nameList[count++]}",
                        textAlign: TextAlign.left,
                      )),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
