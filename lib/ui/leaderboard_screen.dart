import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'widgets/banner_ad_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _showCurrent = true;

  @override
  Widget build(BuildContext context) {
    final scores = _getFilteredScores();
    final pastChampions = _getPastChampions();
    
    // Calculate top winners for podium when showing past winners
    final Map<String, int> winCounts = {};
    for (var champion in pastChampions) {
      winCounts[champion.playerName] = (winCounts[champion.playerName] ?? 0) + 1;
    }
    final sortedWinners = winCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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
                    const Text(
                      'Global Leaderboard',
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
                        // Weekly Refresh Label
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
                                _showCurrent ? 'Resets in: 4d 12h' : 'Historical Stats',
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
                                label: _showCurrent 
                                  ? (scores.length > 1 ? scores[1].score.toString() : '0')
                                  : (sortedWinners.length > 1 ? '${sortedWinners[1].key}\n${sortedWinners[1].value} Wins' : 'N/A'),
                                height: 80,
                                color: const Color(0xFFC0C0C0), // Silver
                              ),
                              _PodiumPlace(
                                rank: 1,
                                label: _showCurrent 
                                  ? (scores.isNotEmpty ? scores[0].score.toString() : '0')
                                  : (sortedWinners.isNotEmpty ? '${sortedWinners[0].key}\n${sortedWinners[0].value} Wins' : 'N/A'),
                                height: 100,
                                color: const Color(0xFFFFD700), // Gold
                              ),
                              _PodiumPlace(
                                rank: 3,
                                label: _showCurrent 
                                  ? (scores.length > 2 ? scores[2].score.toString() : '0')
                                  : (sortedWinners.length > 2 ? '${sortedWinners[2].key}\n${sortedWinners[2].value} Wins' : 'N/A'),
                                height: 60,
                                color: const Color(0xFFCD7F32), // Bronze
                              ),
                            ],
                          ),
                        ),
                        
                        // Toggle Buttons Section
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
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _showCurrent = true),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        color: _showCurrent ? Colors.white : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: _showCurrent ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ] : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Current',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: _showCurrent ? AppTheme.primaryOrange : AppTheme.textDark.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _showCurrent = false),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        color: !_showCurrent ? Colors.white : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: !_showCurrent ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ] : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Past Winners',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: !_showCurrent ? AppTheme.primaryOrange : AppTheme.textDark.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Divider(color: AppTheme.textDark),

                        // Conditional Content
                        if (_showCurrent)
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
                          )
                        else
                          _PastChampionsSection(champions: pastChampions),
                          
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
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

  List<ScoreEntry> _getFilteredScores() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    
    return [
      ScoreEntry(playerName: 'Aarif', score: 5450, date: now.subtract(const Duration(hours: 4))),
      ScoreEntry(playerName: 'Siva', score: 4890, date: now.subtract(const Duration(days: 1))),
      ScoreEntry(playerName: 'Sham', score: 4650, date: now.subtract(const Duration(days: 2))),
      ScoreEntry(playerName: 'Praveen', score: 3420, date: now.subtract(const Duration(days: 3))),
      ScoreEntry(playerName: 'Nagaraj', score: 3200, date: now.subtract(const Duration(days: 5))),
      ScoreEntry(playerName: 'Siranjeevan', score: 2980, date: now.subtract(const Duration(days: 6))),
    ].where((entry) => entry.date.isAfter(sevenDaysAgo)).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  List<ScoreEntry> _getPastChampions() {
    final now = DateTime.now();
    return [
      ScoreEntry(playerName: 'Aarif', score: 6200, date: now.subtract(const Duration(days: 7))),
      ScoreEntry(playerName: 'Siva', score: 5800, date: now.subtract(const Duration(days: 14))),
      ScoreEntry(playerName: 'Aarif', score: 5900, date: now.subtract(const Duration(days: 21))),
      ScoreEntry(playerName: 'Sham', score: 5650, date: now.subtract(const Duration(days: 28))),
      ScoreEntry(playerName: 'Sanjeevan', score: 5400, date: now.subtract(const Duration(days: 35))),
      ScoreEntry(playerName: 'Aarif', score: 6000, date: now.subtract(const Duration(days: 42))),
      ScoreEntry(playerName: 'Siva', score: 5700, date: now.subtract(const Duration(days: 49))),
    ];
  }
}

class _PastChampionsSection extends StatelessWidget {
  final List<ScoreEntry> champions;

  const _PastChampionsSection({required this.champions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Past Weekly Champions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: champions.length,
          itemBuilder: (context, index) {
            final champion = champions[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.secondaryTeal.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryTeal,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Week ${index + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      champion.playerName,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                  ),
                  Text(
                    '${champion.score}',
                    style: const TextStyle(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
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

class ScoreEntry {
  final String playerName;
  final int score;
  final DateTime date;

  ScoreEntry({
    required this.playerName,
    required this.score,
    required this.date,
  });
}