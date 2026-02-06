class Routes {
  Routes._(); // private 생성자 - 인스턴스 생성 방지

  // ========================================
  // 기본 라우트
  // ========================================

  /// 온보딩 화면
  static const String onboarding = '/onboarding';

  /// 홈 화면 (옷차림 추천)
  static const String home = '/';

  /// 사용자 목록
  static const String users = '/users';

  // ========================================
  // 동적 라우트 (파라미터 포함)
  // ========================================

  /// 사용자 상세 화면
  ///
  /// [userId] - 사용자 ID
  static String userDetail(int userId) => '/users/$userId';

  // ========================================
  // 추가 예정 라우트
  // ========================================

  /// 설정 화면
  static const String settings = '/settings';

  /// 위치 설정 화면
  static const String locationSettings = '/settings/location';

  /// 알림 설정 화면
  static const String notificationSettings = '/settings/notification';

  // ========================================
  // 라우트 이름 (Named Routes)
  // ========================================

  static const String onboardingName = 'onboarding';
  static const String homeName = 'home';
  static const String usersName = 'users';
  static const String userDetailName = 'user-detail';
  static const String settingsName = 'settings';
  static const String locationSettingsName = 'location-settings';
  static const String notificationSettingsName = 'notification-settings';
}
