import 'package:flutter/material.dart';
import 'app_theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scores = _getDummyScores();
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppTheme.primaryOrange,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Leaderboard',
                      style: AppTheme.titleMedium,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.emoji_events,
                      color: AppTheme.accentYellow,
                      size: 32,
                    ),
                  ],
                ),
              ),
              // Leaderboard Content
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      children: [
                        // Top 3 Podium
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _PodiumPlace(
                                rank: 2,
                                score: scores.length > 1 ? scores[1].score : 0,
                                height: 80,
                                color: const Color(0xFFC0C0C0), // Silver
                              ),
                              _PodiumPlace(
                                rank: 1,
                                score: scores.isNotEmpty ? scores[0].score : 0,
                                height: 100,
                                color: const Color(0xFFFFD700), // Gold
                              ),
                              _PodiumPlace(
                                rank: 3,
                                score: scores.length > 2 ? scores[2].score : 0,
                                height: 60,
                                color: const Color(0xFFCD7F32), // Bronze
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: AppTheme.textDark),
                        // Full Leaderboard List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: scores.length,
                          itemBuilder: (context, index) {
                            final score = scores[index];
                            return _LeaderboardTile(
                              rank: index + 1,
                              score: score.score,
                              date: score.date,
                              isPersonalBest: index == 0,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ScoreEntry> _getDummyScores() {
    return [
      ScoreEntry(score: 2450, date: DateTime.now().subtract(const Duration(days: 1))),
      ScoreEntry(score: 1890, date: DateTime.now().subtract(const Duration(days: 3))),
      ScoreEntry(score: 1650, date: DateTime.now().subtract(const Duration(days: 5))),
      ScoreEntry(score: 1420, date: DateTime.now().subtract(const Duration(days: 7))),
      ScoreEntry(score: 1200, date: DateTime.now().subtract(const Duration(days: 10))),
      ScoreEntry(score: 980, date: DateTime.now().subtract(const Duration(days: 12))),
      ScoreEntry(score: 750, date: DateTime.now().subtract(const Duration(days: 15))),
      ScoreEntry(score: 620, date: DateTime.now().subtract(const Duration(days: 18))),
    ];
  }
}

class _PodiumPlace extends StatelessWidget {
  final int rank;
  final int score;
  final double height;
  final Color color;

  const _PodiumPlace({
    required this.rank,
    required this.score,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$score',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: color, width: 2),
          ),
        ),
      ],
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final int rank;
  final int score;
  final DateTime date;
  final bool isPersonalBest;

  const _LeaderboardTile({
    required this.rank,
    required this.score,
    required this.date,
    required this.isPersonalBest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPersonalBest 
            ? AppTheme.accentYellow.withOpacity(0.1)
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: isPersonalBest 
            ? Border.all(color: AppTheme.accentYellow, width: 2)
            : null,
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Score and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$score',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                    if (isPersonalBest) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star,
                        color: AppTheme.accentYellow,
                        size: 20,
                      ),
                    ],
                  ],
                ),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textDark.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // Trophy for top 3
          if (rank <= 3)
            Icon(
              Icons.emoji_events,
              color: _getRankColor(rank),
              size: 24,
            ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppTheme.secondaryTeal;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '$difference days ago';
    }
  }
}

class ScoreEntry {
  final int score;
  final DateTime date;

  ScoreEntry({required this.score, required this.date});
}