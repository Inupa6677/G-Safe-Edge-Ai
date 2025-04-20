import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final Map<String, dynamic> summary;

  const SummaryPage({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Trip Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SummaryItem(
            title: 'Harsh Braking',
            data: summary['harsh_breaking'],
          ),
          SummaryItem(
            title: 'Sudden Acceleration',
            data: summary['sudden_acceleration'],
          ),
          SummaryItem(
            title: 'Sudden Turn',
            data: summary['sudden_turn'],
          ),
          SafetyScoreItem(
            percentage: summary['safety_score']?['percentage']?.toDouble() ?? 0.0,
          ),
        ],
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;

  const SummaryItem({super.key, required this.title, required this.data});

  IconData _iconForTitle() {
    switch (title) {
      case 'Harsh Braking':
        return Icons.dangerous;
      case 'Sudden Acceleration':
        return Icons.speed;
      case 'Sudden Turn':
        return Icons.sync_alt;
      default:
        return Icons.show_chart;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _iconForTitle(),
              size: 32,
              color: Colors.teal,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Count: ${data['count']}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Percentage: ${data['percentage'].toStringAsFixed(2)}%",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SafetyScoreItem extends StatelessWidget {
  final double percentage;

  const SafetyScoreItem({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.shield, size: 32, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Safety Score",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${percentage.toStringAsFixed(2)}%",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
