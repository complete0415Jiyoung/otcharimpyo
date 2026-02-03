import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'user_screen.dart';
import 'user_action.dart';
import 'user_notifier.dart';

class UserScreenRoot extends ConsumerWidget {
  const UserScreenRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userNotifierProvider);
    final notifier = ref.watch(userNotifierProvider.notifier);

    return UserScreen(
      state: state,
      onAction: (action) async {
        switch (action) {
          case OnTapUser(:final userId):
            await context.push('/user/$userId');
          default:
            await notifier.onAction(action);
        }
      },
    );
  }
}
