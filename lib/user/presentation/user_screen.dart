import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'user_state.dart';
import 'user_action.dart';
import '../domain/model/user.dart';
import '../../core/error/failure.dart';

class UserScreen extends StatelessWidget {
  final UserState state;
  final void Function(UserAction action) onAction;

  const UserScreen({super.key, required this.state, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('옷차림표'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => onAction(const UserAction.onRefresh()),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildLocationBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildLocationBar() {
    final weather = state.weather;

    if (weather == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('날씨 정보를 가져오는 중...'),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.thermostat_rounded, size: 20),
          const SizedBox(width: 8),
          Text(
            '${weather.temp.toStringAsFixed(1)}°C',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            weather.description,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final result = state.userListResult;

    // AsyncValue 상태 체크
    if (result.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (result.hasError) {
      return _buildError(result.error!);
    }

    if (result.hasValue) {
      return _buildUserList(result.value!);
    }

    // 기본 케이스 (여기까지 오면 안되지만 안전장치)
    return const Center(child: Text('알 수 없는 상태입니다'));
  }

  Widget _buildError(Object error) {
    String errorMessage = '알 수 없는 오류가 발생했습니다';

    if (error is Failure) {
      errorMessage = error.message;
    } else {
      errorMessage = error.toString();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            '에러 발생',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(errorMessage, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onAction(const UserAction.onRefresh()),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List<User> users) {
    if (users.isEmpty) {
      return const Center(child: Text('사용자가 없습니다'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        onAction(const UserAction.onRefresh());
      },
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserItem(user);
        },
      ),
    );
  }

  Widget _buildUserItem(User user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('@${user.username}'),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => onAction(UserAction.onTapUser(user.id)),
      ),
    );
  }
}
