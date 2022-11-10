import 'dart:async'; // new

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/utils/dropdown.dart';
import 'package:provider/provider.dart';

class CreateExerciseRoute extends StatefulWidget {
  const CreateExerciseRoute({super.key});
  @override
  State<CreateExerciseRoute> createState() => CreateExerciseRouteState();
}

class CreateExerciseRouteState extends State<CreateExerciseRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
      ),
      resizeToAvoidBottomInset: true,
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: NewExercise(
                addMessage: (name, description, url, category) => appState
                    .createNewExercise(name, description, url, category),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewExercise extends StatefulWidget {
  const NewExercise({
    super.key,
    required this.addMessage,
  });
  final FutureOr<void> Function(
      String name, String description, String url, int category) addMessage;

  @override
  State<NewExercise> createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_NewWorkoutState');
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 40.0, bottom: 40.0, left: 20.0, right: 20.0),
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 40,
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Exercise Name',
                        contentPadding: const EdgeInsets.only(
                            left: 10.0, bottom: 4.0, top: 8.0),
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 12,
                              bottom: 12,
                              right: 0,
                              left: 12,
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
                          flex: 2,
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
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLength: 255,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Exercise Description',
                        contentPadding: const EdgeInsets.only(
                          left: 12.0,
                          top: 20.0,
                          right: 12.0,
                          bottom: 12.0,
                        ),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 5, // <-- SEE HERE
                      maxLines: 5, // <-- SEE HERE
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLength: 160,
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: 'Example Video URL',
                        contentPadding: const EdgeInsets.only(
                          left: 12.0,
                          top: 20.0,
                          right: 12.0,
                          bottom: 12.0,
                        ),
                        border: OutlineInputBorder(),
                      ),

                      keyboardType: TextInputType.url,
                      minLines: 1, // <-- SEE HERE
                      maxLines: 1, // <-- SEE HERE
                    ),
                    Spacer(),
                    MaterialButton(
                      color: Colors.blueAccent,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await widget.addMessage(
                              _nameController.text,
                              _descriptionController.text,
                              _urlController.text,
                              1);
                          _nameController.clear();
                          _urlController.clear();
                          _descriptionController.clear();
                        }
                      },
                      height: 50,
                      minWidth: 300,
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
