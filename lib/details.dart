import 'package:firebase_demo/widgets/score_card.dart';
import 'package:flutter/material.dart';
import 'model/model_class.dart';
class DetailsScreen extends StatelessWidget {
  final LiveScore liveScore;
  const DetailsScreen({super.key, required this.liveScore});
  double _calculateProgress(String current, String total) {
    try {
      int currentMinutes = int.parse(current.split(":")[0]);
      int totalMinutes = int.parse(total.split(":")[0]);
      return currentMinutes / totalMinutes;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress(liveScore.time, liveScore.total_time);

    return Scaffold(
      appBar: AppBar(title: Text("${liveScore.team1} vs ${liveScore.team2}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScoreCard(liveScore: liveScore),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        liveScore.team1_logo,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      Text(liveScore.team1,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      "VS",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 120, // set width for progress bar
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("${liveScore.time} / ${liveScore.total_time}",
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Image.network(
                        liveScore.team2_logo,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      Text(liveScore.team2,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
