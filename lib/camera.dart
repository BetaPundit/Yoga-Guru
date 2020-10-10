import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;

  const Camera({this.cameras, this.setRecognitions});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;
  int indexCamera = 0;

  static const platform = const MethodChannel('ondeviceML');

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        // widget.camera[0] for back camera
        // widget.camera[1] for front camera
        widget.cameras[1],
        ResolutionPreset.high,
      );

      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState((){});
        _poseCamera();

      });
    }
  }

  void _poseCamera(){
    controller.startImageStream((CameraImage img) {
      if (!isDetecting) {
        isDetecting = true;

        int startTime = new DateTime.now().millisecondsSinceEpoch;

        Tflite.runPoseNetOnFrame(
          bytesList: img.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: img.height,
          imageWidth: img.width,
          numResults: 1,
          rotation: -90,
          threshold: 0.2,
          nmsRadius: 10,
        ).then((recognitions) {
          int endTime = new DateTime.now().millisecondsSinceEpoch;
          print("Detection took ${endTime - startTime}");

          widget.setRecognitions(recognitions, img.height, img.width);

          isDetecting = false;
        });
      }
    });
  }


  void _onSwitchCamera() {
    indexCamera = indexCamera < widget.cameras.length - 1 ? indexCamera + 1 : 0;

    controller = new CameraController(
      widget.cameras[indexCamera],
      ResolutionPreset.high,
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState((){});
      _poseCamera();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return Stack(
      children: <Widget> [
        OverflowBox(
          maxHeight: screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
          maxWidth: screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
          child: CameraPreview(controller),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FloatingActionButton(
            onPressed: () {
              _onSwitchCamera();
            },
            child: Icon(Icons.switch_camera),
            backgroundColor: Colors.green,
            elevation: 5,
          ),
        )
      ],
    );
  }
}