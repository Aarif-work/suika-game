import 'package:flutter/material.dart';
import 'main_menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // First stage - Big logo
  late Animation<double> _bigLogoFadeInAnimation;
  late Animation<double> _bigLogoScaleAnimation;
  late Animation<double> _bigLogoFadeOutAnimation;
  
  // Second stage - Full logo
  late Animation<double> _fullLogoFadeInAnimation;
  late Animation<double> _fullLogoScaleAnimation;
  
  // Final fade out
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller (5.5 seconds total)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5500),
      vsync: this,
    );

    // STAGE 1: Big Logo (0.0 - 2.5s)
    // Big logo fade in (0.0 - 0.8s)
    _bigLogoFadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.15, curve: Curves.easeInOut),
      ),
    );

    // Big logo scale (0.0 - 0.8s)
    _bigLogoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.15, curve: Curves.easeOutCubic),
      ),
    );

    // Big logo fade out (1.8 - 2.5s)
    _bigLogoFadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.45, curve: Curves.easeInOut),
      ),
    );

    // STAGE 2: Full Logo (2.3 - 5.0s)
    // Full logo fade in (2.3 - 3.0s)
    _fullLogoFadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.55, curve: Curves.easeInOut),
      ),
    );

    // Full logo scale (2.3 - 3.0s)
    _fullLogoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    // Final fade out (4.5 - 5.5s)
    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.82, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to MainMenu after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainMenu(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeOutAnimation.value,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Stage 1: Big Logo
                  Opacity(
                    opacity: _bigLogoFadeInAnimation.value * _bigLogoFadeOutAnimation.value,
                    child: Transform.scale(
                      scale: _bigLogoScaleAnimation.value,
                      child: Image.asset(
                        'assets/logo.png',
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  
                  // Stage 2: Full Logo
                  Opacity(
                    opacity: _fullLogoFadeInAnimation.value,
                    child: Transform.scale(
                      scale: _fullLogoScaleAnimation.value,
                      child: Image.asset(
                        'assets/fullllogo.png',
                        width: 280,
                        height: 280,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
