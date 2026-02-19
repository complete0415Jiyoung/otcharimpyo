import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'outfit_screen.dart';
import 'outfit_notifier.dart';

class OutfitScreenRoot extends ConsumerWidget {
  const OutfitScreenRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outfitNotifierProvider);
    final notifier = ref.watch(outfitNotifierProvider.notifier);

    return OutfitScreen(
      state: state,
      onAction: (action) async {
        await notifier.onAction(action);
      },
      onClearLocationError: notifier.clearLocationPermissionError,
    );
  }
}
