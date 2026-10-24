import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompt_vault/app/router.dart';
import 'package:prompt_vault/app/theme.dart';

class PromptVaultApp extends ConsumerWidget {
  const PromptVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'PromptVault',
      theme: promptVaultLightTheme,
      darkTheme: promptVaultDarkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
