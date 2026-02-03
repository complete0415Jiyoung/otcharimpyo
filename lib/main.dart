import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'onboarding/presentation/onboarding_screen.dart';
import 'user/presentation/user_screen_root.dart';
import 'weather/presentation/outfit_screen_root.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  runApp(ProviderScope(child: MyApp(onboardingComplete: onboardingComplete)));
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;

  const MyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: onboardingComplete ? '/outfit' : '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/outfit',
          builder: (context, state) => const OutfitScreenRoot(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => const UserScreenRoot(),
        ),
      ],
    );

    return MaterialApp.router(
      title: '옷차림표',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
