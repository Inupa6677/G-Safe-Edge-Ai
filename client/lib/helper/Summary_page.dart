import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final Map<String, dynamic> summary;

  const SummaryPage({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Summary"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryItem(
              title: "Harsh Braking",
              data: summary["harsh_breaking"],
            ),
            SummaryItem(
              title: "Sudden Acceleration",
              data: summary["sudden_acceleration"],
            ),
            SummaryItem(
              title: "Sudden Turn",
              data: summary["sudden_turn"],
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;

  const SummaryItem({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 3,
      child: ListTile(
        title: Text(title),
        subtitle: Text(
            "Count: ${data["count"]}\nPercentage: ${data["percentage"].toStringAsFixed(2)}%"),
      ),
    );
  }
}
