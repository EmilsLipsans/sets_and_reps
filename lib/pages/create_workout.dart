import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  ];
  List<DropdownMenuItem<String>> addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights() {
    List<double> itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  final List<double> gapSize = [12, 12, 4, 10];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
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
                        top: gapSize[0],
                        bottom: gapSize[1],
                        right: gapSize[2],
                        left: gapSize[3],
                      ),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Exercises:',
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
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: addDividersAfterItems(items),
                          customItemsHeights: _getCustomItemsHeights(),
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
              const SizedBox(
                height: 240,
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
