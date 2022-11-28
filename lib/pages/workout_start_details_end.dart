import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:provider/provider.dart';

class FinishWorkoutDetailsRoute extends StatelessWidget {
  const FinishWorkoutDetailsRoute(
      {super.key,
      required this.workoutName,
      required this.workoutExercises,
      required this.recordedWorkout});
  final workoutName;
  final workoutExercises;
  final recordedWorkout;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finish $workoutName'),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: FinishWorkoutPage(
                workoutExercises: workoutExercises,
                recordedWorkout: recordedWorkout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FinishWorkoutPage extends StatefulWidget {
  const FinishWorkoutPage(
      {super.key,
      required this.workoutExercises,
      required this.recordedWorkout});
  final workoutExercises;
  final recordedWorkout;
  @override
  State<FinishWorkoutPage> createState() => _FinishWorkoutPageState();
}

class _FinishWorkoutPageState extends State<FinishWorkoutPage> {
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
                        title: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                            ),
                            child: Text(
                              "${exercise.name}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        subtitle: Column(
                          children: [
                            for (var exercise in widget.workoutExercises)
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
                                            "1",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                        "2 kgs",
                                        textAlign: TextAlign.right,
                                      )),
                                      Expanded(
                                          child: Text(
                                        "1 reps",
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
                onPressed: () async {},
                height: 50,
                minWidth: 300,
                child: Text(
                  "Start",
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
