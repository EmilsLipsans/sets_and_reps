import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtk_flutter/pages/calendar.dart';
import 'package:gtk_flutter/pages/login_screen.dart';
import 'package:gtk_flutter/pages/workout_create.dart';
import 'package:gtk_flutter/pages/home.dart';
import 'package:gtk_flutter/pages/profile.dart';
import 'package:gtk_flutter/pages/workouts.dart';
import 'package:gtk_flutter/utils/nameLists.dart';
import 'package:provider/provider.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) {
          return MyHomePage(title: 'Home');
        },
        '/sign-in': ((context) {
          return SignInScreen(
            actions: [
              ForgotPasswordAction(((context, email) {
                Navigator.of(context)
                    .pushNamed('/forgot-password', arguments: {'email': email});
              })),
              AuthStateChangeAction(((context, state) {
                if (state is SignedIn || state is UserCreated) {
                  var user = (state is SignedIn)
                      ? state.user
                      : (state as UserCreated).credential.user;
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                        content: Text(
                            'Please check your email to verify your email address'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                }
              })),
            ],
          );
        }),
        '/forgot-password': ((context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'] as String,
            headerMaxExtent: 200,
          );
        }),
        '/profile': ((context) {
          return ProfileScreen(
            providers: const [],
            actions: [
              SignedOutAction(
                ((context) {
                  Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                }),
              ),
            ],
          );
        })
      },
      title: 'Sets&Reps',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.deepPurple,
            ),
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final screens = [
    HomePage(),
    CalendarPage(),
    WorkoutsPage(),
    ProfilePage(),
  ];
  List menuTitle = [
    'Home',
    'Calendar',
    'Workouts',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Selector<ApplicationState, bool>(
      selector: (_, appState) => appState.loggedIn,
      builder: (_, loggedIn, __) {
        return loggedIn
            ? Scaffold(
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  iconSize: 28,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month),
                      label: 'Calendar',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.fitness_center),
                      label: 'Workouts',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.blueAccent,
                  onTap: _onItemTapped,
                ),
                // floatingActionButton: floatingButtons[_selectedIndex],
                body: screens[_selectedIndex],
              )
            : LoginScreen();
      },
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  bool getState() {
    return _loggedIn;
  }

  StreamSubscription<QuerySnapshot>? _exreciseListSubscription;
  List<Exrecises> _exreciseList = [];
  List<Exrecises> get exreciseList => _exreciseList;

  StreamSubscription<QuerySnapshot>? _workoutListSubscription;
  List<Workout> _workoutList = [];
  List<Workout> get workoutList => _workoutList;

  StreamSubscription<QuerySnapshot>? _workoutRecordListSubscription;
  List<WorkoutRecord> _latestWorkoutRecordList = [];
  List<WorkoutRecord> get latestWorkoutRecordList => _latestWorkoutRecordList;

  var kEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  StreamSubscription<QuerySnapshot>? _lastWorkoutRecordSubscription;
  late WorkoutRecord finalWorkout =
      WorkoutRecord(workoutID: '', recordedExercises: [], time: 0);

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;

        loadWorkouts(user);
        loadWorkoutRecords(user);
        loadLastWorkoutRecord(user);
        _exreciseListSubscription = FirebaseFirestore.instance
            .collection('exerices')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _exreciseList = [];
          for (final document in snapshot.docs) {
            _exreciseList.add(
              Exrecises(
                docID: document.id,
                name: document.data()['name'] as String,
                description: document.data()['description'] as String,
                url: document.data()['url'] as String,
                category: document.data()['category'] as int,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _exreciseList = [];
        _workoutList = [];
        _latestWorkoutRecordList = [];
        _exreciseListSubscription?.cancel();
        _workoutListSubscription?.cancel();
        _workoutRecordListSubscription?.cancel();
        _lastWorkoutRecordSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  loadWorkouts(user) {
    _workoutListSubscription = FirebaseFirestore.instance
        .collection('workouts')
        .where('userId', isEqualTo: user.uid)
        .orderBy("favorite", descending: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _workoutList = [];
      for (final document in snapshot.docs) {
        _workoutList.add(
          Workout(
            docID: document.id,
            exerciseRef:
                document.data()['exerciseRef'].cast<String>() as List<String>,
            name: document.data()['name'] as String,
            favorite: document.data()['favorite'] as bool,
          ),
        );
      }
      notifyListeners();
    });
  }

  loadLastWorkoutRecord(user) {
    _lastWorkoutRecordSubscription = FirebaseFirestore.instance
        .collection('workoutRecords')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      List recordedExerciseList = [];
      List sets = [];
      for (final document in snapshot.docs) {
        for (var exercise in document.data()['recordedExercises']) {
          for (var values in exercise.cast<String, dynamic>()['sets']) {
            sets.add({
              'weight': values.cast<String, dynamic>()['weight'],
              'reps': values.cast<String, dynamic>()['reps']
            });
          }
          recordedExerciseList.add({
            'exerciseID': exercise.cast<String, dynamic>()['exerciseID'],
            'sets': List.from(sets)
          });
          sets.clear();
        }
        finalWorkout = WorkoutRecord(
          workoutID: document.data()['workoutID'],
          recordedExercises: List.from(recordedExerciseList),
          time: document.data()['timestamp'] as int,
        );

        recordedExerciseList.clear();
      }
      notifyListeners();
    });
  }

  loadWorkoutRecords(user) {
    final twoWeeks = DateTime.now().millisecondsSinceEpoch - (2 * 604800000);
    _workoutRecordListSubscription = FirebaseFirestore.instance
        .collection('workoutRecords')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _latestWorkoutRecordList = [];
      var eventDate = 0;
      List<CalendarEvent> _workoutRecordList = [];
      List<Event> daysEvents = [];
      List recordedExerciseList = [];
      List sets = [];
      for (final document in snapshot.docs) {
        for (var exercise in document.data()['recordedExercises']) {
          for (var values in exercise.cast<String, dynamic>()['sets']) {
            sets.add({
              'weight': values.cast<String, dynamic>()['weight'],
              'reps': values.cast<String, dynamic>()['reps']
            });
          }
          recordedExerciseList.add({
            'exerciseID': exercise.cast<String, dynamic>()['exerciseID'],
            'sets': List.from(sets)
          });
          sets.clear();
        }
        if (document.data()['timestamp'] > twoWeeks) {
          _latestWorkoutRecordList.add(
            WorkoutRecord(
              workoutID: document.data()['workoutID'],
              recordedExercises: List.from(recordedExerciseList),
              time: document.data()['timestamp'] as int,
            ),
          );
        }
        if (DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(
                    document.data()['timestamp'])) ==
                DateFormat.MMMd()
                    .format(DateTime.fromMillisecondsSinceEpoch(eventDate)) ||
            snapshot.docs.indexOf(document) == 0) {
          daysEvents.add(Event(
              workoutName(document.data()['workoutID'], workoutList),
              document.data()['workoutID'],
              document.id));
          eventDate = document.data()['timestamp'];
        } else {
          _workoutRecordList.add(
            CalendarEvent(
              eventDate,
              List.from(daysEvents),
            ),
          );
          daysEvents.clear();
          daysEvents.add(Event(
              workoutName(document.data()['workoutID'], workoutList),
              document.data()['workoutID'],
              document.id));
          eventDate = document.data()['timestamp'];
        }

        recordedExerciseList.clear();
      }
      kEvents.clear();

      var _kEventSource = Map.fromIterable(_workoutRecordList,
          key: (item) => DateTime.fromMillisecondsSinceEpoch(item.eventDate),
          value: (item) => item.eventList as List<Event>);
      kEvents..addAll(_kEventSource);
      _workoutRecordList.clear();
      _kEventSource.clear();
      notifyListeners();
    });
  }

  Future<DocumentReference> recordWorkout(String workoutID, List recordList) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('workoutRecords')
        .add(<String, dynamic>{
      'workoutID': workoutID,
      'recordedExercises': recordList,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> deleteWorkoutRecord(String docID) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    return FirebaseFirestore.instance
        .collection('workoutRecords')
        .doc('$docID')
        .delete();
  }

  Future<void> favoriteWorkout(String docID, bool favorite) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    return FirebaseFirestore.instance
        .collection('workouts')
        .doc('$docID')
        .update({
      'favorite': favorite,
    });
  }

  Future<DocumentReference> createNewWorkout(String workout, List listOfIDs) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('workouts')
        .add(<String, dynamic>{
      'name': workout,
      'exerciseRef': listOfIDs,
      'favorite': false,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> deleteWorkout(String docID) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    return FirebaseFirestore.instance
        .collection('workouts')
        .doc('$docID')
        .delete();
  }

  Future<void> updateWorkout(String workout, List listOfIDs, String docID) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('workouts')
        .doc('$docID')
        .update({
      'name': workout,
      'exerciseRef': listOfIDs,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<DocumentReference> createNewExercise(
      String name, String description, String url, int category) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('exerices')
        .add(<String, dynamic>{
      'name': name,
      'description': description,
      'url': url,
      'category': category,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> updateExercise(
      String name, String description, String url, int category, String docID) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('exerices')
        .doc('$docID')
        .update({
      'name': name,
      'description': description,
      'url': url,
      'category': category,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> deleteExercise(String docID) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    return FirebaseFirestore.instance
        .collection('exerices')
        .doc('$docID')
        .delete();
  }
}
