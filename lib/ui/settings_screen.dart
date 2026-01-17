import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
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
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFED4956).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: Color(0xFFED4956),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Delete Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Are you sure you want to delete your account? This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textDark.withOpacity(0.6),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF6d6875),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showVerifyingAndDeleteDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED4956),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  void _showVerifyingAndDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _VerifyingDeleteDialog(
        onFinalConfirm: () {
          // Add your actual full account deletion logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account permanently deleted!'),
              backgroundColor: Color(0xFFED4956),
            ),
          );
        },
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
                              title: 'About',
                              icon: Icons.info,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      // 1. Game Logo & Info Card
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.1)),
                                        ),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Image.asset(
                                                'assets/game logo.png',
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            const Text(
                                              'Suika Game',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w900,
                                                color: AppTheme.textDark,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            Text(
                                              'Version 1.0.0',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: AppTheme.textDark.withOpacity(0.4),
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      // 2. Company & Developer Branding
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/h3 logo.png',
                                            width: 32,
                                            height: 32,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            height: 30,
                                            width: 1,
                                            color: AppTheme.textDark.withOpacity(0.1),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Hope3 Services',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.textDark,
                                                ),
                                              ),
                                              Text(
                                                'Developed by Mohamed Aarif A',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppTheme.primaryOrange,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),

                                      // 3. Footer
                                      Text(
                                        'Made with Flutter & Flame',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textDark.withOpacity(0.3),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
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
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                                    ),
                                    child: Row(
                                      children: [
                                        // Avatar Placeholder
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryOrange.withOpacity(0.15),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.3), width: 2),
                                          ),
                                          child: const Icon(Icons.person, color: AppTheme.primaryOrange, size: 28),
                                        ),
                                        const SizedBox(width: 16),
                                        // User Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Mohamed Aarif A',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppTheme.textDark,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Age: 19',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppTheme.textDark.withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Action
                                        TextButton(
                                          onPressed: _showDeleteAccountDialog,
                                          style: TextButton.styleFrom(
                                            foregroundColor: const Color(0xFFED4956),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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

class _AboutInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _AboutInfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textDark.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyingDeleteDialog extends StatefulWidget {
  final VoidCallback onFinalConfirm;

  const _VerifyingDeleteDialog({required this.onFinalConfirm});

  @override
  State<_VerifyingDeleteDialog> createState() => _VerifyingDeleteDialogState();
}

class _VerifyingDeleteDialogState extends State<_VerifyingDeleteDialog> {
  int _secondsRemaining = 3;
  bool _isVerifying = true;

  @override
  void initState() {
    super.initState();
    _startVerification();
  }

  void _startVerification() async {
    for (int i = 3; i > 0; i--) {
      if (!mounted) return;
      setState(() => _secondsRemaining = i);
      await Future.delayed(const Duration(seconds: 1));
    }
    if (!mounted) return;
    setState(() => _isVerifying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFED4956).withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isVerifying) ...[
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: Color(0xFFED4956),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Verifying Identity...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step $_secondsRemaining of 3',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textDark.withOpacity(0.5),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFED4956).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFED4956),
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'FINAL WARNING',
                    style: TextStyle(
                      color: Color(0xFFED4956),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'This is the last warning. Your account and all progress will be erased forever. You cannot undo this.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'ABORT',
                            style: TextStyle(
                              color: Color(0xFF6d6875),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onFinalConfirm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED4956),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 5,
                            shadowColor: const Color(0xFFED4956).withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'DELETE FOREVER',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
