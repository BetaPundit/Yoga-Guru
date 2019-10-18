import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<dynamic> _inputArr = [];
String _label;

class BndBox extends StatelessWidget {
  static const platform = const MethodChannel('ondeviceML');

  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String customModel;

  const BndBox({
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
    this.customModel,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      results.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (screenH / screenW > previewH / previewW) {
            scaleW = screenH / previewH * previewW;
            scaleH = screenH;
            var difW = (scaleW - screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = screenW / previewW * previewH;
            scaleW = screenW;
            var difH = (scaleH - screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }
          print('x: ' + x.toString());
          print('y: ' + y.toString());

          _inputArr.add(x);
          _inputArr.add(y);

          // To solve mirror problem on front camera
          if (x > 320) {
            var temp = x - 320;
            x = 320 - temp;
          } else {
            var temp = 320 - x;
            x = 320 + temp;
          }

          return Positioned(
            left: x - 275,
            top: y - 50,
            width: 100,
            height: 15,
            child: Container(
              child: Text(
                "● ${k["part"]}",
                style: TextStyle(
                  color: Color.fromRGBO(37, 213, 253, 1.0),
                  fontSize: 12.0,
                ),
              ),
            ),
          );
        }).toList();

        print("Input Arr: " + _inputArr.toList().toString());
        _getPrediction(_inputArr.cast<double>().toList());

        _inputArr.clear();
        print("Input Arr after clear: " + _inputArr.toList().toString());

        lists..addAll(list);
      });
      return lists;
    }

    return Stack(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            '$_label',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Stack(
        children: _renderKeypoints(),
      ),
    ]);
  }

  Future<void> _getPrediction(List<double> poses) async {
    try {
      final String result = await platform
          .invokeMethod('predictData', {"arg": poses}); // passing arguments
      _label = result.toString();
      print("Final Label: " + result);
    } on PlatformException catch (e) {
      return e.message;
    }
  }
}
