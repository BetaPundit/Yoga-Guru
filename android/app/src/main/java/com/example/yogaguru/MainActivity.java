package com.example.yogaguru;

import org.tensorflow.lite.Interpreter;
import android.os.Bundle;

import java.io.InputStream;
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
import android.util.Log;

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
			throw new RuntimeException(e);
		}

		new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
			@Override
			public void onMethodCall(MethodCall call, Result result) {
				if (call.method.equals("predictData")) {
					ArrayList<Double> args = call.argument("arg");
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
	String predictData(ArrayList<Double> input_data) {
		float inputArray[][] = new float[1][input_data.size()];
		int i = 0;
		for (Double e : input_data) {
			inputArray[0][i] = e.floatValue();
			i++;
		}
		// System.out.println("Array: " + input_data);
		float[][] output_data = new float[1][3];
		tflite.run(inputArray, output_data);
		for (int j = 0; j < 3; j++)
			Log.d("tag", "o> " + output_data[0][j]);
		if (output_data[0][0] > 0.5) {
			return "0";
		} else if (output_data[0][1] > 0.5) {
			return "1";
		} else if (output_data[0][2] > 0.5) {
			return "2";
		} else {
			return "Wrong Pose";
		}
	}

	// method to load tflite file from device

	private MappedByteBuffer loadModelFile() throws Exception {
		// InputStream inputStream =
		// this.getResources().openRawResource(R.raw.yoga_classifier);
		AssetFileDescriptor fileDescriptor = this.getAssets().openFd("yoga_classifier.tflite");
		FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
		FileChannel fileChannel = inputStream.getChannel();
		long startOffset = fileDescriptor.getStartOffset();
		long declaredLength = fileDescriptor.getDeclaredLength();
		return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
	}
}