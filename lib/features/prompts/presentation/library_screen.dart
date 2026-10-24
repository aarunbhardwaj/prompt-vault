import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';
import 'package:prompt_vault/features/prompts/presentation/prompt_card.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  static const _debounceMs = 300;

  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: _debounceMs), () {
      ref.read(librarySearchQueryProvider.notifier).state = value;
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    ref.read(librarySearchQueryProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    final allAsync = ref.watch(promptListProvider);
    final visibleAsync = ref.watch(libraryVisiblePromptsProvider);
    final searchQuery = ref.watch(librarySearchQueryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('PromptVault')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search prompts',
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
              ],
              onChanged: (value) {
                setState(() {});
                _onSearchChanged(value);
              },
            ),
          ),
          Expanded(
            child: visibleAsync.when(
              data: (prompts) {
                final libraryEmpty = allAsync.maybeWhen(
                  data: (all) => all.isEmpty && searchQuery.isEmpty,
                  orElse: () => false,
                );

                if (libraryEmpty) {
                  return _LibraryEmptyState();
                }

                if (prompts.isEmpty && searchQuery.trim().isNotEmpty) {
                  return _NoSearchResultsState(query: searchQuery.trim());
                }

                if (prompts.isEmpty) {
                  return _LibraryEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: prompts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
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

class _LibraryEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class _NoSearchResultsState extends StatelessWidget {
  const _NoSearchResultsState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text('No results', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Nothing matched "$query".',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
