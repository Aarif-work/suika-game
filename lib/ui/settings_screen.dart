import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'widgets/banner_ad_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEffects = true;
  bool backgroundMusic = true;
  bool vibration = true;
  bool showParticles = true;

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            color: Color(0xFFe76f51),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF6d6875),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add delete account logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFe76f51),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLinkedInDialog() {
    const linkedInUrl = 'https://www.linkedin.com/in/mohammad-aarif-321369306/';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'LinkedIn Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(linkedInUrl),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(const ClipboardData(text: linkedInUrl));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('LinkedIn URL copied!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2a9d8f),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Copy URL'),
            ),
          ],
        ),
      ),
    );
  }

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
                          const Text(
                            'Settings',
                            style: AppTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    // Settings Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          children: [
                            _SettingsSection(
                              title: 'Audio',
                              icon: Icons.volume_up,
                              children: [
                                _SettingsTile(
                                  title: 'Sound Effects',
                                  subtitle: 'Play sound effects during gameplay',
                                  trailing: Switch(
                                    value: soundEffects,
                                    onChanged: (value) {
                                      setState(() {
                                        soundEffects = value;
                                      });
                                    },
                                    activeColor: AppTheme.secondaryTeal,
                                  ),
                                ),
                                _SettingsTile(
                                  title: 'Background Music',
                                  subtitle: 'Play background music',
                                  trailing: Switch(
                                    value: backgroundMusic,
                                    onChanged: (value) {
                                      setState(() {
                                        backgroundMusic = value;
                                      });
                                    },
                                    activeColor: AppTheme.secondaryTeal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _SettingsSection(
                              title: 'Gameplay',
                              icon: Icons.gamepad,
                              children: [
                                _SettingsTile(
                                  title: 'Vibration',
                                  subtitle: 'Vibrate on fruit merges',
                                  trailing: Switch(
                                    value: vibration,
                                    onChanged: (value) {
                                      setState(() {
                                        vibration = value;
                                      });
                                    },
                                    activeColor: AppTheme.secondaryTeal,
                                  ),
                                ),
                                _SettingsTile(
                                  title: 'Particle Effects',
                                  subtitle: 'Show visual effects',
                                  trailing: Switch(
                                    value: showParticles,
                                    onChanged: (value) {
                                      setState(() {
                                        showParticles = value;
                                      });
                                    },
                                    activeColor: AppTheme.secondaryTeal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _SettingsSection(
                              title: 'Account',
                              icon: Icons.person,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _showDeleteAccountDialog,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFe76f51),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.delete_forever_rounded, size: 24),
                                          SizedBox(width: 8),
                                          Text(
                                            'DELETE ACCOUNT',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _SettingsSection(
                              title: 'About',
                              icon: Icons.info,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Version 1.0.0',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'A fun physics-based merge puzzle game.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.textDark.withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: AppTheme.primaryOrange,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Hope3 Service',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.textDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Developed by Mohamed Aarif A',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      OutlinedButton.icon(
                                        onPressed: _showLinkedInDialog,
                                        icon: const Icon(Icons.link, size: 18),
                                        label: const Text('LinkedIn'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFF0077B5),
                                          side: const BorderSide(
                                            color: Color(0xFF0077B5),
                                            width: 1.5,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Made with Flutter & Flame',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.textDark.withOpacity(0.6),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
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
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.primaryOrange, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textDark.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}