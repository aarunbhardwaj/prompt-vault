import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';

class PromptEditorScreen extends ConsumerStatefulWidget {
  const PromptEditorScreen({super.key, this.promptId});

  final String? promptId;

  bool get isEdit => promptId != null;

  @override
  ConsumerState<PromptEditorScreen> createState() => _PromptEditorScreenState();
}

class _PromptEditorScreenState extends ConsumerState<PromptEditorScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  String _initialTitle = '';
  String _initialBody = '';
  bool _loaded = false;

  String? _titleError;
  String? _bodyError;

  bool get _isDirty =>
      _titleController.text != _initialTitle ||
      _bodyController.text != _initialBody;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _seedFields({required String title, required String body}) {
    _titleController.text = title;
    _bodyController.text = body;
    _initialTitle = title;
    _initialBody = body;
    _loaded = true;
  }

  Future<bool> _confirmDiscard() async {
    if (!_isDirty) {
      return true;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved edits.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  Future<void> _leaveEditor() async {
    if (await _confirmDiscard() && mounted) {
      context.go('/');
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    setState(() {
      _titleError = title.isEmpty ? 'Title is required' : null;
      _bodyError = body.isEmpty ? 'Body is required' : null;
    });

    if (_titleError != null || _bodyError != null) {
      return;
    }

    final notifier = ref.read(promptListProvider.notifier);

    if (widget.isEdit) {
      final id = widget.promptId!;
      final existing = await ref.read(promptByIdProvider(id).future);
      if (existing == null) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Prompt not found')));
        context.go('/');
        return;
      }
      final now = DateTime.now().toUtc();
      await notifier.updatePrompt(
        existing.copyWith(title: title, body: body, updatedAt: now),
      );
    } else {
      final now = DateTime.now().toUtc();
      await notifier.createPrompt(
        Prompt(
          id: 'p-${now.microsecondsSinceEpoch}',
          title: title,
          body: body,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit && !_loaded) {
      final asyncPrompt = ref.watch(promptByIdProvider(widget.promptId!));
      return asyncPrompt.when(
        data: (prompt) {
          if (prompt == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Edit prompt')),
              body: const Center(child: Text('Prompt not found')),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_loaded) {
              _seedFields(title: prompt.title, body: prompt.body);
              setState(() {});
            }
          });
          return _buildScaffold(context);
        },
        loading: () => Scaffold(
          appBar: AppBar(title: const Text('Edit prompt')),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Scaffold(
          appBar: AppBar(title: const Text('Edit prompt')),
          body: Center(child: Text('Error: $error')),
        ),
      );
    }

    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    final title = widget.isEdit ? 'Edit prompt' : 'New prompt';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _leaveEditor();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _leaveEditor,
          ),
          actions: [TextButton(onPressed: _save, child: const Text('Save'))],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                errorText: _titleError,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                if (_titleError != null) {
                  setState(() => _titleError = null);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Body',
                alignLabelWithHint: true,
                errorText: _bodyError,
              ),
              minLines: 6,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onChanged: (_) {
                if (_bodyError != null) {
                  setState(() => _bodyError = null);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
