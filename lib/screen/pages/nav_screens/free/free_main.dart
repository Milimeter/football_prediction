import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:predict_vip/screen/pages/nav_screens/free/free_games_current.dart';
import 'package:predict_vip/screen/pages/nav_screens/free/free_games_previous.dart';
import 'package:predict_vip/screen/pages/nav_screens/free/free_games_tomorrow.dart';

class FreeMain extends StatefulWidget {
  @override
  _FreeMainState createState() => _FreeMainState();
}

class _FreeMainState extends State<FreeMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(),
          ),
          title: Text(
            "Free Predictions",
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Billabong',
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                text:
                    "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))}", //yesterday
              ),
              Tab(
                icon: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                ),
                text: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
              ),
              Tab(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
                text:
                    "${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)))}",
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
            child: TabBarView(
          children: [
            FreeGamesScreenPrevious(),
            FreeGamesScreenCurrent(),
            FreeGamesScreenTomorrows(),
            //Register(),
          ],
        )),
      ),
    );
  }
}
