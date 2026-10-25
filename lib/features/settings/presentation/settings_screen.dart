import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_vault/core/constants/legal_urls.dart';
import 'package:prompt_vault/features/starter/data/starter_providers.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Restore starter prompts'),
            subtitle: const Text(
              'Adds bundled prompts missing from your library (matched by id). '
              'Your custom prompts are not removed.',
            ),
            onTap: () async {
              final imported = await restoreStarterPromptsFromAsset(ref);
              if (!context.mounted) {
                return;
              }
              final message = imported == 0
                  ? 'All starter prompts are already in your library'
                  : 'Restored $imported starter prompt${imported == 1 ? '' : 's'}';
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
          ),
          ListTile(
            title: const Text('Privacy policy'),
            subtitle: const Text('How PromptVault handles your data'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              final uri = Uri.parse(kPrivacyPolicyUrl);
              final opened = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
              if (!context.mounted) {
                return;
              }
              if (!opened) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not open privacy policy link'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
