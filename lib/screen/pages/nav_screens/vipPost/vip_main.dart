import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:predict_vip/models/user.dart';
import 'package:predict_vip/provider/user_provider.dart';

import 'package:predict_vip/screen/pages/nav_screens/vipPost/vip_games_tomorrows.dart';
import 'package:predict_vip/screen/pages/nav_screens/vipPost/vip_games_previous.dart';
import 'package:predict_vip/screen/pages/nav_screens/vipPost/vip_games_current.dart';
import 'package:predict_vip/screen/upload/upload.dart';
import 'package:provider/provider.dart';

class Vip extends StatefulWidget {
  @override
  _VipState createState() => _VipState();
}

class _VipState extends State<Vip> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
     UserProvider userProvider = Provider.of<UserProvider>(context);
    UserData user = userProvider.getUser;
    if (user.email == "augustinepatrick04@gmail.com" || user.email == "razaqolad300@gmail.com") {
      setState(() {
        isVisible = true;
      });
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            AnimatedSwitcher(
                duration: Duration(seconds: 2),
                child: isVisible
                    ? IconButton(
                        icon: Icon(LineIcons.upload, color: Colors.white),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadPredictions())))
                    : SizedBox()),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(),
          ),
          title: Text(
            "VIP Predictions",
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
            VipPrevious(),
            VipCurrent(),
            VipTomorrow(),
            //Register(),
          ],
        )),
      ),
    );
  }
}
