// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/workout_start_details.dart';
import 'package:gtk_flutter/utils/nameLists.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(2022, 10, 1);
final kLastDay = DateTime(2032, 12, 31);

class Event {
  final String title;
  final List recordedExerciseList;
  final String docID;

  Event(this.title, this.recordedExerciseList, this.docID);

  @override
  String toString() => title;
}

class CalendarEvent {
  final int eventDate;
  final List<Event> eventList;
  CalendarEvent(this.eventDate, this.eventList);
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Expanded(
              child: CalendarBody(
                kEvents: appState.kEvents,
                exreciseList: appState.exerciseList,
                deleteWorkoutRecord: (docID) =>
                    appState.deleteWorkoutRecord(docID),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarBody extends StatefulWidget {
  const CalendarBody(
      {super.key,
      required this.kEvents,
      required this.deleteWorkoutRecord,
      required this.exreciseList});
  final kEvents;
  final exreciseList;
  final FutureOr<void> Function(String docID) deleteWorkoutRecord;
  @override
  _CalendarPageBodyState createState() => _CalendarPageBodyState();
}

class _CalendarPageBodyState extends State<CalendarBody> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void onDelete() {
    setState(() {
      _selectedDay = _focusedDay;
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return widget.kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Event>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            markerDecoration: BoxDecoration(
              color: Color.fromRGBO(68, 138, 255, 0.6),
              shape: BoxShape.circle,
            ),
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
          ),
          onDaySelected: _onDaySelected,
          onRangeSelected: _onRangeSelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: ListTile(
                        leading: SizedBox(),
                        // onTap: () => print('${value[index].id}'),
                        title: Text('${value[index].title}'),
                        trailing: PopupMenuButton(
                          onSelected: (selected) {
                            if (selected == 0) {
                              recordDetails(value[index]);
                            }

                            if (selected == 1) {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Confirm delete'),
                                  content: Text(
                                      'Are you sure you want to permanently delete this recording? '),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.deleteWorkoutRecord(
                                              value[index].docID);
                                          value.removeAt(index);
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
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
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            const PopupMenuItem(
                              child: Text('See Details'),
                              value: 0,
                            ),
                            PopupMenuDivider(),
                            const PopupMenuItem(
                              child: Text('Delete'),
                              value: 1,
                            ),
                          ],
                        ),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  recordDetails(event) {
    return showDialog(
        useSafeArea: true,
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;
                  return Container(
                    height: height / 1.5,
                    width: width / 1.5,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(children: [
                            Text('${event.title}'),
                            SizedBox(height: 5),
                            const Divider(
                              color: Colors.grey,
                              height: 20,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                            ),
                          ]),
                        ),
                        Expanded(
                          flex: 6,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              for (var set in event.recordedExerciseList)
                                Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(68, 138, 255, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    title: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: Text(
                                          exerciseName(set['exerciseID'],
                                              widget.exreciseList),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        for (var value in set['sets'])
                                          Card(
                                            clipBehavior: Clip.hardEdge,
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5.0),
                                                      child: Text(
                                                        "${set['sets'].indexOf(value) + 1}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "${value['weight']} kgs",
                                                        textAlign:
                                                            TextAlign.right,
                                                      )),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "${value['reps']} reps",
                                                        textAlign:
                                                            TextAlign.right,
                                                      )),
                                                ],
                                              ),
                                              tileColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                          ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                    tileColor:
                                        Color.fromRGBO(68, 138, 255, 0.6),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        MaterialButton(
                          color: Color.fromARGB(255, 230, 230, 230),
                          child: const Text("Close"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ));
  }
}
