import 'package:flutter/material.dart';
import 'package:skin_firts/core/theme/app_theme.dart';
import 'package:skin_firts/presentation/pages/splash_screen/splash_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen()
    );
  }
}