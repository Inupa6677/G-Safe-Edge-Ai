import 'package:sensors_plus/sensors_plus.dart';
import 'package:rxdart/rxdart.dart';

class AccelerometerService {
  Stream<AccelerometerEvent> getAccelerometerStream() {
    return SensorsPlatform.instance.accelerometerEvents
        .throttleTime(const Duration(seconds: 1));
  }
}
