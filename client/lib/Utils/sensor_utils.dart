import 'dart:math';

double calculateGForce(double x, double y, double z) {
  const gravity = 9.80665; // Earth's gravity in m/s²
  double magnitude = sqrt(x * x + y * y + z * z);
  return magnitude / gravity;
}

double calculateAcceleration(double x, double y, double z) {
  return sqrt(x * x + y * y + z * z);
}

double classifyRoad(double x, double y) {
  const double threshold = 0.5; 

  if (x.abs() > threshold && y.abs() > threshold) {
    return 1;  
  } else {
    return 0; 
  }
}

