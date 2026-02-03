import 'user_data_source.dart';

class MockUserDataSource implements UserDataSource {
  // Mock 데이터
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 1,
      'name': '김철수',
      'username': 'chulsoo',
      'email': 'chulsoo@example.com',
      'phone': '010-1234-5678',
    },
    {
      'id': 2,
      'name': '이영희',
      'username': 'younghee',
      'email': 'younghee@example.com',
      'phone': '010-2345-6789',
    },
    {
      'id': 3,
      'name': '박민수',
      'username': 'minsu',
      'email': 'minsu@example.com',
      'phone': '010-3456-7890',
    },
    {
      'id': 4,
      'name': '정수진',
      'username': 'sujin',
      'email': 'sujin@example.com',
      'phone': '010-4567-8901',
    },
    {
      'id': 5,
      'name': '최동욱',
      'username': 'dongwook',
      'email': 'dongwook@example.com',
      'phone': '010-5678-9012',
    },
  ];

  @override
  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    // 네트워크 딜레이 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    final user = _mockUsers.firstWhere(
      (u) => u['id'].toString() == userId,
      orElse: () => throw Exception('User not found'),
    );

    return user;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchUserList() async {
    // 네트워크 딜레이 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 800));

    return _mockUsers;
  }

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockUsers.indexWhere((u) => u['id'].toString() == userId);
    if (index != -1) {
      _mockUsers[index] = data;
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    _mockUsers.removeWhere((u) => u['id'].toString() == userId);
  }
}
