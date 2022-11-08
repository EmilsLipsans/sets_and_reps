import 'dart:async'; // new

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/create_exercise.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:gtk_flutter/utils/dropdown.dart';
import 'package:provider/provider.dart';

class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key});
  @override
  State<SecondRoute> createState() => SecondRouteState();
}

class SecondRouteState extends State<SecondRoute> {
  final List<String> items = [
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

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateExerciseRoute()),
              );
            },
          )
        ],
        title: const Text('Create Workout'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Workout Name',
                  contentPadding:
                      const EdgeInsets.only(left: 20.0, bottom: 4.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 12,
                        bottom: 12,
                        right: 0,
                        left: 0,
                      ),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Show Exercises:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Text(
                            'Select Category',
                            style: TextStyle(
                              fontSize: 14,
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
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Modify from here...
              Consumer<ApplicationState>(
                builder: (context, appState, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appState.loggedIn) ...[
                      NewWorkout(
                        addMessage: (message) =>
                            appState.createNewWorkout(message),
                        messages: appState.exreciseList,
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                height: 1,
                thickness: 0.5,
                indent: 10,
                endIndent: 10,
              ),
              const Flexible(
                fit: FlexFit.tight,
                child: SizedBox(
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: MaterialButton(
                  color: Colors.blueAccent,
                  onPressed: () {},
                  height: 50,
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Exrecises {
  Exrecises({required this.name, required this.message});
  final String name;
  final String message;
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
  final _formKey = GlobalKey<FormState>(debugLabel: '_NewWorkoutState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a message',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('SEND'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (var message in widget.messages)
          Paragraph('${message.name}: ${message.message}'),
        const SizedBox(height: 8),
      ],
    );
  }
}
