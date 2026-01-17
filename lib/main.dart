import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/splash_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Mobile Ads SDK
  MobileAds.instance.initialize();
  
  // Set system UI styling for Android
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0d0d0d), // Match dark background
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Lock orientation to portrait for consistent game experience
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suika Game',
      theme: ThemeData(
        brightness: Brightness.dark, // Set overall brightness to dark
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF0d0d0d),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    ),
  );
}
