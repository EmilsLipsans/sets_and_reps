import 'package:flutter/material.dart';
import 'package:gtk_flutter/pages/workout_start.dart';

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StartWorkoutRoute()),
              );
            },
            tooltip: 'Start Workout',
            label: const Text('Start'),
            icon: const Icon(Icons.play_circle_outlined)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
            child: Column(
              children: [
                Expanded(
                  child: Card(
                    color: Color.fromRGBO(68, 138, 255, 0.6),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: Color.fromRGBO(68, 138, 255, 1),
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 10.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          Text(
                            'Last workout',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Upper back: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '2 Days ago',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: MaterialButton(
                              color: Colors.blue,
                              disabledColor: Colors.grey,
                              onPressed: () {},
                              child: Text(
                                "Details",
                                style: TextStyle(color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'History',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 20,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
