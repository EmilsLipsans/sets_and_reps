import 'dart:async'; // new

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:gtk_flutter/src/widgets.dart';
import 'package:gtk_flutter/utils/dropdown.dart';

class CreateExerciseRoute extends StatefulWidget {
  const CreateExerciseRoute({super.key});
  @override
  State<CreateExerciseRoute> createState() => CreateExerciseRouteState();
}

class CreateExerciseRouteState extends State<CreateExerciseRoute> {
  static const List<String> items = [
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
  final _formKey = GlobalKey<FormState>(debugLabel: '_NewWorkoutState');
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding:
            EdgeInsets.only(top: 0, bottom: 0, left: 100.0, right: 100.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await widget.addMessage(_controller.text);
            _controller.clear();
          }
        },
        tooltip: 'Save Exercise',
        label: const Text('Save'),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 40.0, bottom: 40.0, left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0.0, bottom: 20.0, left: 0.0, right: 0.0),
                  child: Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Exercise Name',
                        contentPadding: const EdgeInsets.only(
                            left: 20.0, bottom: 4.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Exercise Name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
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
                                'Category:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
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
                                customItemsHeights:
                                    getCustomItemsHeights(items),
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
                  ),
                ),
                Flexible(
                  flex: 5,
                  fit: FlexFit.loose,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Exercise Description',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 5, // <-- SEE HERE
                    maxLines: 5, // <-- SEE HERE
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 0.0, right: 0.0),
                  child: Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Example Video URL',
                        border: OutlineInputBorder(),
                      ),

                      keyboardType: TextInputType.url,
                      minLines: 1, // <-- SEE HERE
                      maxLines: 1, // <-- SEE HERE
                    ),
                  ),
                ),
              ],
            ),
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
  static const List<String> items = [
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 0.0, bottom: 20.0, left: 0.0, right: 0.0),
          child: Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Exercise Name',
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Exercise Name';
                }
                return null;
              },
              keyboardType: TextInputType.text,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
          child: Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
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
                        'Category:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
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
          ),
        ),
        Flexible(
          flex: 5,
          fit: FlexFit.loose,
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Exercise Description',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5, // <-- SEE HERE
            maxLines: 5, // <-- SEE HERE
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 20.0, left: 0.0, right: 0.0),
          child: Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Example Video URL',
                border: OutlineInputBorder(),
              ),

              keyboardType: TextInputType.url,
              minLines: 1, // <-- SEE HERE
              maxLines: 1, // <-- SEE HERE
            ),
          ),
        ),
      ],
    );
  }
}
