import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';

import 'package:gtk_flutter/src/authentication.dart';
import 'package:provider/provider.dart';

class LoggedOut extends StatelessWidget {
  final ApplicationState state = ApplicationState();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Consumer<ApplicationState>(
          builder: (context, appState, _) => AuthFunc(
              loggedIn: appState.loggedIn,
              signOut: () {
                FirebaseAuth.instance.signOut();
              }),
        ),
      );
}
