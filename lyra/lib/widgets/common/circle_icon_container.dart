import 'package:flutter/material.dart';

/// A flexible circular container for icons or small widgets.
///
/// - Circular shape (clip not required for purely decorative background).
/// - No border by default.
/// - Size adapts to content + `padding` unless `size` is provided.
/// - Optional `onTap` handler for click behavior.
class CircleIconContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double? size;
  final MouseCursor? mouseCursor;

  const CircleIconContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(8),
    this.onTap,
    this.size,
    this.mouseCursor,
  });

  @override
  Widget build(BuildContext context) {
    final container = Container(
      padding: padding,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color.fromARGB(23, 218, 7, 7),
        shape: BoxShape.circle,
      ),
      child: Center(child: child),
    );

    if (onTap != null) {
      return MouseRegion(
        cursor: mouseCursor ?? SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
          child: container,
        ),
      );
    }

    return container;
  }
}
