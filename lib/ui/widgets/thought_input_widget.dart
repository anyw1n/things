import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:things/i18n/translations.g.dart';

class ThoughtInputWidget extends StatefulWidget {
  const ThoughtInputWidget({required this.onSubmit, super.key});

  final ValueChanged<String> onSubmit;

  @Preview()
  static Widget preview() => ThoughtInputWidget(onSubmit: (_) {});

  @override
  State<ThoughtInputWidget> createState() => _ThoughtInputWidgetState();
}

class _ThoughtInputWidgetState extends State<ThoughtInputWidget> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmit(text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: t.addThoughtHint,
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submit,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(255)),
          ),
        ),
        onSubmitted: (_) => _submit(),
      ),
    );
  }
}
