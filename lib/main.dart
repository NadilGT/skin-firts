import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skin_firts/core/theme/app_theme.dart';
import 'package:skin_firts/firebase_options.dart';
import 'package:skin_firts/presentation/pages/splash_screen/splash_screen.dart';
import 'package:skin_firts/service_locator.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initilizeDependencies();
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