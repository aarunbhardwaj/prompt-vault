import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Library home placeholder (E2 replaces with real list).
class LibraryPlaceholderScreen extends StatelessWidget {
  const LibraryPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PromptVault Library')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Your prompts will appear here.'),
          const SizedBox(height: 24),
          const Text('Dev navigation (E0-T4):'),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => context.go('/prompt/new'),
            child: const Text('New prompt'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go('/prompt/sample/edit'),
            child: const Text('Edit sample prompt'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go('/prompt/sample/run'),
            child: const Text('Run sample prompt'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/prompt/new'),
        tooltip: 'Add prompt',
        child: const Icon(Icons.add),
      ),
    );
  }
}
