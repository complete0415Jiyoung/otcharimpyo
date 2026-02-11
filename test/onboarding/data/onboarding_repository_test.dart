import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otcharimpyo/onboarding/data/onboarding_repository.dart';

void main() {
  group('OnboardingRepository', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    group('build', () {
      test('should return false when no value is stored', () async {
        SharedPreferences.setMockInitialValues({});

        final container = ProviderContainer();
        addTearDown(container.dispose);

        final result = await container.read(onboardingRepositoryProvider.future);

        expect(result, isFalse);
      });

      test('should return true when onboarding is complete', () async {
        SharedPreferences.setMockInitialValues({'onboarding_complete': true});

        final container = ProviderContainer();
        addTearDown(container.dispose);

        final result = await container.read(onboardingRepositoryProvider.future);

        expect(result, isTrue);
      });

      test('should return false when onboarding is not complete', () async {
        SharedPreferences.setMockInitialValues({'onboarding_complete': false});

        final container = ProviderContainer();
        addTearDown(container.dispose);

        final result = await container.read(onboardingRepositoryProvider.future);

        expect(result, isFalse);
      });
    });

    group('completeOnboarding', () {
      test('should set onboarding complete to true', () async {
        SharedPreferences.setMockInitialValues({});

        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Initially false
        final initialResult = await container.read(onboardingRepositoryProvider.future);
        expect(initialResult, isFalse);

        // Complete onboarding
        await container.read(onboardingRepositoryProvider.notifier).completeOnboarding();

        // Now should be true
        final finalResult = container.read(onboardingRepositoryProvider).value;
        expect(finalResult, isTrue);
      });

      test('should persist value to SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({});

        final container = ProviderContainer();
        addTearDown(container.dispose);

        await container.read(onboardingRepositoryProvider.future);
        await container.read(onboardingRepositoryProvider.notifier).completeOnboarding();

        // Verify SharedPreferences was updated
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('onboarding_complete'), isTrue);
      });
    });

    group('State Management', () {
      test('should update state after completing onboarding', () async {
        SharedPreferences.setMockInitialValues({});

        final container = ProviderContainer();
        addTearDown(container.dispose);

        await container.read(onboardingRepositoryProvider.future);

        expect(container.read(onboardingRepositoryProvider).value, isFalse);

        await container.read(onboardingRepositoryProvider.notifier).completeOnboarding();

        expect(container.read(onboardingRepositoryProvider).value, isTrue);
      });
    });
  });
}
