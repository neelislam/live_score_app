import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'details.dart';
import 'model/model_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Football Live Score')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db.collection('football').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshots.hasError) {
            return Center(child: Text(snapshots.error.toString()));
          }

          if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
            return const Center(child: Text("No matches found"));
          }

          List<LiveScore> listOfScore = snapshots.data!.docs.map((doc) {
            return LiveScore(
              id: doc.id,
              team1: doc.get('team1'),
              team2: doc.get('team2'),
              team1_score: doc.get('team1_score'),
              team2_score: doc.get('team2_score'),
              isRunning: doc.get('isRunning'),
              winner_team: doc.get('winner_team'),
              time: doc.get('time'),
              total_time: doc.get('total_time'),
              team1_logo: doc.get('team1_logo'),
              team2_logo: doc.get('team2_logo'),
            );
          }).toList();

          return ListView.builder(
            itemCount: listOfScore.length,
            itemBuilder: (context, index) {
              LiveScore liveScore = listOfScore[index];

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsScreen(liveScore: liveScore),
                    ),
                  );
                },
                leading: CircleAvatar(
                  radius: 8,
                  backgroundColor:
                  liveScore.isRunning ? Colors.green : Colors.grey,
                ),
                title: Text("${liveScore.team1} vs ${liveScore.team2}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Is Running: ${liveScore.isRunning}'),
                    Text('Winner Team: ${liveScore.winner_team}'),
                  ],
                ),
                trailing: Text(
                  '${liveScore.team1_score} : ${liveScore.team2_score}',
                  style: const TextStyle(fontSize: 24),
                ),
              );
            },
          );
        },
      ),
    );
  }
}