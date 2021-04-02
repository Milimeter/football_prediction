import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:predict_vip/resources/authentication.dart';
import 'package:predict_vip/screen/authScreen/loginregister.dart';



class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();  

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  Animation animation, delayedAnimation, muchDelayedAnimation;
  AnimationController animationController;
  final _formKey = new GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading;

  @override
  dispose() {
    usernameTextEditingController.clear();
    passwordTextEditingController.clear();
    confirmPasswordTextEditingController.clear();
    emailTextEditingController.clear();
    super.dispose();
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (passwordTextEditingController.text ==
        confirmPasswordTextEditingController.text) {
      if (form.validate()) {
        form.save();
        return true;
      }
    }
    return false;
  }

  AuthMethods authMethods = AuthMethods();
  // performs signup
  validateAndSubmit() async {
    print("authentication process");
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await authMethods.signUp(emailTextEditingController.text,
            passwordTextEditingController.text);

        authMethods.sendEmailVerification();
        FirebaseUser user = await _auth.currentUser();
        await authMethods.addDataToDb(
            currentUser: user,
            username: usernameTextEditingController.text,
            password: passwordTextEditingController.text);
        String userId = user.uid;
        _showVerifyEmailSentDialog();
        print('Signed up user: $userId');
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

   _showVerifyEmailSentDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                //_changeFormToLogin();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginRegisterPage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController,
    ));

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      parent: animationController,
    ));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn),
      parent: animationController,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    animationController.forward();

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          body: Stack(children: [
            _showCircularProgress(),
            Container(
              margin: EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Transform(
                          transform: Matrix4.translationValues(
                            animation.value * width,
                            0.0,
                            0.0,
                          ),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(15.0, 175.0, 0, 0),
                              child: Text('Signup',
                                  style: TextStyle(
                                      fontSize: 80.0,
                                      fontWeight: FontWeight.bold))),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(265.0, 175.0, 0, 0),
                            child: Text('.',
                                style: TextStyle(
                                    fontSize: 80.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue)))
                      ],
                    ),
                    
                    Transform(
                      transform: Matrix4.translationValues(
                        muchDelayedAnimation.value * width,
                        0.0,
                        0.0,
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.only(top: 35, left: 20.0, right: 20.0),
                        child: Column(children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller:
                                emailTextEditingController, // controller for email
                            decoration: InputDecoration(
                              labelText: 'EMAIL',
                              labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            validator: (value) {
                              return value.isEmpty
                                  ? 'Email is required.'
                                  : null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          //Added username TextField
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller:
                                usernameTextEditingController, // controller for email
                            decoration: InputDecoration(
                              labelText: 'USERNAME',
                              labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            validator: (value) {
                              return value.isEmpty
                                  ? 'Username is required.'
                                  : null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            //changed from TextField to TextFormField
                            controller: passwordTextEditingController,
                            decoration: InputDecoration(
                                labelText: 'PASSWORD',
                                labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue))),
                            validator: (value) {
                              return value.isEmpty
                                  ? 'Password is required.'
                                  : null;
                            },
                            obscureText: true,
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            //changed from TextField to TextFormField
                            controller: confirmPasswordTextEditingController,
                            decoration: InputDecoration(
                                labelText: 'CONFIRM PASSWORD',
                                labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue))),
                            validator: (value) {
                              return value.isEmpty
                                  ? 'Password Confirmation is required.'
                                  : null;
                            },
                            obscureText: true,
                          ),
                          SizedBox(height: 40.0),
                          GestureDetector(
                            onTap: () {
                              validateAndSubmit();
                            },
                            child: Container(
                                height: 40.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  shadowColor: Colors.blueAccent,
                                  color: Colors.blue,
                                  elevation: 7.0,
                                  child: Center(
                                      child: Text(
                                    'SIGNUP',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )),
                                )),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                              margin: EdgeInsets.only(bottom: 40),
                              height: 40.0,
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 1.0),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacementNamed('/login');
                                  },
                                  child: Center(
                                      child: Text(
                                    'Go Back',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  )),
                                ),
                              )),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
