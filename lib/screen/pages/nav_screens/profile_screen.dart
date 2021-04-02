import 'package:flutter/material.dart';
import 'package:predict_vip/models/user.dart';
import 'package:predict_vip/provider/user_provider.dart';
import 'package:predict_vip/screen/authScreen/loginregister.dart';
import 'package:provider/provider.dart';

const String testDevice = '';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserData user = userProvider.getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Profile',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              //color: Colors.white,
            )),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginRegisterPage()),
                  (Route<dynamic> route) => false,
                );
              })
        ],
      ),
      body: Details(
        username: user.username,
        email: user.email,
      ),
    );
  }
}

class Details extends StatelessWidget {
  final String username;
  final String email;

  const Details({Key key, this.username, this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ListTile(
              title: Text(username,
                  style: TextStyle(
                      //color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800)),
              subtitle: Row(
                children: <Widget>[
                  Text(email,
                      style: TextStyle(
                        //color: Colors.white,
                      )),
                ],
              ),
              leading: CircleAvatar(
                child: Icon(
                  Icons.perm_identity,
                  color: Colors.white,
                ),
                radius: 40,
              ),
            ),
          ),
        ),
        Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 100),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Text('from',
                      style: TextStyle(
                        //color: Colors.white,
                      )),
                ),
                subtitle: Text('Lyon and Millimeter',
                    style: TextStyle(
                        //color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
              ),
            ))
      ],
    );
  }
}
