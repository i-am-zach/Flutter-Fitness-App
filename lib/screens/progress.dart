import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workout/screens/workout.dart';
import 'package:workout/services/services.dart';
import 'package:workout/shared/loading.dart';
import 'package:workout/shared/neumorphic.dart';

class ProgressTab extends StatelessWidget {
  final ReportService _reportService = ReportService();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    Stream<Report> reportStream = _reportService.reportStream(user);

    return StreamBuilder(
      stream: reportStream,
      builder: (context, snap) {
        if (snap.hasData) {
          Report report = snap.data;
          final ReportAggregation _reportTool =
              ReportAggregation(report: report);
          List<CompletionReport> recent =
              _reportService.recentReports(report, 24);

          int totalMinutes = _reportTool.totalMinutes();
          int weeklyMinutes = _reportTool.minutesBy(Duration(days: 7));
          int dailyMinutes = _reportTool.minutesBy(Duration(hours: 24));
          int streak = _reportTool.streak();
          Routine favoriteRoutine = _reportTool.favoriteRoutine();

          final Color _secondaryColor = Colors.pink;
          final Color _primaryColor = Colors.pink[400];

          return Stack(children: [
            Positioned(
                top: 0,
                left: 0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 3.0,
                      width: MediaQuery.of(context).size.width * 2,
                      color: _secondaryColor,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 75),
                      height: MediaQuery.of(context).size.height / 3.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: _secondaryColor,
                          borderRadius: BorderRadius.circular(50)),
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${user.name ?? 'Guest'}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 44))
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: IconCard(
                          icon: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Icon(FontAwesomeIcons.fire,
                                size: 100, color: Colors.pink),
                          ),
                          title: "Streak",
                          subtitle: "$streak days in a row!",
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconCard(
                          icon: Text("$dailyMinutes",
                              style: TextStyle(
                                fontSize: 90,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                              )),
                          title: "Minutes Today",
                          subtitle: "Keep going!",
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: IconCard(
                          icon: Text("$totalMinutes",
                              style: TextStyle(
                                fontSize: 90,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                              )),
                          title: "Total Minutes",
                          subtitle: "Nice work!",
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconCard(
                            icon: FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Image(
                                  color: _primaryColor,
                                  image: AssetImage(
                                      "assets/icons/trimmed_dumbell@3x.png")),
                            ),
                            title: "Favorite Workout",
                            subtitle: "${favoriteRoutine.title}",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutScreen(
                                      routine: favoriteRoutine,
                                    ),
                                  ));
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ]),
            ),
          ]);
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}

class IconCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Color highlightColor;
  final Function onTap;

  TextStyle titleStyle;
  TextStyle subtitleStyle;

  IconCard(
      {@required this.icon,
      @required this.title,
      @required this.subtitle,
      this.highlightColor,
      this.onTap}) {
    titleStyle = TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 18,
    );
    subtitleStyle = TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: highlightColor != null ? highlightColor : Colors.pink);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: icon,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(title, style: titleStyle),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(subtitle, style: subtitleStyle),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
