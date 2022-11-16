import 'dart:async'; // new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/exercise_create.dart';
import 'package:gtk_flutter/pages/exercise_update.dart';
import 'package:gtk_flutter/pages/workout_exercises.dart';

import 'package:gtk_flutter/utils/dropdown.dart';
import 'package:gtk_flutter/utils/workout_exercises.dart';
import 'package:gtk_flutter/utils/showDialog.dart';
import 'package:provider/provider.dart';
// new

class CreateWorkoutRoute extends StatefulWidget {
  const CreateWorkoutRoute({super.key});
  @override
  State<CreateWorkoutRoute> createState() => CreateWorkoutRouteState();
}

class CreateWorkoutRouteState extends State<CreateWorkoutRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
      ),
      resizeToAvoidBottomInset: false,
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: NewWorkout(
                addworkout: (workout, listOfIDs) =>
                    appState.createNewWorkout(workout, listOfIDs),
                deleteExercise: (docID) => appState.deleteExercise(docID),
                workouts: appState.exreciseList,
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
  final docID;
  final String name;
  final String url;
  final String description;
  final int category;
}

class NewWorkout extends StatefulWidget {
  const NewWorkout({
    super.key,
    required this.addworkout,
    required this.deleteExercise,
    required this.workouts,
  });

  final FutureOr<void> Function(String workout, List list) addworkout;
  final FutureOr<void> Function(String docID) deleteExercise;
  final List<Exrecises> workouts;

  @override
  State<NewWorkout> createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_NewWorkoutState');
  final _nameController = TextEditingController();
  String? selectedValue;
  int exercisesAdded = 0;
  List<WorkoutExercises> list = [];
  void _incrementCounter(int count) {
    setState(() {
      exercisesAdded = count;
    });
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
                      for (var workout in widget.workouts)
                        exerciseCards(workout),
                    ] else
                      for (var workout in widget.workouts)
                        if (workout.category ==
                            filterByItemPos(selectedValue as String, items))
                          exerciseCards(workout),
                    Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Color.fromARGB(255, 1, 179, 7),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreateExerciseRoute()),
                          );
                        },
                        child: ListTile(
                          tileColor: Color.fromARGB(255, 131, 241, 135),
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
                      color: Colors.blueAccent,
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
                color: Colors.blueAccent,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    List listOfIDs = [];
                    list.forEach((name) {
                      listOfIDs.add('exercises/' + name.docID);
                    });

                    await widget.addworkout(_nameController.text, listOfIDs);
                    _nameController.clear();
                    list.clear();
                    _incrementCounter(list.length);
                    final snackBar = SnackBar(
                      content: const Text('Workout Saved'),
                      action: SnackBarAction(
                        label: 'Show Workout',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
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

  Widget exerciseCards(workout) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        leading: IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              if (exercisesAdded < 10) {
                list.add(
                    WorkoutExercises(name: workout.name, docID: workout.docID));
                _incrementCounter(list.length);
              } else {
                final snackBar = SnackBar(
                  content: const Text('Exercise List Full'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }),
        title: Text('${workout.name}'),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 0) {
              showExerciseDetails(context, workout, items);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) =>
              //           ExerciseDetailsRoute(workout: workout, items: items),
              //     ));
            }
            if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UpdateExerciseRoute(workout: workout)),
              );
            }
            if (value == 2) {
              widget.deleteExercise(workout.docID);
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
