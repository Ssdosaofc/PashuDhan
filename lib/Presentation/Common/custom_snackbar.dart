import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

class CustomSnackbar {
  static OverlayEntry? _currentSnackbar;
  static _SnackbarWidgetState? _currentState;

  static showSnackBar({
    required String text,
    required BuildContext context,
  }) {
    if (_currentState != null && _currentSnackbar != null) {
      _currentState!.updateMessage(text);
      return;
    }

    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          bottom: bottomInset + 20,
          left: 8,
          right: 8,
          child: _SnackbarWidget(
            message: text,
            duration: const Duration(seconds: 4),
            onDismissed: () {
              _currentSnackbar?.remove();
              _currentSnackbar = null;
              _currentState = null;
            },
            onStateCreated: (state) {
              _currentState = state;
            },
          ),
        );
      },
    );

    _currentSnackbar = entry;
    overlay.insert(entry);
  }
}

class _SnackbarWidget extends StatefulWidget {
  final String message;
  final Duration duration;
  final VoidCallback onDismissed;
  final void Function(_SnackbarWidgetState) onStateCreated;

  const _SnackbarWidget({
    required this.message,
    required this.onDismissed,
    required this.onStateCreated,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<_SnackbarWidget> createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late String _message;

  @override
  void initState() {
    super.initState();
    _message = widget.message;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _slide = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeInBack,
      ),
    );

    widget.onStateCreated(this);

    Future.delayed(widget.duration, () {
      if (mounted) _dismissWithAnimation();
    });
  }

  void updateMessage(String newMessage) {
    if (mounted) {
      setState(() {
        _message = newMessage;
      });
    }
  }

  void _dismissWithAnimation() {
    if (!mounted) return;
    if (_controller.isAnimating) return;

    _controller.reverse().then((_) {
      if (mounted) widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.horizontal,
        onDismissed: (_) => _dismissWithAnimation(),
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! > 0) {
              _dismissWithAnimation();
            }
          },
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: ColorConstants.c000000,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _message,
                      style: const TextStyle(color: ColorConstants.cFFFFFF),
                    ),
                  ),
                  GestureDetector(
                    onTap: _dismissWithAnimation,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(Icons.close,
                          color: ColorConstants.cEBEBEB, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}