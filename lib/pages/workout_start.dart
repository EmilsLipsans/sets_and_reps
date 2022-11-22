import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/workout_start_details.dart';
import 'package:gtk_flutter/pages/workouts.dart';
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StartWorkoutPage extends StatefulWidget {
  const StartWorkoutPage({
    super.key,
    required this.workouts,
  });
  final List<Workout> workouts;
  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  String? checkedWorkout;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 30.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: exerciseRadioCardList(widget.workouts),
            ),
            Spacer(),
            MaterialButton(
              color: Colors.blueAccent,
              disabledColor: Colors.grey,
              onPressed: checkedWorkout == null
                  ? null
                  : () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StartWorkoutDetailsRoute(
                                  workoutID: checkedWorkout,
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
          Card(
            clipBehavior: Clip.hardEdge,
            shape: workout.favorite
                ? RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromARGB(255, 255, 238, 88)),
                    borderRadius: BorderRadius.circular(4.0),
                  )
                : null,
            child: RadioListTile(
              tileColor: Color.fromARGB(255, 255, 255, 255),
              value: workout.docID,
              groupValue: checkedWorkout,
              onChanged: (value) {
                setState(() {
                  checkedWorkout = value;
                });
              },
              title: Text('${workout.name}'),
              secondary: PopupMenuButton(
                onSelected: (value) {},
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
          ),
      ],
    );
  }
}
