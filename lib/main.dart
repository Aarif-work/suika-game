import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/main_menu.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
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
      home: const MainMenu(),
    ),
  );
}
