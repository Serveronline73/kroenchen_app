import 'package:flutter/material.dart';
import 'package:kroenchen_app/shared/models/diary.dart';

class DiaryEntryDialog extends StatefulWidget {
  final DiaryEntry? existingEntry;
  final Function(DiaryEntry) onSave;

  const DiaryEntryDialog({
    super.key,
    this.existingEntry,
    required this.onSave,
  });

  @override
  State<DiaryEntryDialog> createState() => _DiaryEntryDialogState();
}

class _DiaryEntryDialogState extends State<DiaryEntryDialog> {
  late TextEditingController controller;
  late bool hadFever;
  late bool pain;

  @override
  void initState() {
    super.initState();
    controller =
        TextEditingController(text: widget.existingEntry?.content ?? "");
    hadFever = widget.existingEntry?.hasFever ?? false;
    pain = widget.existingEntry?.pain ?? false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingEntry == null
          ? "Neuer Tagebucheintrag"
          : "Eintrag bearbeiten"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration:
                const InputDecoration(labelText: "Wie ging es dir heute?"),
          ),
          CheckboxListTile(
            title: const Text("Fieber?"),
            value: hadFever,
            onChanged: (value) => setState(() => hadFever = value ?? false),
          ),
          CheckboxListTile(
            title: const Text("Blut im Stuhl?"),
            value: pain,
            onChanged: (value) => setState(() => pain = value ?? false),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Abbrechen"),
        ),
        TextButton(
          onPressed: () {
            final newEntry = DiaryEntry(
              date: widget.existingEntry?.date ?? DateTime.now(),
              content: controller.text,
              hasFever: hadFever,
              pain: pain,
            );
            widget.onSave(newEntry);
            Navigator.of(context).pop();
          },
          child: const Text("Speichern"),
        ),
      ],
    );
  }
}
