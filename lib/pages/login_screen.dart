import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _handleSignOut() => _googleSignIn.disconnect();
  @override
  void initState() {
    _handleSignOut();
    super.initState();
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              SafeArea(
                  child: Container(
                height: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      Text(
                        'Sets & Reps',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        "Let's start recording!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      EmailAuthButton(
                        style: AuthButtonStyle(
                          buttonColor: Colors.blue,
                          borderWidth: 3.0,
                          width: double.infinity,
                          height: 50.0,
                          iconSize: 28.0,
                          separator: 10.0,
                          iconColor: Colors.white,
                          progressIndicatorType: AuthIndicatorType.circular,
                          visualDensity: VisualDensity.standard,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/sign-in');
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GoogleAuthButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        style: AuthButtonStyle(
                          buttonColor: Colors.white,
                          borderWidth: 3.0,
                          width: double.infinity,
                          height: 50.0,
                          iconSize: 28.0,
                          separator: 10.0,
                          progressIndicatorType: AuthIndicatorType.circular,
                          visualDensity: VisualDensity.standard,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      SizedBox(
                        height: 100.0,
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
