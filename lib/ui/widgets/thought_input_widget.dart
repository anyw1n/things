import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:things/i18n/translations.g.dart';

class ThoughtInputWidget extends StatefulWidget {
  const ThoughtInputWidget({
    required this.onSubmit,
    super.key,
  });

  final ValueChanged<String> onSubmit;

  @Preview()
  static Widget preview() => ThoughtInputWidget(onSubmit: (_) {});

  @override
  State<ThoughtInputWidget> createState() => _ThoughtInputWidgetState();
}

class _ThoughtInputWidgetState extends State<ThoughtInputWidget> {
  final _controller = TextEditingController();

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
    return TextField(
      controller: _controller,
      decoration: .new(
        hintText: t.dailyScreen.addThoughtHint,
        suffixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 4),
          child: Material(
            color: Colors.deepPurple,
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
              ),
              onPressed: _submit,
            ),
          ),
        ),
        fillColor: Colors.white.withValues(alpha: 0.05),
        filled: true,
        border: WidgetStateInputBorder.resolveWith(
          (states) => OutlineInputBorder(
            borderSide: const BorderSide(
              width: 0.5,
              color: Colors.white10,
            ),
            borderRadius: .circular(999),
          ),
        ),
      ),
      onSubmitted: (_) => _submit(),
    );
  }
}
