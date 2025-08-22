import 'package:flutter/material.dart';
import '../model/model_class.dart';
class ScoreCard extends StatelessWidget {
  final LiveScore liveScore;
  const ScoreCard({super.key, required this.liveScore});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${liveScore.team1} vs ${liveScore.team2}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "${liveScore.team1_score} : ${liveScore.team2_score}",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Time : ${liveScore.time}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Total Time : ${liveScore.total_time}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}