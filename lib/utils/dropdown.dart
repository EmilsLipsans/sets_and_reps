import 'package:flutter/material.dart';

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

int getItemPos(String selectedValue, List<String> items) {
  int pos = 1;
  for (var item in items) {
    if (item == selectedValue) return pos;
    pos += 1;
  }
  return 0;
}

int filterByItemPos(String selectedValue, List<String> items) {
  int pos = 0;
  for (var item in items) {
    if (item == selectedValue) return pos;
    pos += 1;
  }
  return 0;
}

List<double> getCustomItemsHeights(List items) {
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
