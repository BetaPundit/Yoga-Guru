import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga_guru/home.dart';
import 'package:yoga_guru/login.dart';
import 'package:yoga_guru/register.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String email = prefs.getString('email');
  String uid = prefs.getString('uid');
  String displayName = prefs.getString('displayName');
  String photoUrl = prefs.getString('photoUrl');

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }

  runApp(
    email != null && uid != null
        ? MyApp(
            email: email,
            uid: uid,
            displayName: displayName,
            photoUrl: photoUrl,
            cameras: cameras,
          )
        : MyApp(
            cameras: cameras,
          ),
  );
}

class MyApp extends StatelessWidget {
  final String email;
  final String uid;
  final String displayName;
  final String photoUrl;
  final List<CameraDescription> cameras;

  const MyApp({
    this.email,
    this.uid,
    this.displayName,
    this.photoUrl,
    this.cameras,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yoga Guru',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: email != null && uid != null
          ? Home(
              email: email,
              uid: uid,
              displayName: displayName,
              photoUrl: photoUrl,
              cameras: cameras,
            )
          : Login(
              cameras: cameras,
            ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Home(),
        '/login': (BuildContext context) => Login(),
        'register': (BuildContext context) => Register(),
      },
    );
  }
}
