import 'package:cloud_firestore/cloud_firestore.dart';
import '../game/constants.dart';
import 'auth_service.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Submit score to leaderboard
  static Future<void> submitScore({
    required int score,
    required GameMode gameMode,
    GameTheme? theme,
  }) async {
    final playerName = await AuthService.getUserName() ?? 'Anonymous';
    await _db.collection('leaderboard').add({
      'playerName': playerName,
      'score': score,
      'gameMode': gameMode.name,
      'theme': theme?.name,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
  
  // Get current week's leaderboard
  static Stream<List<ScoreEntry>> getCurrentWeekScores({GameMode? gameMode}) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 7));
    
    Query query = _db
        .collection('leaderboard')
        .where('timestamp', isGreaterThan: weekStart)
        .orderBy('timestamp')
        .orderBy('score', descending: true)
        .limit(50);
    
    if (gameMode != null) {
      query = query.where('gameMode', isEqualTo: gameMode.name);
    }
    
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ScoreEntry.fromFirestore(doc)).toList());
  }
  
  // Get all-time top scores
  static Stream<List<ScoreEntry>> getAllTimeScores({GameMode? gameMode}) {
    Query query = _db
        .collection('leaderboard')
        .orderBy('score', descending: true)
        .limit(100);
    
    if (gameMode != null) {
      query = query.where('gameMode', isEqualTo: gameMode.name);
    }
    
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ScoreEntry.fromFirestore(doc)).toList());
  }
}

class ScoreEntry {
  final String playerName;
  final int score;
  final DateTime date;
  final GameMode? gameMode;
  final GameTheme? theme;

  ScoreEntry({
    required this.playerName,
    required this.score,
    required this.date,
    this.gameMode,
    this.theme,
  });
  
  factory ScoreEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScoreEntry(
      playerName: data['playerName'] ?? 'Anonymous',
      score: data['score'] ?? 0,
      date: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      gameMode: GameMode.values.cast<GameMode?>().firstWhere(
        (mode) => mode?.name == data['gameMode'],
        orElse: () => null,
      ),
      theme: GameTheme.values.cast<GameTheme?>().firstWhere(
        (theme) => theme?.name == data['theme'],
        orElse: () => null,
      ),
    );
  }
}