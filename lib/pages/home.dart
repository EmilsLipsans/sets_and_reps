import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/workout_start.dart';
import 'package:gtk_flutter/pages/workout_start_details.dart';
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
                recordedWorkouts: appState.workoutRecordList,
                workouts: appState.workoutList,
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
  final List<String> recordedExercises;
}

class WorkoutRecordPage extends StatefulWidget {
  const WorkoutRecordPage({
    super.key,
    required this.recordedWorkouts,
    required this.workouts,
  });
  final List<WorkoutRecord> recordedWorkouts;
  final List<Workout> workouts;
  @override
  State<WorkoutRecordPage> createState() => _WorkoutRecordPageState();
}

class _WorkoutRecordPageState extends State<WorkoutRecordPage> {
  List<String> workoutNameList() {
    List<String> list = [];
    for (var count = 0; count < widget.recordedWorkouts.length; count++)
      for (var value in widget.workouts) {
        if (value.docID == widget.recordedWorkouts[count].workoutID)
          list.add(value.name);
        continue;
      }
    return list;
  }

  void updateNameList() {
    setState(() {
      nameList = workoutNameList();
    });
  }

  List nameList = [];
  late String lastWorkoutName = nameList.length == 0 ? 'shees' : nameList[0];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
        child: Column(
          children: [
            Text(
              'Last workout',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Card(
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
                      Text(
                        'asd',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Upper back: ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '2 Days ago',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          color: Colors.blue,
                          onPressed: () {},
                          child: Text(
                            "Details",
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              textAlign: TextAlign.left,
              'Last 14 Days',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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

  Widget exerciseCardList() {
    updateNameList();
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
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
                        "${nameList[widget.recordedWorkouts.indexOf(workout)]}",
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
