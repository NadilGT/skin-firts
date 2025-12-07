import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/common/bloc/theme_cubit.dart';
import 'package:skin_firts/core/theme/app_theme.dart';
import 'package:skin_firts/firebase_options.dart';
import 'package:skin_firts/presentation/pages/splash_screen/splash_screen.dart';
import 'package:skin_firts/service_locator.dart';

import 'core/storage/shared_pref_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initilizeDependencies();

  final sharedPrefManager = SharedPrefManager();

  try {
    // 👇 wait until Firebase restores the logged-in user (if any)
    final user = await FirebaseAuth.instance.authStateChanges().first;

    if (user != null) {
      String? newToken = await user.getIdToken(true); // force refresh
      await sharedPrefManager.saveToken(newToken!);
      print("✅ Token refreshed before app start");
    } else {
      print("⚠️ No user logged in, skipping token refresh");
    }
  } catch (e) {
    print("❌ Token refresh failed: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}