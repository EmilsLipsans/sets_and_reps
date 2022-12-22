import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/workout_create.dart';
import 'package:gtk_flutter/pages/workout_start_details.dart';
import 'package:gtk_flutter/pages/workouts.dart';
import 'package:gtk_flutter/utils/nameLists.dart';
import 'package:gtk_flutter/utils/showDialog.dart';
import 'package:provider/provider.dart';

class StartWorkoutRoute extends StatelessWidget {
  const StartWorkoutRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Workout'),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: StartWorkoutPage(
                workouts: appState.workoutList,
                defaultWorkouts: appState.defaultWorkoutList,
                exercises: appState.exerciseList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StartWorkoutPage extends StatefulWidget {
  const StartWorkoutPage(
      {super.key,
      required this.workouts,
      required this.exercises,
      required this.defaultWorkouts});
  final List<Workout> workouts;
  final List<Exrecises> exercises;
  final List<Workout> defaultWorkouts;
  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  Workout? checkedWorkout;
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
              child: exerciseRadioCardList(widget.workouts),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: MaterialButton(
                color: Colors.blueAccent,
                disabledColor: Colors.grey,
                onPressed: checkedWorkout == null
                    ? null
                    : () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StartWorkoutDetailsRoute(
                                    workout: checkedWorkout,
                                  )),
                        );
                      },
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

  Widget exerciseRadioCardList(workouts) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        for (var workout in widget.workouts)
          if (!workout.builtIn) workoutCard(workout),
        for (var defaultWorkout in widget.defaultWorkouts)
          workoutCard(defaultWorkout),
      ],
    );
  }

  workoutCard(workout) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: workout.favorite
          ? RoundedRectangleBorder(
              side: BorderSide(color: Color.fromARGB(255, 255, 238, 88)),
              borderRadius: BorderRadius.circular(4.0),
            )
          : null,
      child: RadioListTile(
        tileColor: Color.fromARGB(255, 255, 255, 255),
        value: workout,
        groupValue: checkedWorkout,
        onChanged: (value) {
          setState(() {
            checkedWorkout = value;
          });
        },
        title: Text('${workout.name}'),
        secondary: PopupMenuButton(
          onSelected: (value) {
            if (value == 0) {
              showWorkoutDetails(
                  context, workout, updateList(workout, widget.exercises));
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          icon: Icon(
            Icons.more_vert,
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              child: Text('See Details'),
              value: 0,
            ),
          ],
        ),
      ),
    );
  }
}
