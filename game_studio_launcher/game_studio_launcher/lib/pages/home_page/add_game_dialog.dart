import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/gameItem.dart';
import 'game_banner.dart';

/// Form for adding a game to the launcher.
///
/// Pops the new [GameItem] when saved, or null when cancelled; persisting it is
/// the caller's job.
class AddGameDialog extends StatefulWidget {
  const AddGameDialog({super.key});

  static Future<GameItem?> show(BuildContext context) => showDialog<GameItem>(
        context: context,
        builder: (_) => const AddGameDialog(),
      );

  @override
  State<AddGameDialog> createState() => _AddGameDialogState();
}

class _AddGameDialogState extends State<AddGameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _executableController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _executableController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _browseForExecutable() async {
    // Only Windows reliably identifies executables by extension; elsewhere the
    // launcher accepts whatever the user points at.
    final result = await FilePicker.pickFiles(
      dialogTitle: 'Select the game executable',
      lockParentWindow: true,
      type: Platform.isWindows ? FileType.custom : FileType.any,
      allowedExtensions: Platform.isWindows ? const ['exe'] : null,
    );

    final path = result?.files.single.path;
    if (path != null) {
      setState(() {
        _executableController.text = path;
        // Offer the executable's own name as the title when it is still blank.
        if (_nameController.text.trim().isEmpty) {
          final fileName = path.split(Platform.pathSeparator).last;
          _nameController.text = fileName.replaceAll(
            RegExp(r'\.exe$', caseSensitive: false),
            '',
          );
        }
      });
    }
  }

  Future<void> _browseForImage() async {
    final result = await FilePicker.pickFiles(
      dialogTitle: 'Select a banner image',
      lockParentWindow: true,
      type: FileType.image,
    );

    final path = result?.files.single.path;
    if (path != null) {
      setState(() => _imageController.text = path);
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(
      GameItem(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        path: _executableController.text.trim(),
        imagePath: _imageController.text.trim(),
        isVisible: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return AlertDialog(
      backgroundColor: theme.secondaryBackground,
      title: Text('Add Game', style: theme.headlineSmall),
      content: SizedBox(
        width: 560.0,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field(
                  controller: _nameController,
                  label: 'Name',
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Give the game a name'
                      : null,
                ),
                const SizedBox(height: 12.0),
                _field(
                  controller: _descriptionController,
                  label: 'Description',
                  maxLines: 3,
                ),
                const SizedBox(height: 12.0),
                _field(
                  controller: _executableController,
                  label: 'Executable',
                  hint: r'C:\Games\MyGame\MyGame.exe',
                  onBrowse: _browseForExecutable,
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Choose the file that starts the game'
                      : null,
                ),
                const SizedBox(height: 12.0),
                _field(
                  controller: _imageController,
                  label: 'Banner image',
                  hint: 'A file on this PC, or an https:// link',
                  onBrowse: _browseForImage,
                  // Re-render the preview as a pasted URL is typed.
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16.0),
                Text('Preview', style: theme.labelMedium),
                const SizedBox(height: 6.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: GameBanner(
                    imagePath: _imageController.text.trim(),
                    width: 200.0,
                    height: 163.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: theme.secondaryText)),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(backgroundColor: theme.primary),
          child: const Text('Add Game'),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    VoidCallback? onBrowse,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            onChanged: onChanged,
            validator: validator,
            style: theme.bodyMedium,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              labelStyle: theme.labelMedium,
              hintStyle: theme.labelSmall,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        if (onBrowse != null) ...[
          const SizedBox(width: 8.0),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: OutlinedButton.icon(
              onPressed: onBrowse,
              icon: const Icon(Icons.folder_open, size: 18.0),
              label: const Text('Browse'),
            ),
          ),
        ],
      ],
    );
  }
}
