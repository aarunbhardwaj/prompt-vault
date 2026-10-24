import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';
import 'package:prompt_vault/features/prompts/presentation/prompt_card.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promptsAsync = ref.watch(promptListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('PromptVault')),
      body: promptsAsync.when(
        data: (prompts) {
          if (prompts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No prompts yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add your first prompt.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: prompts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final prompt = prompts[index];
              return PromptCard(
                prompt: prompt,
                onTap: () => context.go('/prompt/${prompt.id}/run'),
                onEdit: () => context.go('/prompt/${prompt.id}/edit'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/prompt/new'),
        tooltip: 'Add prompt',
        child: const Icon(Icons.add),
      ),
    );
  }
}
