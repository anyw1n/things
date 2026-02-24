import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

/// Visual variants available for [AnimatedTopSnackBar].
enum AnimatedTopSnackBarType {
  info(),
  error(backgroundColor: Color(0xFFB71C1C))
  ;

  const AnimatedTopSnackBarType({this.backgroundColor});

  /// Optional custom background color for this variant.
  final Color? backgroundColor;
}

/// Floating top snack bar with fade-in and typewriter text animation.
class AnimatedTopSnackBar extends StatefulWidget {
  const AnimatedTopSnackBar({
    required this.message,
    required this.type,
    required this.opacityAnimationDuration,
    required this.typingAnimationSpeed,
    required this.showDuration,
    required this.textAlign,
    required this.onDismissed,
    super.key,
  });

  /// Message rendered with the typewriter animation.
  final String message;

  /// Visual style variant.
  final AnimatedTopSnackBarType type;

  /// Duration for fade-in/fade-out opacity animation.
  final Duration opacityAnimationDuration;

  /// Interval used to reveal the next character.
  final Duration typingAnimationSpeed;

  /// Time to keep the snackbar visible before dismissing.
  final Duration showDuration;

  /// Text alignment inside the snackbar.
  final TextAlign textAlign;

  /// Callback called after the snackbar is fully dismissed.
  final VoidCallback onDismissed;

  /// Inserts an overlay entry and removes it when the animation completes.
  static void show({
    required BuildContext context,
    required String message,
    required AnimatedTopSnackBarType type,
    EdgeInsets margin = const .all(16),
    AlignmentGeometry alignment = Alignment.center,
    Duration opacityAnimationDuration = const .new(milliseconds: 600),
    Duration typingAnimationSpeed = const .new(milliseconds: 50),
    Duration showDuration = const .new(seconds: 2),
    TextAlign textAlign = .center,
  }) {
    late final OverlayEntry overlayEntry;

    overlayEntry = .new(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + margin.top,
        left: margin.left,
        right: margin.right,
        child: Align(
          alignment: alignment,
          child: AnimatedTopSnackBar(
            message: message,
            type: type,
            opacityAnimationDuration: opacityAnimationDuration,
            typingAnimationSpeed: typingAnimationSpeed,
            showDuration: showDuration,
            textAlign: textAlign,
            onDismissed: overlayEntry.remove,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @Preview()
  static Widget preview() => Column(
    spacing: 16,
    children: [
      AnimatedTopSnackBar(
        message: 'Some message',
        type: .info,
        opacityAnimationDuration: const .new(milliseconds: 600),
        typingAnimationSpeed: const .new(milliseconds: 50),
        showDuration: const .new(seconds: 2),
        textAlign: .center,
        onDismissed: () {},
      ),
      AnimatedTopSnackBar(
        message: 'Error message',
        type: .error,
        opacityAnimationDuration: const .new(milliseconds: 600),
        typingAnimationSpeed: const .new(milliseconds: 50),
        showDuration: const .new(seconds: 2),
        textAlign: .center,
        onDismissed: () {},
      ),
      AnimatedTopSnackBar(
        message: 'Loooooooooooong message ' * 4,
        type: .info,
        opacityAnimationDuration: const .new(milliseconds: 600),
        typingAnimationSpeed: const .new(milliseconds: 50),
        showDuration: const .new(seconds: 2),
        textAlign: .center,
        onDismissed: () {},
      ),
    ],
  );

  @override
  State<AnimatedTopSnackBar> createState() => _AnimatedTopSnackBarState();
}

class _AnimatedTopSnackBarState extends State<AnimatedTopSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  late final Characters _chars;

  var _displayedText = '';
  var _charsDisplayed = 0;

  Timer? _typingTimer;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _chars = widget.message.characters;

    _controller = .new(
      vsync: this,
      duration: widget.opacityAnimationDuration,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    if (widget.typingAnimationSpeed == .zero) {
      _charsDisplayed = _chars.length;
      _displayedText = widget.message;
    }

    _controller.forward().then((_) => _startTyping());
  }

  /// Reveals text one grapheme at a time to support composed characters.
  void _startTyping() {
    if (_charsDisplayed == _chars.length) {
      _startDismissTimer();
      return;
    }
    _typingTimer = .periodic(widget.typingAnimationSpeed, (timer) {
      if (_charsDisplayed < _chars.length) {
        _charsDisplayed++;
        _displayedText = _chars.take(_charsDisplayed).toString();
        setState(() {});
      } else {
        timer.cancel();
        _startDismissTimer();
      }
    });
  }

  /// Starts a delayed fade-out and invokes dismissal callback afterwards.
  void _startDismissTimer() {
    _dismissTimer = .new(widget.showDuration, () {
      _controller.reverse().then((_) => widget.onDismissed());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _typingTimer?.cancel();
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Material(
        color:
            widget.type.backgroundColor ??
            ColorScheme.of(context).surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(24),
        ),
        elevation: 8,
        child: Padding(
          padding: const .symmetric(horizontal: 24, vertical: 12),
          child: Text(
            _displayedText,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            textAlign: widget.textAlign,
          ),
        ),
      ),
    );
  }
}
