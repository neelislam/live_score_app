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
            final data = doc.data();
            return LiveScore(
              id: doc.id,
              team1: data['team1'] as String,
              team2: data['team2'] as String,
              team1_score: data['team1_score'] as int,
              team2_score: data['team2_score'] as int,
              isRunning: data['isRunning'] as bool,
              winner_team: data['winner_team'] as String,
              time: data['time'] as String,
              total_time: data['total_time'] as String,
              team1_logo: data['team1_logo'] as String,
              team2_logo: data['team2_logo'] as String,
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
                      builder: (context) => DetailsScreen(liveScore: liveScore),
                    ),
                  );
                },
                leading: CircleAvatar(
                  radius: 8,
                  backgroundColor: liveScore.isRunning ? Colors.green : Colors.grey,
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