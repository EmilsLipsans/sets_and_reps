import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/workout_create.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:provider/provider.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});
  @override
  State<WorkoutsPage> createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<WorkoutsPage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'SAVED'),
    Tab(text: 'ONLINE'),
  ];

  late TabController _tabController;

  int getActiveTabIndex() {
    return _tabController.index;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          if (tab.text == 'ONLINE') {
            return noList();
          } else {
            return Consumer<ApplicationState>(
              builder: (context, appState, _) => Column(
                children: [
                  Expanded(
                    child: WorkoutPage(
                      deleteWorkout: (docID) => appState.deleteWorkout(docID),
                      favoriteWorkout: (docID, favorite) =>
                          appState.favoriteWorkout(docID, favorite),
                      workouts: appState.workoutList,
                    ),
                  ),
                ],
              ),
            );
          }
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateWorkoutRoute(
                        workoutExercises: [],
                        actionName: 'Add Workout',
                        workoutName: null,
                        createNewWorkout: true,
                        workoutID: null,
                      )),
            );
          },
          tooltip: 'Create WorkoutPage',
          label: const Text('Create'),
          icon: const Icon(Icons.add)),
    );
  }

  Widget noList() {
    return Center(
      child: Paragraph('No Available Workouts'),
    );
  }
}

class Workout {
  Workout(
      {required this.exerciseRef,
      required this.name,
      required this.docID,
      required this.favorite});
  final List<String> exerciseRef;
  final String name;
  final String docID;
  final bool favorite;
}

class WorkoutPage extends StatefulWidget {
  const WorkoutPage(
      {super.key,
      required this.workouts,
      required this.deleteWorkout,
      required this.favoriteWorkout});
  final List<Workout> workouts;
  final FutureOr<void> Function(String docID) deleteWorkout;
  final FutureOr<void> Function(String docID, bool favorite) favoriteWorkout;
  @override
  State<WorkoutPage> createState() => _WorkoutState();
}

class _WorkoutState extends State<WorkoutPage> {
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
              child: exerciseCardList(widget.workouts),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget exerciseCardList(workouts) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        for (var workout in widget.workouts)
          Card(
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              tileColor: Color.fromARGB(255, 255, 255, 255),
              leading: IconButton(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  icon: (workout.favorite
                      ? const Icon(Icons.star)
                      : const Icon(Icons.star_border)),
                  color: workout.favorite ? Colors.yellow : Colors.grey,
                  onPressed: () {
                    workout.favorite
                        ? widget.favoriteWorkout(workout.docID, false)
                        : widget.favoriteWorkout(workout.docID, true);
                  }),
              title: Text('${workout.name}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.upload_rounded,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {}),
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateWorkoutRoute(
                                    workoutExercises: workout.exerciseRef,
                                    actionName: 'Edit Workout',
                                    workoutName: workout.name,
                                    createNewWorkout: false,
                                    workoutID: workout.docID,
                                  )),
                        );
                      }
                      if (value == 2) {
                        widget.deleteWorkout(workout.docID);
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
                ],
              ),
            ),
          ),
      ],
    );
  }
}
