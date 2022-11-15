import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:gtk_flutter/utils/exercise_list.dart';

class ExerciseListRoute extends StatefulWidget {
  @override
  ExerciseListRoute(
      {super.key, required this.list, required this.incrementCounter});
  final list;
  final ValueChanged<int> incrementCounter;
  _ExerciseListRouteState createState() => _ExerciseListRouteState();
}

class _ExerciseListRouteState extends State<ExerciseListRoute> {
  List<ExerciseList> exercises = [];
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
            ? buildSingleCard()
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

  Widget buildExercise(int index, ExerciseList exercise) => Card(
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
  Widget buildSingleCard() {
    return Center(
      child: Paragraph('No Exercises Added'),
    );
  }

  void remove(int index) => setState(() => exercises.removeAt(index));
}
