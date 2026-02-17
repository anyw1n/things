import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:things/core/i18n/translations.g.dart';

class ThoughtInputWidget extends StatefulWidget {
  const ThoughtInputWidget({
    required this.onSubmit,
    required this.enabled,
    required this.isLoading,
    super.key,
  });

  final ValueChanged<String> onSubmit;
  final bool enabled;
  final bool isLoading;

  @Preview()
  static Widget preview() => Column(
    spacing: 16,
    children: [
      ThoughtInputWidget(
        onSubmit: (_) {},
        enabled: true,
        isLoading: false,
      ),
      ThoughtInputWidget(
        onSubmit: (_) {},
        enabled: false,
        isLoading: true,
      ),
    ],
  );

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
    return ConstrainedBox(
      constraints: const .new(minHeight: 56),
      child: Material(
        color: ColorScheme.of(context).surfaceContainer,
        shape: RoundedRectangleBorder(
          side: const .new(width: 0.5, color: Colors.white24),
          borderRadius: .circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4).copyWith(left: 16),
          child: Row(
            crossAxisAlignment: .end,
            spacing: 8,
            children: [
              Expanded(
                child: AnimatedSize(
                  alignment: .bottomCenter,
                  duration: const .new(milliseconds: 200),
                  child: TextField(
                    enabled: widget.enabled,
                    controller: _controller,
                    textCapitalization: .sentences,
                    minLines: 1,
                    maxLines: 12,
                    decoration: .new(
                      hintText: t.dailyScreen.addThoughtHint,
                      border: .none,
                    ),
                    onSubmitted: (_) => _submit(),
                    onTapUpOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                  ),
                ),
              ),
              _SendButton(
                onPressed: _submit,
                enabled: widget.enabled,
                isLoading: widget.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.onPressed,
    required this.enabled,
    required this.isLoading,
  });

  final void Function() onPressed;
  final bool enabled;
  final bool isLoading;

  static const _iconSize = 24.0;
  static const _iconPadding = EdgeInsets.all(12);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? Colors.deepPurple
          : ColorScheme.of(context).secondaryContainer,
      animateColor: true,
      shape: const CircleBorder(),
      child: AnimatedCrossFade(
        crossFadeState: isLoading ? .showFirst : .showSecond,
        duration: const .new(milliseconds: 300),
        firstChild: const Padding(
          padding: _iconPadding,
          child: SizedBox.square(
            dimension: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              strokeCap: .round,
              color: Colors.white,
            ),
          ),
        ),
        secondChild: IconButton(
          iconSize: _iconSize,
          padding: _iconPadding,
          color: Colors.white,
          onPressed: enabled ? onPressed : null,
          icon: const Icon(Icons.arrow_upward_rounded),
        ),
      ),
    );
  }
}
