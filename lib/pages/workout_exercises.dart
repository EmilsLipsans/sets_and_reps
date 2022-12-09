import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/widgets.dart';

class WorkoutExercisesRoute extends StatefulWidget {
  @override
  WorkoutExercisesRoute(
      {super.key, required this.list, required this.incrementCounter});
  final list;
  final ValueChanged<int> incrementCounter;
  _WorkoutExercisesRouteState createState() => _WorkoutExercisesRouteState();
}

class WorkoutExercises {
  String name;
  final docID;

  WorkoutExercises({
    required this.name,
    required this.docID,
  });
}

class _WorkoutExercisesRouteState extends State<WorkoutExercisesRoute> {
  List<WorkoutExercises> exercises = [];
  bool listEmpty = false;
  @override
  void initState() {
    super.initState();

    exercises = widget.list;
    if (exercises.length == 0) listEmpty = true;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Exercise List"),
        ),
        body: listEmpty
            ? noList()
            : ReorderableListView.builder(
                itemCount: exercises.length,
                onReorder: (oldIndex, newIndex) => setState(() {
                  final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

                  final exercise = exercises.removeAt(oldIndex);
                  exercises.insert(index, exercise);
                }),
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return buildExercise(index, exercise);
                },
              ),
      );

  Widget buildExercise(int index, WorkoutExercises exercise) => Card(
        key: ValueKey(exercise),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Icon(
            Icons.drag_handle,
          ),
          title: Text('${exercise.name}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(Icons.remove_circle,
                      color: Color.fromARGB(255, 255, 89, 89)),
                  onPressed: () {
                    remove(index);
                    setState(() {
                      widget.incrementCounter(exercises.length);
                      if (exercises.length == 0) listEmpty = true;
                    });
                  }),
            ],
          ),
        ),
      );
  Widget noList() {
    return Center(
      child: Paragraph('No Exercises Added'),
    );
  }

  void remove(int index) => setState(() => exercises.removeAt(index));
}
