import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../helper/summary_page.dart'; // <- make sure this path is correct

class ApiService {
  static Future<void> sendDataToBackend(
    List<Map<String, double>> accelData,
    List<Map<String, double>> gyroData,
    BuildContext context, 
  ) async {
    final payload = {
      'accel_data': accelData,
      'gyro_data': gyroData,
    };

    final url = Uri.parse("http://192.168.1.102:7071/api/trip_summary");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("✅ Data uploaded successfully!");
        final summary = jsonDecode(response.body);

        // Navigate to summary page with response data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryPage(summary: summary),
          ),
        );
      } else {
        print("❌ Failed to upload data: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error sending data: $e");
    }
  }
}
