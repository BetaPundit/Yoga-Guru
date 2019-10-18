import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import 'bndbox.dart';
import 'camera.dart';

class InferencePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;

  const InferencePage({this.cameras, this.title, this.model});

  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _label = '';

  @override
  void initState() {
    super.initState();
    var res = loadModel();
    print('Model Response: ' + res.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Camera(
            cameras: widget.cameras,
            setRecognitions: setRecognitions,
          ),
          BndBox(
            results: _recognitions == null ? [] : _recognitions,
            previewH: max(_imageHeight, _imageWidth),
            previewW: min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
            customModel: 'yoga_classifier.tflite',
          ),
        ],
      ),
    );
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
      // _label = label;
    });
  }

  loadModel() async {
    return await Tflite.loadModel(
      model: widget.model,
    );
  }
}
