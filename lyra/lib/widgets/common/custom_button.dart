import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const PrimaryButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  double _scale = 1.0;
  bool _isHovered = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.96);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = _isHovered ? 1.04 : 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = _isHovered ? 1.04 : 1.0);
  }

  void _onHover(bool hover) {
    setState(() {
      _isHovered = hover;
      _scale = hover ? 1.04 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? Theme.of(context).colorScheme.primary;
    final hoverBg = bg.withOpacity(_isHovered ? 0.92 : 1.0);
    final content = widget.isLoading
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              Flexible(child: widget.child),
            ],
          );

    final BorderRadius borderRadius =
        widget.borderRadius ?? BorderRadius.circular(8.0);
    final EdgeInsetsGeometry padding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: borderRadius,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                width: widget.width,
                height: widget.height,
                padding: padding,
                decoration: BoxDecoration(
                  color: hoverBg,
                  borderRadius: borderRadius,
                ),
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineButtonCustom extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;

  const OutlineButtonCustom({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.textColor,
    this.borderColor,
    this.borderRadius,
  });

  @override
  State<OutlineButtonCustom> createState() => _OutlineButtonCustomState();
}

class _OutlineButtonCustomState extends State<OutlineButtonCustom> {
  double _scale = 1.0;
  bool _isHovered = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.96);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = _isHovered ? 1.04 : 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = _isHovered ? 1.04 : 1.0);
  }

  void _onHover(bool hover) {
    setState(() {
      _isHovered = hover;
      _scale = hover ? 1.04 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final disabledColor = Theme.of(
      context,
    ).colorScheme.onSurface.withOpacity(0.38);
    final enabledTextColor =
        widget.textColor ?? Theme.of(context).colorScheme.onPrimary;
    final enabledBorderColor =
        widget.borderColor ?? Theme.of(context).colorScheme.outline;

    final bool enabled = widget.onPressed != null && !widget.isLoading;
    final bc = enabled ? enabledBorderColor : disabledColor;
    final tc = enabled ? enabledTextColor : disabledColor;
    final hoverBorder = _isHovered ? bc.withOpacity(0.7) : bc;

    final BorderRadius borderRadius =
        widget.borderRadius ?? BorderRadius.circular(8.0);
    final EdgeInsetsGeometry padding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    final content = widget.isLoading
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(tc),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: tc),
                  child: widget.icon!,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: DefaultTextStyle(
                  style: TextStyle(color: tc),
                  child: widget.child,
                ),
              ),
            ],
          );

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: borderRadius,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                width: widget.width,
                height: widget.height,
                padding: padding,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: borderRadius,
                  border: Border.all(color: hoverBorder, width: 1),
                ),
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
