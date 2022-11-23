import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/workout_create.dart';
import 'package:provider/provider.dart';

class StartWorkoutDetailsRoute extends StatefulWidget {
  StartWorkoutDetailsRoute({super.key, required this.workout});

  final workout;

  State<StartWorkoutDetailsRoute> createState() =>
      StartWorkoutDetailsRouteState();
}

class StartWorkoutDetailsRouteState extends State<StartWorkoutDetailsRoute> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text('Record Exercise'),
            ),
            Text('($count/${widget.workout.exerciseRef.length}) '),
          ],
        ),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: RecordWorkout(
                exercises: appState.exreciseList,
                workout: widget.workout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordWorkout extends StatefulWidget {
  const RecordWorkout({
    super.key,
    required this.exercises,
    required this.workout,
  });
  final List<Exrecises> exercises;
  final workout;
  @override
  State<RecordWorkout> createState() => _RecordWorkoutState();
}

class _RecordWorkoutState extends State<RecordWorkout> {
  void initState() {
    super.initState();
    updateList(list);
  }

  List<Exrecises> list = [];
  List<Exrecises> updateList(List<Exrecises> list) {
    for (var count = 0; count < widget.workout.exerciseRef.length; count++)
      for (var value in widget.exercises) {
        if (value.docID == widget.workout.exerciseRef[count])
          list.add(Exrecises(
              docID: value.docID,
              name: value.name,
              url: value.url,
              description: value.description,
              category: value.category));
        continue;
      }
    return list;
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 40.0, left: 20.0, right: 20.0),
        child: Center(
          child: Column(
            children: [
              Text(
                list[0].name,
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Description',
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 5.0, left: 7.0, right: 7.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 199, 220, 255),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      list[0].description,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 3)
            ],
          ),
        ),
      ),
    );
  }
}
