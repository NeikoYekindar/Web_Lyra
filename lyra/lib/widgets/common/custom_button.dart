import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';

/// Primary (filled) red button - no border
class PrimaryButton extends StatelessWidget {
  final Widget child;
  final Widget? icon; // optional leading icon
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final bool isLoading;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.child,
    this.icon,
    this.onPressed,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? const Color(0xFFDA0707);
    final content = isLoading
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
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              Flexible(child: child),
            ],
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius as BorderRadius?,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(color: bg, borderRadius: borderRadius),
          child: Center(child: content),
        ),
      ),
    );
  }
}

/// Outline (transparent) button with border
class OutlineButtonCustom extends StatelessWidget {
  final Widget child;
  final Widget? icon;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final Color? borderColor;
  final Color? textColor;
  final bool isLoading;

  const OutlineButtonCustom({
    super.key,
    required this.child,
    this.icon,
    this.onPressed,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.borderColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabledColor = const Color(0xFF565656);
    final enabledTextColor = textColor ?? Colors.white;
    final enabledBorderColor = borderColor ?? Colors.white;

    final bool enabled = onPressed != null && !isLoading;
    final bc = enabled ? enabledBorderColor : disabledColor;
    final tc = enabled ? enabledTextColor : disabledColor;

    final content = isLoading
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
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: tc),
                  child: icon!,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: DefaultTextStyle(
                  style: TextStyle(color: tc),
                  child: child,
                ),
              ),
            ],
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius as BorderRadius?,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: borderRadius,
            border: Border.all(color: bc, width: 1),
          ),
          child: Center(child: content),
        ),
      ),
    );
  }
}
