import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:yoga_guru/inference.dart';

List<String> asanas = ['Trikonasana', 'Vrakshasana', 'Virbhadrasana'];

class BeginnerPoses extends StatelessWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;

  const BeginnerPoses({this.cameras, this.title, this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Hero(
          tag: 'title',
          child: Text(title),
        ),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(asanas[i]),
              onTap: () => _onSelect(context),
            ),
          );
        },
      ),
    );
  }

  void _onSelect(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InferencePage(
          cameras: cameras,
          title: 'Beginner',
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          customModel: 'yoga_classifier.tflite',
        ),
      ),
    );
  }
}
