import 'package:flutter/material.dart';
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
  double musicVolume = 0.7;
  double sfxVolume = 0.8;

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
                          _VolumeSlider(
                            title: 'Music Volume',
                            value: musicVolume,
                            enabled: backgroundMusic,
                            onChanged: (value) {
                              setState(() {
                                musicVolume = value;
                              });
                            },
                          ),
                          _VolumeSlider(
                            title: 'SFX Volume',
                            value: sfxVolume,
                            enabled: soundEffects,
                            onChanged: (value) {
                              setState(() {
                                sfxVolume = value;
                              });
                            },
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
                          _SettingsTile(
                            title: 'Version',
                            subtitle: '1.0.0',
                            trailing: const SizedBox(),
                          ),
                          _SettingsTile(
                            title: 'Developer',
                            subtitle: 'Made with Flutter & Flame',
                            trailing: const SizedBox(),
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

class _VolumeSlider extends StatelessWidget {
  final String title;
  final double value;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const _VolumeSlider({
    required this.title,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: enabled ? AppTheme.textDark : AppTheme.textDark.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.secondaryTeal,
              inactiveTrackColor: AppTheme.secondaryTeal.withOpacity(0.3),
              thumbColor: AppTheme.secondaryTeal,
              overlayColor: AppTheme.secondaryTeal.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              onChanged: enabled ? onChanged : null,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: '${(value * 100).round()}%',
            ),
          ),
        ],
      ),
    );
  }
}