import 'package:sensors_plus/sensors_plus.dart';
import 'package:rxdart/rxdart.dart';

class GyroscopeService {
  Stream<GyroscopeEvent> getGyroscopeStream() {
    return SensorsPlatform.instance.gyroscopeEvents
        .throttleTime(const Duration(seconds: 1));
  }
}
