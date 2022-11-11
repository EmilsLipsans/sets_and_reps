import 'dart:async'; // new

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/create_exercise.dart';

import 'package:gtk_flutter/utils/dropdown.dart';
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
                addMessage: (message) => appState.createNewWorkout(message),
                messages: appState.exreciseList,
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
      {required this.name, required this.message, required this.category});
  final String name;
  final String message;
  final int category;
}

class NewWorkout extends StatefulWidget {
  const NewWorkout({
    super.key,
    required this.addMessage,
    required this.messages,
  });
  final FutureOr<void> Function(String message) addMessage;
  final List<Exrecises> messages;

  @override
  State<NewWorkout> createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  Widget exerciseCards(message) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            Icons.add_circle_rounded,
            color: Colors.blueAccent,
          ),
          onPressed: () => print('select'),
        ),
        title: Text('${message.name}'),
        trailing: PopupMenuButton(
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
              child: Text('Edit'),
            ),
            PopupMenuDivider(),
            const PopupMenuItem(
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>(debugLabel: '_NewWorkoutState');
  final _nameController = TextEditingController();
  String? selectedValue;
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
              SizedBox(
                height: 280,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    if (selectedValue == null || selectedValue == 'All') ...[
                      for (var message in widget.messages)
                        exerciseCards(message),
                    ] else
                      for (var message in widget.messages)
                        if (message.category ==
                            filterByItemPos(selectedValue as String, items))
                          exerciseCards(message),
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
              Spacer(),
              MaterialButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await widget.addMessage(
                      _nameController.text,
                    );
                    _nameController.clear();
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
}
