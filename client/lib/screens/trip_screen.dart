import 'package:flutter/material.dart';
import 'trip_summary_screen.dart';

class TripScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trip Started")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TripSummaryScreen()),
            );
          },
          child: Text("End Trip"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: TextStyle(fontSize: 20),
            backgroundColor: Colors.red,
          ),
        ),
      ),
    );
  }
}
