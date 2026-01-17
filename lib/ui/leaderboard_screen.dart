import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'widgets/banner_ad_widget.dart';
import '../services/firestore_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _showCurrent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                          const Expanded(
                            child: Text(
                              'Global Leaderboard',
                              style: AppTheme.titleMedium,
                            ),
                          ),
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
                      child: StreamBuilder<List<ScoreEntry>>(
                        stream: _showCurrent 
                          ? FirestoreService.getCurrentWeekScores()
                          : FirestoreService.getAllTimeScores(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          
                          final scores = snapshot.data ?? [];
                          return _buildLeaderboardContent(scores);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
  
  Widget _buildLeaderboardContent(List<ScoreEntry> scores) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration,
        child: Column(
          children: [
            // Header Label
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history_rounded, size: 16, color: AppTheme.primaryOrange),
                  const SizedBox(width: 8),
                  Text(
                    _showCurrent ? 'Current Week' : 'All Time',
                    style: AppTheme.titleSmall.copyWith(
                      color: AppTheme.primaryOrange,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Top 3 Podium
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _PodiumPlace(
                    rank: 2,
                    label: scores.length > 1 ? scores[1].score.toString() : '0',
                    height: 80,
                    color: const Color(0xFFC0C0C0),
                  ),
                  _PodiumPlace(
                    rank: 1,
                    label: scores.isNotEmpty ? scores[0].score.toString() : '0',
                    height: 100,
                    color: const Color(0xFFFFD700),
                  ),
                  _PodiumPlace(
                    rank: 3,
                    label: scores.length > 2 ? scores[2].score.toString() : '0',
                    height: 60,
                    color: const Color(0xFFCD7F32),
                  ),
                ],
              ),
            ),
            
            // Toggle Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.textDark.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildToggleButton('Current', _showCurrent, () => setState(() => _showCurrent = true)),
                    _buildToggleButton('All Time', !_showCurrent, () => setState(() => _showCurrent = false)),
                  ],
                ),
              ),
            ),

            const Divider(color: AppTheme.textDark),

            // Scores List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                return _LeaderboardTile(
                  rank: index + 1,
                  name: score.playerName,
                  score: score.score,
                  date: score.date,
                  isPersonalBest: index == 0,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive ? [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
            ] : null,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? AppTheme.primaryOrange : AppTheme.textDark.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  final int rank;
  final String label;
  final double height;
  final Color color;

  const _PodiumPlace({
    required this.rank,
    required this.label,
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
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
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
  final String name;
  final int score;
  final DateTime date;
  final bool isPersonalBest;

  const _LeaderboardTile({
    required this.rank,
    required this.name,
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
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
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