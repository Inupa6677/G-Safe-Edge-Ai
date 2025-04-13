import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TripSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int tripScore = 87;
    final String duration = "35 min";
    final String roadType = "Rough";
    final int safeWindows = 254;
    final int dangerousWindows = 17;

    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Summary"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.cloud_upload, color: Colors.blue),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 12.0,
              percent: tripScore / 100,
              center: Text(
                "$tripScore%",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.teal,
              backgroundColor: Colors.teal.shade100,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            SizedBox(height: 10),
            Text("Trip Score", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            infoRow("Duration", duration),
            infoRow("Road Type", roadType),
            infoRow("Safe Windows", safeWindows.toString()),
            infoRow("Dangerous Windows", dangerousWindows.toString(),
                isDanger: true),
            SizedBox(height: 30),
            Text(
              "Trip score uploaded\nsuccessfully",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value, {bool isDanger = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 16,
                color: isDanger ? Colors.red : Colors.black,
              )),
          Text(value,
              style: TextStyle(
                fontSize: 16,
                color: isDanger ? Colors.red : Colors.black,
              )),
        ],
      ),
    );
  }
}
