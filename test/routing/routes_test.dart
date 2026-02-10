import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/core/routing/routes.dart';

void main() {
  group('Routes', () {
    group('Path constants', () {
      test('onboarding should be /onboarding', () {
        expect(Routes.onboarding, '/onboarding');
      });

      test('home should be /', () {
        expect(Routes.home, '/');
      });

      test('temperatureSearch should be /temperature-search', () {
        expect(Routes.temperatureSearch, '/temperature-search');
      });

      test('settings should be /settings', () {
        expect(Routes.settings, '/settings');
      });

      test('locationSettings should be /settings/location', () {
        expect(Routes.locationSettings, '/settings/location');
      });

      test('notificationSettings should be /settings/notification', () {
        expect(Routes.notificationSettings, '/settings/notification');
      });
    });

    group('Route names', () {
      test('onboardingName should be onboarding', () {
        expect(Routes.onboardingName, 'onboarding');
      });

      test('homeName should be home', () {
        expect(Routes.homeName, 'home');
      });

      test('temperatureSearchName should be temperature-search', () {
        expect(Routes.temperatureSearchName, 'temperature-search');
      });

      test('settingsName should be settings', () {
        expect(Routes.settingsName, 'settings');
      });

      test('locationSettingsName should be location-settings', () {
        expect(Routes.locationSettingsName, 'location-settings');
      });

      test('notificationSettingsName should be notification-settings', () {
        expect(Routes.notificationSettingsName, 'notification-settings');
      });
    });

    group('Route consistency', () {
      test('all routes should start with /', () {
        expect(Routes.onboarding.startsWith('/'), isTrue);
        expect(Routes.home.startsWith('/'), isTrue);
        expect(Routes.temperatureSearch.startsWith('/'), isTrue);
        expect(Routes.settings.startsWith('/'), isTrue);
        expect(Routes.locationSettings.startsWith('/'), isTrue);
        expect(Routes.notificationSettings.startsWith('/'), isTrue);
      });

      test('settings sub-routes should be prefixed with /settings', () {
        expect(Routes.locationSettings.startsWith('/settings/'), isTrue);
        expect(Routes.notificationSettings.startsWith('/settings/'), isTrue);
      });

      test('route names should not contain slashes', () {
        expect(Routes.onboardingName.contains('/'), isFalse);
        expect(Routes.homeName.contains('/'), isFalse);
        expect(Routes.temperatureSearchName.contains('/'), isFalse);
        expect(Routes.settingsName.contains('/'), isFalse);
      });
    });
  });
}
