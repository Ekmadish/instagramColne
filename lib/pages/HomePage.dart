
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((gSignIn) {
      controlSignIn(gSignIn);
    }, onError: (error) {
      print("just error  +$error");
    });

    _googleSignIn.signInSilently(suppressErrors: false).then((gSignIn) {
      controlSignIn(gSignIn);
    }).catchError((gError) {
      print(gError);
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  logoutUser() {
    _googleSignIn.signOut();
  }

  loginUSer() {
    _googleSignIn.signIn();
  }

  Widget buildHomeScreen() {
    return RaisedButton.icon(
      onPressed: logoutUser(),
      icon: Icon(Icons.logout),
      label: Text("Sign out "),
    );
  }

  Widget buildSignScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColorDark
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "FlutterGram",
              style: TextStyle(
                  fontSize: 92, color: Colors.white, fontFamily: "Signatra"),
            ),
            GestureDetector(
              onTap: loginUSer,
              child: Container(
                width: 270,
                height: 65,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/google_signin_button.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return buildHomeScreen();
    } else {
      return buildSignScreen();
    }
  }
}
