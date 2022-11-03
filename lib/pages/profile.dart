import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/src/authentication.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: ListView(
          children: <Widget>[
            Image.asset('assets/codelab.png'),
            const SizedBox(height: 8),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => AuthFunc(
                  loggedIn: appState.loggedIn,
                  signOut: () {
                    FirebaseAuth.instance.signOut();
                  }),
            ),
            const Divider(
              height: 8,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.grey,
            ),
          ],
        ),
      );
}
