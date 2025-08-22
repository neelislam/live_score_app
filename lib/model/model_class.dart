class LiveScore {
  final String id;
  final String team1;
  final String team2;
  final int team1_score;
  final int team2_score;
  final bool isRunning;
  final String winner_team;
  final String time;
  final String total_time;
  final String team1_logo;
  final String team2_logo;

  LiveScore({
    required this.id,
    required this.team1,
    required this.team2,
    required this.team1_score,
    required this.team2_score,
    required this.isRunning,
    required this.winner_team,
    required this.time,
    required this.total_time,
    required this.team1_logo,
    required this.team2_logo,
  });
}
