abstract interface class UserDataSource {
  Future<Map<String, dynamic>> fetchUserData(String userId);
  Future<List<Map<String, dynamic>>> fetchUserList();
  Future<void> updateUserData(String userId, Map<String, dynamic> data);
  Future<void> deleteUser(String userId);
}
