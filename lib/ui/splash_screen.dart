import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'widgets/atmosphere_background.dart';
import 'widgets/user_setup_dialog.dart';
import '../game/constants.dart';
import '../services/auth_service.dart';
import 'main_menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Animation for elements
  late Animation<double> _welcomeFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _taglineFadeAnimation;
  late Animation<double> _footerFadeAnimation;
  late Animation<double> _screenFadeOutAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 7000),
      vsync: this,
    );

    // Welcome text (0.0 - 0.5s equivalent in 7s)
    _welcomeFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.15, curve: Curves.easeIn),
      ),
    );

    // Logo (0.5 - 2s)
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.3, curve: Curves.easeIn),
      ),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.35, curve: Curves.easeOutBack),
      ),
    );

    // Title (2s - 4s)
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeIn),
      ),
    );

    // Tagline (3s - 5s)
    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeIn),
      ),
    );

    // Footer (4s - 6s)
    _footerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.75, curve: Curves.easeIn),
      ),
    );

    // Screen Fade Out (6s - 7s)
    _screenFadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.85, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
    _playSplashAudio();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkUserSetup();
      }
    });
  }

  void _checkUserSetup() async {
    final isFirstTime = await AuthService.isFirstTime();
    
    if (isFirstTime) {
      _showUserSetupDialog();
    } else {
      await AuthService.signInAnonymously();
      _navigateToMainMenu();
    }
  }
  
  void _showUserSetupDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UserSetupDialog(
        onComplete: _navigateToMainMenu,
      ),
    );
  }
  
  void _navigateToMainMenu() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainMenu(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _playSplashAudio() async {
    try {
      if (!mounted) return;
      await FlameAudio.bgm.play('splash-screen2.mp3', volume: 0.6);
    } catch (e) {
      debugPrint('Error playing splash audio: $e');
    }
  }

  void _stopSplashAudio() {
    try {
      if (FlameAudio.bgm.isPlaying) {
        FlameAudio.bgm.stop();
      }
    } catch (e) {
      debugPrint('Error stopping splash audio: $e');
    }
  }

  @override
  void dispose() {
    _stopSplashAudio();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Background based on theme
    const splashTheme = GameTheme.fruit;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Darker base for theme
      body: Stack(
        children: [
          // 1. Dynamic Game Theme Background
          const AtmosphereBackground(theme: splashTheme),
          
          // 2. Main Content
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _screenFadeOutAnimation.value,
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      // "Welcome to" header
                      FadeTransition(
                        opacity: _welcomeFadeAnimation,
                        child: const Text(
                          'Welcome to',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Circular Logo Container
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ScaleTransition(
                            scale: _logoScaleAnimation,
                            child: FadeTransition(
                              opacity: _logoFadeAnimation,
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1), // Glassmorphism style
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                                ),
                              ),
                            ),
                          ),
                          ScaleTransition(
                            scale: _logoScaleAnimation,
                            child: FadeTransition(
                              opacity: _logoFadeAnimation,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/game logo.png',
                                  width: 170,
                                  height: 170,
                                  fit: BoxFit.cover, // Cover to ensure circle fit
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      // Title
                      FadeTransition(
                        opacity: _titleFadeAnimation,
                        child: const Text(
                          'SUIKA GAME',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Tagline
                      FadeTransition(
                        opacity: _taglineFadeAnimation,
                        child: const Text(
                          'Merge & Grow',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                      // Footer
                      FadeTransition(
                        opacity: _footerFadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Developed by ',
                                style: TextStyle(
                                  color: Colors.white30,
                                  fontSize: 14,
                                ),
                              ),
                              const Icon(
                                Icons.bolt,
                                color: Colors.blueAccent,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Hope3 Services',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
