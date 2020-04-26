import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workout/services/services.dart';

class LoginScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlutterLogo(
            size: 150,
          ),
          Text(
            "Login to Start",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline,
          ),
          LoginButton(
            text: "Login With Google",
            icon: FontAwesomeIcons.google,
            loginMethod: () {
              auth.googleSignIn().then((_) {
                Navigator.pushNamed(context, "/home");
              });
            },
          ),
          Text(
            "Or",
            textAlign: TextAlign.center,
          ),
          LoginButton(
            text: "Login As Guest",
            icon: FontAwesomeIcons.user,
            loginMethod: () {
              auth.anonLogin().then((_) {
                Navigator.pushNamed(context, '/home');
              });
            },
          )
        ],
      ),
    ));
  }
}

class LoginButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function loginMethod;

  LoginButton({this.text, this.icon, this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: FlatButton.icon(
            icon: Icon(icon, color: Colors.blue),
            label: Text(text),
            onPressed: loginMethod,
            color: Theme.of(context).scaffoldBackgroundColor));
  }
}
