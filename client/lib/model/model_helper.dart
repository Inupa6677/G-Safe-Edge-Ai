import 'package:tflite_flutter/tflite_flutter.dart';

// This function loads the TFLite model from assets
Future<Interpreter> loadModel() async {
  try {
    final interpreter = await Interpreter.fromAsset('assets/model.tflite');
    return interpreter;
  } catch (e) {
    throw 'Error loading model: $e';
  }
}

// This function handles running inference
Future<List<dynamic>> runModelInference(List<double> input) async {
  final interpreter = await loadModel();

  var output = List.filled(1 * 2, 0).reshape([1, 2]);

  interpreter.run(input, output); 

  interpreter.close(); 

  return output; 
}
