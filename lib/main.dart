import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:predict_vip/provider/user_provider.dart';
import 'package:predict_vip/screen/authScreen/loginregister.dart';

import 'package:predict_vip/screen/splash_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // wrapping the main widget with provider for state management
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), 
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        // goes to splash screen first to determine authentication status
        home: SplashScreen(), 
        debugShowCheckedModeBanner: false,
        routes: <String ,WidgetBuilder>{
          '/login':(BuildContext context) => LoginRegisterPage(), 
        },
      ),
    );
  }
}
