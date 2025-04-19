import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../services/accelerometer_service.dart';
import '../services/gyroscope_service.dart';
import '../utils/sensor_utils.dart';
import '../model/model_helper.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';  // Import NotificationService

class SensorPredictionScreen extends StatefulWidget {
  const SensorPredictionScreen({super.key});

  @override
  State<SensorPredictionScreen> createState() => _SensorPredictionScreenState();
}

class _SensorPredictionScreenState extends State<SensorPredictionScreen> {
  final AccelerometerService _accelerometerService = AccelerometerService();
  final GyroscopeService _gyroscopeService = GyroscopeService();

  late StreamSubscription<AccelerometerEvent> _accelSub;
  late StreamSubscription<GyroscopeEvent> _gyroSub;

  bool _isReading = false;
  Interpreter? _interpreter;

  double? _previousAcceleration;
  double? _lastPrediction;
  int? _lastClass;

  double _gyroMagnitude = 0.0;
  double roadType = 0.0;

  final List<Map<String, double>> accelData = [];
  final List<Map<String, double>> gyroData = [];

  void _start() async {
    if (_isReading) return;

    setState(() {
      _lastPrediction = null;
      _lastClass = null;
      accelData.clear();
      gyroData.clear();
    });

    try {
      _interpreter = await loadModel();
      _previousAcceleration = null;

      _gyroSub = _gyroscopeService.getGyroscopeStream().listen((gyroEvent) {
        roadType = classifyRoad(gyroEvent.x, gyroEvent.y);
        _gyroMagnitude = gyroEvent.z.abs();

        gyroData.add({
          'x': 0,
          'y': 0,
          'z': 0,
        });
      });

      _accelSub = _accelerometerService.getAccelerometerStream().listen((event) {
        final gForce = calculateGForce(event.x, event.y, event.z);
        final currentAccel = calculateAcceleration(event.x, event.y, event.z);
        final accelChange = _previousAcceleration != null
            ? (currentAccel - _previousAcceleration!).abs()
            : 0.0;
        _previousAcceleration = currentAccel;

        accelData.add({
          'x': event.x,
          'y': event.y,
          'z': event.z,
        });

        final input = [[gForce, accelChange, roadType, _gyroMagnitude]];
        final output = List.filled(1 * 1, 0.0).reshape([1, 1]);

        try {
          _interpreter?.run(input, output);

          final prediction = output[0][0];
          final predictedClass = prediction > 0.5 ? 1 : 0;

          setState(() {
            _lastPrediction = prediction;
            _lastClass = predictedClass;
          });

          // Check if prediction is 1 and show notification
          if (predictedClass == 0) {
            NotificationService.showDangerNotification();// Show notification
          }
        } catch (_) {
          setState(() {
            _lastPrediction = null;
            _lastClass = null;
          });
        }
      });

      setState(() {
        _isReading = true;
      });
    } catch (e) {
      setState(() {
        _isReading = false;
      });
    }
  }

  void _stop() async {
    if (_isReading) {
      _accelSub.cancel();
      _gyroSub.cancel();
      _interpreter?.close();

      // Send data to backend when user clicks "End"
      await ApiService.sendDataToBackend(accelData, gyroData, context);

      setState(() {
        _isReading = false;
      });
    }
  }

  @override
  void dispose() {
    if (_isReading) {
      _accelSub.cancel();
      _gyroSub.cancel();
    }
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String predictionText = _lastPrediction == null
        ? 'Waiting for prediction...'
        : 'Prediction: ${_lastPrediction!.toStringAsFixed(4)} → Class: $_lastClass';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),

          // Foreground content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isReading ? null : _start,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade700,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Start ▶'),
                  ),

                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isReading ? _stop : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade700,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('End ■'),
                  ),

                  const SizedBox(height: 60),
                  Text(
                    predictionText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Make text visible on background
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black54,
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
