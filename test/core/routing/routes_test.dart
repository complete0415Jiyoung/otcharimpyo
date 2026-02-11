import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/core/routing/routes.dart';

void main() {
  group('Routes', () {
    group('Basic Routes', () {
      test('should have correct onboarding path', () {
        expect(Routes.onboarding, '/onboarding');
      });

      test('should have correct home path', () {
        expect(Routes.home, '/');
      });

      test('should have correct temperatureSearch path', () {
        expect(Routes.temperatureSearch, '/temperature-search');
      });
    });

    group('Settings Routes', () {
      test('should have correct settings path', () {
        expect(Routes.settings, '/settings');
      });

      test('should have correct locationSettings path', () {
        expect(Routes.locationSettings, '/settings/location');
      });

      test('should have correct notificationSettings path', () {
        expect(Routes.notificationSettings, '/settings/notification');
      });
    });

    group('Route Names', () {
      test('should have correct onboardingName', () {
        expect(Routes.onboardingName, 'onboarding');
      });

      test('should have correct homeName', () {
        expect(Routes.homeName, 'home');
      });

      test('should have correct temperatureSearchName', () {
        expect(Routes.temperatureSearchName, 'temperature-search');
      });

      test('should have correct settingsName', () {
        expect(Routes.settingsName, 'settings');
      });

      test('should have correct locationSettingsName', () {
        expect(Routes.locationSettingsName, 'location-settings');
      });

      test('should have correct notificationSettingsName', () {
        expect(Routes.notificationSettingsName, 'notification-settings');
      });
    });

    group('Route Path Format', () {
      test('all paths should start with /', () {
        expect(Routes.onboarding.startsWith('/'), isTrue);
        expect(Routes.home.startsWith('/'), isTrue);
        expect(Routes.temperatureSearch.startsWith('/'), isTrue);
        expect(Routes.settings.startsWith('/'), isTrue);
        expect(Routes.locationSettings.startsWith('/'), isTrue);
        expect(Routes.notificationSettings.startsWith('/'), isTrue);
      });

      test('nested settings paths should contain parent path', () {
        expect(Routes.locationSettings.contains('/settings/'), isTrue);
        expect(Routes.notificationSettings.contains('/settings/'), isTrue);
      });
    });
  });
}
