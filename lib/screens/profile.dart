import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/services/services.dart';
import 'package:workout/shared/loading.dart';
import 'package:workout/shared/neumorphic.dart';

class ProfileRoute extends StatelessWidget {
  const ProfileRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return StreamBuilder(
        stream: Global.userData.documentStream,
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            User user = snap.data;
            return Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      user.name ?? "Guest",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    NeumorphicButton(
                      text: Text("Log out"),
                      onTap: () {
                        _auth.signOut().then((_) {
                          Navigator.pushReplacementNamed(context, '/login');
                        });
                      },
                      constraints: BoxConstraints(maxWidth: 100),
                    )
                  ],
                ));
          }
          return Container();
        });
  }
}
