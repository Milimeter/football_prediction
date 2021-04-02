import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:predict_vip/screen/authScreen/loginregister.dart';
import 'package:predict_vip/screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    navigateUser();
  }

  navigateUser() {
    // checking whether user already loggedIn or not
    FirebaseAuth.instance.currentUser().then((currentUser) {
      if (currentUser == null) {
        Timer(
            Duration(seconds: 5),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginRegisterPage()),
                ));
      } else {
        Timer(
          Duration(seconds: 5),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // design the ui of this screen
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            child: Center(child: Image.asset('assets/betting.png')),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  child: ListTile(
                title: Center(
                  child: Text('from',
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                ),
                subtitle: Center(
                  child: Text('Lyon and Millimeter',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w800)),
                ),
              )),
            ],
          )
        ],
      ),
    );
  }
}
