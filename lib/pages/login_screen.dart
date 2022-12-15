import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auth_buttons/auth_buttons.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Continue with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GoogleAuthButton(
            onPressed: () {},
            style: AuthButtonStyle(
              buttonType: AuthButtonType.icon,
            ),
          ),
          SizedBox(
            width: 40,
          ),
          FacebookAuthButton(
            onPressed: () {},
            style: AuthButtonStyle(
              buttonType: AuthButtonType.icon,
            ),
          ),
        ],
      ),
    );
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
                      Text(
                        'Sets & Reps',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      SizedBox(height: 30.0),
                      Text(
                        "Let's start recording!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
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
                      _buildSignInWithText(),
                      _buildSocialBtnRow(),
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
