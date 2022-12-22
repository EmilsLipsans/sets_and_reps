import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/workout_create.dart';
import 'package:gtk_flutter/pages/workout_start_details_end.dart';
import 'package:gtk_flutter/utils/showDialog.dart';
import 'package:provider/provider.dart';
import 'package:quantity_input/quantity_input.dart';

class StartWorkoutDetailsRoute extends StatefulWidget {
  StartWorkoutDetailsRoute({super.key, required this.workout});

  final workout;

  State<StartWorkoutDetailsRoute> createState() =>
      StartWorkoutDetailsRouteState();
}

class StartWorkoutDetailsRouteState extends State<StartWorkoutDetailsRoute> {
  int count = 1;
  late List updateList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.workout.name}' +
            ' ($count/${widget.workout.exerciseRef.length}) '),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showExerciseDetails(context, updateList[count - 1]);
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: RecordWorkoutPage(
                  exercises: appState.exerciseList,
                  workout: widget.workout,
                  count: count,
                  updateList: (list) {
                    updateList = list;
                  },
                  countChanged: (result) {
                    setState(() {
                      count = result + 1;
                    });
                  },
                  nextPressed: () {
                    setState(() {
                      count++;
                    });
                  },
                  prevPressed: () {
                    setState(() {
                      count--;
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordExercise {
  const RecordExercise({
    required this.reps,
    required this.weight,
  });
  final reps;
  final weight;
}

class RecordWorkout {
  const RecordWorkout({
    required this.exerciseID,
    required this.recordedExercisesList,
  });
  final exerciseID;
  final List<RecordExercise> recordedExercisesList;
}

class RecordWorkoutPage extends StatefulWidget {
  RecordWorkoutPage({
    super.key,
    required this.exercises,
    required this.workout,
    required this.count,
    required this.updateList,
    required this.nextPressed,
    required this.prevPressed,
    required this.countChanged,
  });
  final VoidCallback nextPressed;
  final VoidCallback prevPressed;
  final Function(int) countChanged;
  final Function(List) updateList;
  final List<Exrecises> exercises;
  final workout;

  int count;
  @override
  State<RecordWorkoutPage> createState() => _RecordWorkoutPageState();
}

class _RecordWorkoutPageState extends State<RecordWorkoutPage> {
  void initState() {
    super.initState();
    updateList(list);
  }

  double weightInput = 0.0;
  int repsInput = 0;
  int listPos = 0;
  late int cardSelected;
  bool exerciseCardTapped = false;
  List<Exrecises> list = [];
  List<RecordExercise> recordedExercises = [];
  late List<RecordWorkout> recordedWorkout = [];
  List<Exrecises> updateList(List<Exrecises> list) {
    for (var count = 0; count < widget.workout.exerciseRef.length; count++)
      for (var value in widget.exercises) {
        if (value.docID == widget.workout.exerciseRef[count])
          list.add(Exrecises(
              docID: value.docID,
              name: value.name,
              url: value.url,
              description: value.description,
              category: value.category,
              builtIn: value.builtIn));
        continue;
      }
    widget.updateList(list);
    return list;
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FinishWorkoutDetailsRoute(
                  workout: widget.workout,
                  recordedWorkout: recordedWorkout,
                  workoutExercises: list,
                )));

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    if (result != null) {
      setState(() {
        listPos = result;
        widget.countChanged(listPos);
        loadRecordedExercise();
      });
    }
  }

  void updateRecordWorkout() {
    recordedWorkout.removeAt(listPos);

    setState(() {
      recordedWorkout.insert(
          listPos,
          RecordWorkout(
              exerciseID: list[listPos].docID,
              recordedExercisesList: List.from(recordedExercises)));
    });
  }

  void addRecordWorkout() {
    setState(() {
      recordedWorkout.add(RecordWorkout(
          exerciseID: list[listPos].docID,
          recordedExercisesList: List.from(recordedExercises)));
    });
  }

  void loadRecordedExercise() {
    recordedExercises.clear();

    setState(() {
      for (var record in recordedWorkout[listPos].recordedExercisesList)
        recordedExercises
            .add(RecordExercise(reps: record.reps, weight: record.weight));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 20.0, left: 20.0, right: 20.0),
        child: Center(
          child: Column(
            children: [
              Text(
                list[listPos].name,
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Weight (kgs):',
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 0.7,
                indent: 20,
                endIndent: 20,
                color: Colors.grey,
              ),
              QuantityInput(
                  type: QuantityInputType.double,
                  acceptsZero: true,
                  value: weightInput,
                  inputWidth: 100,
                  minValue: double.infinity,
                  step: 2.5,
                  onChanged: (value) => setState(() =>
                      weightInput = double.parse(value.replaceAll(',', '')))),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Reps:',
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 0.7,
                indent: 20,
                endIndent: 20,
                color: Colors.grey,
              ),
              QuantityInput(
                  value: repsInput,
                  inputWidth: 100,
                  acceptsZero: true,
                  onChanged: (value) => setState(
                      () => repsInput = int.parse(value.replaceAll(',', '')))),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: exerciseCardTapped ? Colors.red : Colors.blue,
                        disabledColor: Colors.grey,
                        onPressed: () {
                          exerciseCardTapped
                              ? setState(() {
                                  recordedExercises.removeAt(cardSelected);
                                  exerciseCardTapped = false;
                                })
                              : setState(() {
                                  repsInput = 0;
                                  weightInput = 0.0;
                                });
                        },
                        height: 50,
                        minWidth: 100,
                        child: Text(
                          exerciseCardTapped ? "Delete" : "Clear",
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: MaterialButton(
                        color: Color.fromARGB(255, 71, 250, 77),
                        disabledColor: Colors.grey,
                        onPressed: () {
                          exerciseCardTapped
                              ? setState(() {
                                  recordedExercises[cardSelected] =
                                      RecordExercise(
                                          reps: repsInput, weight: weightInput);
                                  exerciseCardTapped = false;
                                })
                              : setState(() {
                                  recordedExercises.add(RecordExercise(
                                      reps: repsInput, weight: weightInput));
                                });
                        },
                        height: 50,
                        minWidth: 100,
                        child: Text(
                          exerciseCardTapped ? "Update" : "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    for (var recordedExercise in recordedExercises)
                      Card(
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                exerciseCardTapped = true;
                                cardSelected =
                                    recordedExercises.indexOf(recordedExercise);
                              });
                            },
                            child: ListTile(
                              tileColor: Color.fromARGB(255, 255, 255, 255),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Text(
                                        "${recordedExercises.indexOf(recordedExercise) + 1}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    "${recordedExercise.weight} kgs",
                                    textAlign: TextAlign.right,
                                  )),
                                  Expanded(
                                      child: Text(
                                    "${recordedExercise.reps} reps",
                                    textAlign: TextAlign.right,
                                  )),
                                ],
                              ),
                            )),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.blue,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                if (listPos != 0) {
                                  widget.prevPressed();
                                  if (recordedWorkout
                                      .asMap()
                                      .containsKey(listPos))
                                    updateRecordWorkout();
                                  else
                                    addRecordWorkout();

                                  recordedExercises.clear();
                                  listPos -= 1;
                                  exerciseCardTapped = false;
                                  if (recordedWorkout
                                      .asMap()
                                      .containsKey(listPos))
                                    loadRecordedExercise();
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
                        decoration: const ShapeDecoration(
                          color: Colors.blue,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              if (listPos == list.length - 1) {
                                if (recordedWorkout
                                    .asMap()
                                    .containsKey(listPos))
                                  updateRecordWorkout();
                                else
                                  addRecordWorkout();
                                _navigateAndDisplaySelection(context);
                              } else {
                                widget.nextPressed();
                                if (recordedWorkout
                                    .asMap()
                                    .containsKey(listPos))
                                  updateRecordWorkout();
                                else
                                  addRecordWorkout();

                                recordedExercises.clear();
                                listPos += 1;
                                exerciseCardTapped = false;
                                if (recordedWorkout
                                    .asMap()
                                    .containsKey(listPos))
                                  loadRecordedExercise();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
