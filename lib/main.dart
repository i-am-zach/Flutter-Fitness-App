import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/services/services.dart';
import 'screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _auth = AuthService();
  Color _color = Color(0XFFEFF3F6);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>(
          create: (context) => Global.userData.documentStream,
        ),
        StreamProvider<List<Routine>>(
          create: (context) => Global.userData.routineStream,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => TabScreen(),
        },
        theme: ThemeData(
            primarySwatch: Colors.cyan,
            backgroundColor: Color.lerp(_color, Colors.black, 0.005),
            scaffoldBackgroundColor: _color,
            dialogBackgroundColor: _color,
            appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                color: _color,
                textTheme: TextTheme(
                    title: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ))),
            iconTheme: IconThemeData(color: Colors.black)),
        home: DefaultTabController(
          length: 3,
          child: LoginScreen(),
        ),
      ),
    );
  }
}
