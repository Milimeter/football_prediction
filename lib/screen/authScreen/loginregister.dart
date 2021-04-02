import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:predict_vip/resources/authentication.dart';

import 'package:predict_vip/screen/authScreen/signuppage.dart';
import 'package:predict_vip/screen/home_screen.dart';

class LoginRegisterPage extends StatefulWidget {
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage>
    with TickerProviderStateMixin {
  Animation animation, delayedAnimation, muchDelayedAnimation;
  AnimationController animationController;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  bool _isLoading;
  bool _isEmailVerified = false;

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
  dispose() {
    passwordTextEditingController.clear();
    emailTextEditingController.clear();
    super.dispose();
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  AuthMethods authMethods = AuthMethods();
  // performs signup
  void validateAndSubmit() async {
    print("performing login...");
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      String userId = "";
      try {
        await authMethods.signIn(emailTextEditingController.text,
            passwordTextEditingController.text);
        await _checkEmailVerification();
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));

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

  _checkEmailVerification() async {
    _isEmailVerified = await authMethods.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _resentVerifyEmail() async {
    await authMethods.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  _showVerifyEmailDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () async {
                await _resentVerifyEmail();
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Transform(
                            transform: Matrix4.translationValues(
                                animation.value * width, 0.0, 0.0),
                            child: Container(
                                padding: EdgeInsets.fromLTRB(15.0, 110.0, 0, 0),
                                child: Text('Hello',
                                    style: TextStyle(
                                        fontSize: 80.0,
                                        fontWeight: FontWeight.bold))),
                          ),
                          Transform(
                            transform: Matrix4.translationValues(
                                animation.value * width, 0.0, 0.0),
                            child: Container(
                                padding: EdgeInsets.fromLTRB(16.0, 175.0, 0, 0),
                                child: Text('There',
                                    style: TextStyle(
                                        fontSize: 80.0,
                                        fontWeight: FontWeight.bold))),
                          ),
                          Transform(
                            transform: Matrix4.translationValues(
                                animation.value * width, 0.0, 0.0),
                            child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(220.0, 175.0, 0, 0),
                                child: Text('.',
                                    style: TextStyle(
                                        fontSize: 80.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue))),
                          )
                        ],
                      ),
                      Transform(
                        transform: Matrix4.translationValues(
                            delayedAnimation.value * width, 0.0, 0.0),
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 35, left: 20.0, right: 20.0),
                          child: Column(children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailTextEditingController,
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
                            TextFormField(
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
                              obscureText: true,
                              validator: (value) {
                                return value.isEmpty
                                    ? 'Password is required.'
                                    : null;
                              },
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              alignment: Alignment(1.0, 0),
                              padding: EdgeInsets.only(top: 15.0, left: 20.0),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return ForgotPassword();
                                      });
                                },
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
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
                                      'LOGIN',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )),
                                  )),
                            ),
                          ]),
                        ),
                      ),
                      Transform(
                          transform: Matrix4.translationValues(
                              muchDelayedAnimation.value * width, 0.0, 0.0),
                          child: SizedBox(height: 15.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'New to Predict ?',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          SizedBox(width: 5.0),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage())),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ]),
          );
        });
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

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailTextEditingController = TextEditingController();
  AuthMethods authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    resetPassword() async {
      if (emailTextEditingController.text.isNotEmpty) {
        authMethods.sendPasswordResetMail(emailTextEditingController.text);
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue,
          content: Text("Reset password email has been sent"),
        ));
      }
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "Forgot Password?",
      ),
      content: Column(
        children: [
          TextFormField(
            controller: emailTextEditingController,
            decoration: InputDecoration(
              hintText: "Enter your Email",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            onPressed: () {
              resetPassword();
              Navigator.pop(context);
            },
            child: Text("Reset Password"),
          )
        ],
      ),
    );
  }
}
