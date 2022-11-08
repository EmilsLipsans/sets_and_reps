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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add exercise'),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 40.0, bottom: 40.0, left: 20.0, right: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, bottom: 20.0, left: 0.0, right: 0.0),
                child: Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: TextField(
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
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              Flexible(
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
                          bottom: 0,
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
                      flex: 3,
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
              Flexible(
                flex: 4,
                fit: FlexFit.loose,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Exercise Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 10, // <-- SEE HERE
                  maxLines: 10, // <-- SEE HERE
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
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
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 0,
                  right: 0,
                  left: 0,
                ),
                child: MaterialButton(
                  color: Colors.blueAccent,
                  onPressed: () {},
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
