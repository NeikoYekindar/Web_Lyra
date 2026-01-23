import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteCard extends StatelessWidget {
  final String item;
  final bool isPicked;
  final VoidCallback? onTap;
  final double minHeight;
  final double minWidth;
  const FavoriteCard({
    super.key,
    required this.item,
    this.isPicked = false,
    this.onTap,
    this.minHeight = 40,
    this.minWidth = 70,
  });

  @override
  Widget build(BuildContext context) {
    final pickedBg = Theme.of(context).colorScheme.onSurface;
    final pickedText = Theme.of(context).colorScheme.surface;
    final unpickedBg = Theme.of(context).colorScheme.surfaceContainerHighest;
    final unpickedText = Theme.of(context).colorScheme.onSurfaceVariant;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          item,
          style: GoogleFonts.inter(
            color: isPicked ? pickedText : unpickedText,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );

    return Material(
      color: isPicked ? pickedBg : unpickedBg,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minHeight,
                  minWidth: minWidth,
                  maxWidth: 100,
                ),
                child: content,
              ),
      ),
    );
  }
}
