import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// DI Setup
import 'core/di/di_setup.dart';

// Router Setup
import 'core/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 로드
  await dotenv.load(fileName: ".env");

  // ✅ DI 초기화 (GetIt)
  // useMockLocation: true -> 서울 위치 Mock 사용
  // useMockLocation: false -> 실제 GPS 사용
  diSetup(useMockLocation: false);

  // 온보딩 완료 여부 확인
  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  runApp(ProviderScope(child: MyApp(onboardingComplete: onboardingComplete)));
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;

  const MyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter(
      onboardingComplete: onboardingComplete,
    );

    return MaterialApp.router(
      title: '옷차림표',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
