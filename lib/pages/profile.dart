import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/pages/loggedOut_profile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });
  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  // This widget is the root of your application.
  ApplicationState state = ApplicationState();
  Widget profilePageLook(bool loggedIn) {
    if (loggedIn == true) {
      return ProfileScreen(
        providers: const [],
        actions: [
          SignedOutAction(
            ((context) {
              Navigator.popAndPushNamed(context, '/home');
            }),
          ),
        ],
      );
    } else {
      return Text('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Selector<ApplicationState, bool>(
          selector: (_, appState) => appState.loggedIn,
          builder: (_, loggedIn, __) {
            return profilePageLook(loggedIn);
          },
        ),
      );
}
