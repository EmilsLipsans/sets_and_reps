import 'dart:async'; // new

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/exercise_create.dart';
import 'package:gtk_flutter/pages/exercise_update.dart';
import 'package:gtk_flutter/pages/workout_exercises.dart';

import 'package:gtk_flutter/utils/dropdown.dart';

import 'package:gtk_flutter/utils/showDialog.dart';
import 'package:provider/provider.dart';
// new

class CreateWorkoutRoute extends StatefulWidget {
  const CreateWorkoutRoute(
      {super.key,
      required this.workoutExercises,
      required this.actionName,
      required this.workoutName,
      required this.createNewWorkout,
      required this.workoutID});
  final List<String> workoutExercises;
  final actionName;
  final workoutName;
  final bool createNewWorkout;
  final workoutID;
  State<CreateWorkoutRoute> createState() => CreateWorkoutRouteState();
}

class CreateWorkoutRouteState extends State<CreateWorkoutRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.actionName),
      ),
      resizeToAvoidBottomInset: false,
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: NewWorkout(
                addworkout: (newWorkout, listOfIDs) =>
                    appState.createNewWorkout(newWorkout, listOfIDs),
                deleteExercise: (docID) => appState.deleteExercise(docID),
                updateWorkout: (workoutName, list, docID) =>
                    appState.updateWorkout(workoutName, list, docID),
                exercises: appState.exreciseList,
                defaultExercises: appState.defaultExerciseList,
                workoutExercises: widget.workoutExercises,
                workoutname: widget.workoutName,
                createNewWorkout: widget.createNewWorkout,
                workoutID: widget.workoutID,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Exrecises {
  Exrecises(
      {required this.docID,
      required this.name,
      required this.url,
      required this.description,
      required this.category});
  final String docID;
  final String name;
  final String url;
  final String description;
  final int category;
}

class NewWorkout extends StatefulWidget {
  const NewWorkout(
      {super.key,
      required this.addworkout,
      required this.deleteExercise,
      required this.updateWorkout,
      required this.exercises,
      required this.workoutExercises,
      required this.workoutname,
      required this.createNewWorkout,
      required this.workoutID,
      required this.defaultExercises});

  final FutureOr<void> Function(String newWorkout, List list) addworkout;
  final FutureOr<void> Function(String docID) deleteExercise;
  final FutureOr<void> Function(String workoutName, List list, String docID)
      updateWorkout;
  final List<Exrecises> exercises;
  final List<Exrecises> defaultExercises;
  final List<String> workoutExercises;
  final workoutname;
  final bool createNewWorkout;
  final workoutID;

  @override
  State<NewWorkout> createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  void initState() {
    super.initState();
    updateList(list);
  }

  final _formKey = GlobalKey<FormState>(debugLabel: '_NewWorkoutState');
  late final _nameController = TextEditingController(text: widget.workoutname);
  String? selectedValue;
  late int exercisesAdded = list.length;
  List<WorkoutExercises> list = [];
  void _incrementCounter(int count) {
    setState(() {
      exercisesAdded = count;
    });
  }

  List<WorkoutExercises> updateList(List<WorkoutExercises> list) {
    for (var count = 0; count < widget.workoutExercises.length; count++)
      for (var value in widget.exercises) {
        if (value.docID == widget.workoutExercises[count])
          list.add(WorkoutExercises(name: value.name, docID: value.docID));
        _incrementCounter(list.length);
        continue;
      }

    return list;
  }

  static const List<String> items = [
    'All',
    'Abs',
    'Back',
    'Biceps',
    'Calves',
    'Cardio',
    'Chest',
    'Forearms',
    'Full Body',
    'Glutes',
    'Hamstrings',
    'Quads',
    'Shoulders',
    'Triceps',
    'Other',
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 40.0, bottom: 40.0, left: 20.0, right: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 40,
                controller: _nameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Workout Name',
                  contentPadding:
                      const EdgeInsets.only(left: 10.0, bottom: 4.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Workout Name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField2(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.only(left: 10.0, bottom: 4.0, top: 8.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                isExpanded: true,
                hint: Text(
                  'Filter by Category',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: addDividersAfterItems(items),
                customItemsHeights: getCustomItemsHeights(items),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                    print(widget.defaultExercises);
                  });
                },
                buttonHeight: 40,
                dropdownMaxHeight: 200,
                buttonWidth: double.infinity,
                itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 5,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    if (selectedValue == null || selectedValue == 'All') ...[
                      for (var newWorkout in widget.exercises)
                        exerciseCards(newWorkout),
                      for (var defaultExercise in widget.defaultExercises)
                        defaultExerciseCards(defaultExercise),
                    ] else
                      for (var newWorkout in widget.exercises)
                        if (newWorkout.category ==
                            filterByItemPos(selectedValue as String, items))
                          exerciseCards(newWorkout),
                    Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Color.fromARGB(255, 71, 250, 77),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreateExerciseRoute()),
                          );
                        },
                        child: ListTile(
                          tileColor: Color.fromARGB(255, 71, 250, 77),
                          title: Center(
                            child: Text('Add New Exercise'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Exercises Added: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkoutExercisesRoute(
                                    list: list,
                                    incrementCounter: _incrementCounter,
                                  )),
                        );
                      },
                      height: 40,
                      minWidth: 40,
                      child: Text(
                        '$exercisesAdded',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(2),
                    ),
                  ),
                ],
              ),
              Spacer(),
              MaterialButton(
                color: Colors.blue,
                onPressed: list.isEmpty
                    ? () {
                        final snackBar = SnackBar(
                          content: Text('Add Exercises To Save Workout'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          List listOfIDs = [];
                          list.forEach((name) {
                            listOfIDs.add(name.docID);
                          });
                          widget.createNewWorkout
                              ? await widget.addworkout(
                                  _nameController.text, listOfIDs)
                              : await widget.updateWorkout(_nameController.text,
                                  listOfIDs, widget.workoutID);
                          _nameController.clear();
                          list.clear();
                          _incrementCounter(list.length);
                          if (!widget.createNewWorkout) Navigator.pop(context);
                          final snackBar = SnackBar(
                            content: widget.createNewWorkout
                                ? Text('Workout Saved')
                                : Text('Workout Edited'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
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
            ],
          ),
        ),
      ),
    );
  }

  Widget defaultExerciseCards(newWorkout) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        leading: IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Colors.blue,
            ),
            onPressed: () {
              if (exercisesAdded < 10) {
                list.add(WorkoutExercises(
                    name: newWorkout.name, docID: newWorkout.docID));
                _incrementCounter(list.length);
              } else {
                final snackBar = SnackBar(
                  content: const Text('Exercise List Full'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }),
        title: Text('${newWorkout.name}'),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 0) {
              showExerciseDetails(context, newWorkout);
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

  Widget exerciseCards(newWorkout) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        leading: IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Colors.blue,
            ),
            onPressed: () {
              if (exercisesAdded < 10) {
                list.add(WorkoutExercises(
                    name: newWorkout.name, docID: newWorkout.docID));
                _incrementCounter(list.length);
              } else {
                final snackBar = SnackBar(
                  content: const Text('Exercise List Full'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }),
        title: Text('${newWorkout.name}'),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 0) {
              showExerciseDetails(context, newWorkout);
            }
            if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UpdateExerciseRoute(workout: newWorkout)),
              );
            }
            if (value == 2) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirm delete'),
                  content: Text(
                      'Deleting ${newWorkout.name} may disrupt workouts with this exercise. Are you sure you want to delete ${newWorkout.name}? '),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.deleteExercise(newWorkout.docID);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
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
            const PopupMenuItem(
              child: Text('Edit'),
              value: 1,
            ),
            PopupMenuDivider(),
            const PopupMenuItem(
              child: Text('Delete'),
              value: 2,
            ),
          ],
        ),
      ),
    );
  }
}
