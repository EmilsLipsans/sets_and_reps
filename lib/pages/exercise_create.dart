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
        title: const Text('Create Exercise'),
      ),
      resizeToAvoidBottomInset: true,
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: NewExercise(
                addExercise: (name, description, url, category) => appState
                    .createNewExercise(name, description, url, category),
                uniqueExerciseName: appState.uniqueExerciseName,
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
    required this.addExercise,
    required this.uniqueExerciseName,
  });
  final FutureOr<void> Function(
      String name, String description, String url, int category) addExercise;
  final uniqueExerciseName;
  @override
  State<NewExercise> createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_NewExerciseState');
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
    'Shoulders',
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
                          borderRadius: BorderRadius.circular(8.0),
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
                        'Select Category',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: addDividersAfterItems(items),
                      customItemsHeights: getCustomItemsHeights(items),
                      value: selectedValue,
                      validator: (value) {
                        if (value == null) {
                          return 'Select Exercise Category';
                        }
                        return null;
                      },
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
                      height: 40,
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                        labelText: 'Youtube Video URL',
                        contentPadding: const EdgeInsets.only(
                          left: 12.0,
                          top: 20.0,
                          right: 12.0,
                          bottom: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      keyboardType: TextInputType.url,
                      minLines: 1, // <-- SEE HERE
                      maxLines: 1, // <-- SEE HERE
                    ),
                    Spacer(),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (widget.uniqueExerciseName(
                              _nameController.text, '')) {
                            await widget.addExercise(
                                _nameController.text,
                                _descriptionController.text,
                                _urlController.text,
                                getItemPos(selectedValue as String, items));
                            _nameController.clear();
                            _urlController.clear();
                            _descriptionController.clear();
                            final snackBar = SnackBar(
                              content: const Text('Exercise Saved'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            final snackBar = SnackBar(
                              content: const Text('Exercise name is taken'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
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
            ],
          ),
        ),
      ),
    );
  }
}
