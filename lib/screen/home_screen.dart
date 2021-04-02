import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:predict_vip/provider/user_provider.dart';
import 'package:predict_vip/screen/pages/nav_screens/free/free_main.dart';
import 'package:predict_vip/screen/pages/nav_screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:predict_vip/screen/pages/nav_screens/vipPost/vip_main.dart';

const String testDevice = '';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  

  
  bool isVisible = false;

  

  // instance of state management
  UserProvider userProvider;
  int _selectedIndex = 0;
  TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // for the nav bar pages
  List<Widget> _widgetOptions = <Widget>[
    //index 0
    FreeMain(),
    //index 1
    

    Vip(),
    // index 2
    ProfileScreen(),

    

  ];

  @override
  void initState() {
    super.initState();
    //get current user information from database
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
    });
  
  }

  

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Colors.blue,
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  
                  GButton(
                    icon: LineIcons.lightbulb_o,
                    text: 'VIP',
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'Profile',
                  ),
                  
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                   
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
