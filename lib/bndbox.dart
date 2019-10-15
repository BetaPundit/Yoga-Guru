import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var _prediction;

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
    // TODO: Run yoga_classifier.tflite
    var result = _getPrediction([
      520.2962666495902,
      174.74581960904396,
      516.421202612705,
      166.1106277724444,
      517.1866034836066,
      169.72461765095338,
      482.35434810450823,
      153.16652976860433,
      506.7509925717213,
      157.52833479541843,
      480.65266393442624,
      167.4305699235302,
      471.22099129098365,
      161.58514507746293,
      410.9952932889344,
      112.47123071702859,
      415.39052894467216,
      107.47942649711996,
      397.2461898053279,
      56.887098409361755,
      397.5016329405738,
      55.84913092144465,
      412.57383452868856,
      154.33921167405984,
      390.8998463114754,
      151.82183734441207,
      467.5105660860656,
      216.89435538599045,
      466.2657210553279,
      215.65033993478548,
      495.047387295082,
      308.1580003641419,
      495.19118212090166,
      309.76721812102755
    ]);
    print('Custom Model: ' + result.toString());

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

        lists..addAll(list);
      });

      return lists;
    }

    return Stack(
      children: _renderKeypoints(),
    );
  }

  Future<String> _getPrediction(List<double> poses) async {
    try {
      final String result = await platform
          .invokeMethod('predictData', {"arg": poses}); // passing arguments
      return result;
    } on PlatformException catch (e) {
      return e.message;
    }
  }
}
