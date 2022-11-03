import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class LoggedIn extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ProfileScreen(
          providers: const [],
          actions: [
            SignedOutAction(
              ((context) {
                Navigator.of(context).popUntil(ModalRoute.withName('/sign-in'));
              }),
            ),
          ],
        ),
      );
}
