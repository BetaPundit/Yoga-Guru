package com.example.yogaguru;

import org.tensorflow.lite.Interpreter;
import android.os.Bundle;
import java.util.ArrayList;
import java.lang.Integer;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import android.content.res.AssetFileDescriptor;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "ondeviceML";
  protected Interpreter tflite;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    try {
      tflite = new Interpreter(loadModelFile());
    } catch (Exception e) {
      System.out.println("Exception while loading: " + e);
    }

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("predictData")) {
          ArrayList<Double> args = new ArrayList<>();
          args = call.argument("arg");
          String prediction = predictData(args);
          if (prediction != null) {
            result.success(prediction);
          } else {
            result.error("UNAVAILABLE", "prediction  not available.", null);
          }
        } else {
          result.notImplemented();
        }
      }
    });
  }

  // This method interact with our model and makes prediction returning value of
  // "0" or "1".
  String predictData(ArrayList<Double> input_data) {
    Double intArray[] = new Double[input_data.size()];
    int i = 0;
    for (Double e : input_data) {
      intArray[i] = e;
      i++;
    }
    System.out.println("Array: " + intArray);
    float[] output_datas = new float[3];
    tflite.run(intArray, output_datas);
    System.out.println("Output: " + output_datas);
    if (output_datas[0] > 0.5) {
      return "0";
    } else if (output_datas[1] > 0.5) {
      return "1";
    } else {
      return "2";
    }
  }

  // method to load tflite file from device

  private MappedByteBuffer loadModelFile() throws Exception {
    AssetFileDescriptor fileDescriptor = this.getAssets().openFd("model/yoga_classifier.tflite");
    FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
    FileChannel fileChannel = inputStream.getChannel();
    long startOffset = fileDescriptor.getStartOffset();
    long declaredLength = fileDescriptor.getDeclaredLength();
    return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
  }
}