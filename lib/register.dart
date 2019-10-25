import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yoga_guru/util/auth.dart';

import 'home.dart';

class Register extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Register({this.cameras});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController _firstNameInputController;
  TextEditingController _lastNameInputController;
  TextEditingController _emailInputController;
  TextEditingController _pwdInputController;
  TextEditingController _confirmPwdInputController;

  @override
  initState() {
    _firstNameInputController = TextEditingController();
    _lastNameInputController = TextEditingController();
    _emailInputController = TextEditingController();
    _pwdInputController = TextEditingController();
    _confirmPwdInputController = TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (value.length == 0) {
      return 'Email cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length == 0) {
      return 'Password cannot be empty';
    } else if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            child: Column(
              children: <Widget>[
                // First Name Input
                TextFormField(
                  controller: _firstNameInputController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    hintText: "John",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // #7449D1
                    ),
                  ),
                  validator: (val) {
                    if (val.length < 3) {
                      return "Please Enter a valid first name!";
                    } else {
                      return null;
                    }
                  },
                ),

                SizedBox(
                  height: 32.0,
                ),

                // Last Name Input
                TextFormField(
                  controller: _lastNameInputController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    hintText: "Doe",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // #7449D1
                    ),
                  ),
                  validator: (val) {
                    if (val.length < 3) {
                      return "Please Enter a valid last name!";
                    } else {
                      return null;
                    }
                  },
                ),

                SizedBox(
                  height: 32.0,
                ),

                // Email Input
                TextFormField(
                  controller: _emailInputController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "john.doe@gmail.com",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // #7449D1
                    ),
                  ),
                  validator: emailValidator,
                ),

                SizedBox(
                  height: 32.0,
                ),

                // Password Input
                TextFormField(
                  controller: _pwdInputController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "********",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // #7449D1
                    ),
                  ),
                  validator: pwdValidator,
                ),

                SizedBox(
                  height: 32.0,
                ),

                // Confirm Password Input
                TextFormField(
                  controller: _confirmPwdInputController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "********",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // #7449D1
                    ),
                  ),
                  validator: pwdValidator,
                ),

                SizedBox(
                  height: 32.0,
                ),

                // Button
                Center(
                  child: ButtonTheme(
                    minWidth: 150.0,
                    child: FlatButton(
                      onPressed: _register,
                      color: Colors.deepPurpleAccent,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 32.0,
                ),

                // Sign in here
                Center(
                  child: FlatButton(
                    color: Colors.transparent,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Already have an account?\nSign in here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_registerFormKey.currentState.validate()) {
      if (_pwdInputController.text == _confirmPwdInputController.text) {
        Auth auth = Auth();
        FirebaseUser user = await auth
            .signUp(
          _emailInputController.text,
          _pwdInputController.text,
          _firstNameInputController.text,
          _lastNameInputController.text,
        )
            .catchError((err) {
          print(err);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("This email is already registered!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });

        if (user != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                email: user.email,
                uid: user.uid,
                displayName: user.displayName,
                photoUrl: user.photoUrl,
                cameras: widget.cameras,
              ),
            ),
            ModalRoute.withName('/login'),
          );
        }

        _firstNameInputController.clear();
        _lastNameInputController.clear();
        _emailInputController.clear();
        _pwdInputController.clear();
        _confirmPwdInputController.clear();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("The passwords do not match"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
