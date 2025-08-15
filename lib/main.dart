import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const LiveScoreApp());
}

class LiveScoreApp extends StatelessWidget {
  const LiveScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LiveScore> _listOfScore = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> _getLiveScoreData() async {
    _listOfScore.clear();
    final QuerySnapshot<Map<String, dynamic>> snapshots = await db
        .collection('football')
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshots.docs) {
      LiveScore liveScore = LiveScore(
        id: doc.id,
        team1: doc.get('team1_name'),
        team2: doc.get('team2_name'),
        team1_score: doc.get('team1_score'),
        team2_score: doc.get('team2_score'),
        isRunning: doc.get('is_running'),
        winner_team: doc.get('winner_team'),
      );
      _listOfScore.add(liveScore);
    }
    setState(() {});
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _getLiveScoreData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FootBall Live Score')),
      body: StreamBuilder(
          stream: db.collection('football').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots) {

            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshots.hasError) {
              return Center(child: Text(snapshots.error.toString()));
            }

            if (snapshots.hasData) {
              _listOfScore.clear();
              for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshots.data!.docs) {
                LiveScore liveScore = LiveScore(
                  id: doc.id,
                  team1: doc.get('team1'),
                  team2: doc.get('team2'),
                  team1_score: doc.get('team1_score'),
                  team2_score: doc.get('team2_score'),
                  isRunning: doc.get('isRunning'),
                  winner_team: doc.get('winner_team'),
                );
                _listOfScore.add(liveScore);
              }
            }

            return ListView.builder(
              itemCount: _listOfScore.length,
              itemBuilder: (context, index) {
                LiveScore liveScore = _listOfScore[index];

                return ListTile(
                  leading: CircleAvatar(
                    radius: 8,
                    backgroundColor: liveScore.isRunning ? Colors.green : Colors.grey,
                  ),
                  title: Text(liveScore.id),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(liveScore.team1),
                          Text('  vs  '),
                          Text(liveScore.team2),
                        ],
                      ),
                      Text('Is Running: ${liveScore.isRunning}'),
                      Text('Winner Team: ${liveScore.winner_team}'),
                    ],
                  ),
                  trailing: Text(
                    '${liveScore.team1_score} : ${liveScore.team2_score}',
                    style: TextStyle(fontSize: 24),
                  ),
                );
              },
            );
          }
      ),
    );
  }
}

class LiveScore {
  final String id;
  final String team1;
  final String team2;
  final int team1_score;
  final int team2_score;
  final bool isRunning;
  final String winner_team;

  LiveScore({
    required this.id,
    required this.team1,
    required this.team2,
    required this.team1_score,
    required this.team2_score,
    required this.isRunning,
    required this.winner_team,
  });
}