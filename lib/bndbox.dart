import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

List<dynamic> _inputArr = [];
String _label = 'Wrong Pose';
double _percent = 0;
double _counter = 0;

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
          // print('x: ' + x.toString());
          // print('y: ' + y.toString());

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

        // print("Input Arr: " + _inputArr.toList().toString());
        _getPrediction(_inputArr.cast<double>().toList());

        _inputArr.clear();
        // print("Input Arr after clear: " + _inputArr.toList().toString());

        lists..addAll(list);
      });
      return lists;
    }

    return Stack(children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 16.0),
            child: Text(
              _label.toString(),
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: 20.0,
              animationDuration: 500,
              animateFromLastPercent: true,
              percent: _counter,
              center: Text("${(_counter * 100).toStringAsFixed(1)} %"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            ),
          ),
        ],
      ),
      Stack(
        children: _renderKeypoints(),
      ),
    ]);
  }

  Future<void> _getPrediction(List<double> poses) async {
    try {
      final double result = await platform.invokeMethod('predictData', {
        "model": customModel,
        "arg": poses,
      }); // passing arguments

      _percent = result;
      _label =
          result < 0.5 ? "Wrong Pose" : (result * 100).toStringAsFixed(0) + "%";
      updateCounter(_percent);

      print("Final Label: " + result.toString());
    } on PlatformException catch (e) {
      return e.message;
    }
  }

  void updateCounter(perc) {
    if (perc > 0.5) {
      (_counter += perc / 100) >= 1 ? _counter = 1.0 : _counter += perc / 100;
    }
    print("Counter: " + _counter.toString());
  }
}
