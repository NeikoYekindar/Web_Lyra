import 'package:flutter/material.dart';
import 'package:lyra/models/media_item.dart';

class MediaCard extends StatefulWidget {
  final MediaItem item;
  final VoidCallback? onTap;
  final double? size;
  final BoxShape imageShape;
  final BorderRadius? imageBorderRadius;

  const MediaCard({
    Key? key,
    required this.item,
    this.onTap,
    this.size,
    this.imageShape = BoxShape.rectangle,
    this.imageBorderRadius,
  }) : super(key: key);

  @override
  State<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> {
  bool _hovering = false;
  bool _pressed = false;

  Color _backgroundColor(BuildContext context) {
    if (_pressed) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.15);
    }
    if (_hovering) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.08);
    }
    return Theme.of(context).colorScheme.surfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    final cardSize = widget.size ?? 180.0;
    final imageSize = cardSize;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() {
        _hovering = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: cardSize,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _backgroundColor(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: widget.imageShape,
                  borderRadius: widget.imageShape == BoxShape.rectangle
                      ? (widget.imageBorderRadius ?? BorderRadius.circular(8))
                      : null,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: ClipRRect(
                  borderRadius: widget.imageShape == BoxShape.rectangle
                      ? (widget.imageBorderRadius ?? BorderRadius.circular(8))
                      : BorderRadius.circular(999),
                  child:
                      widget.item.imageUrl != null &&
                          widget.item.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(context),
                        )
                      : _buildPlaceholder(context),
                ),
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                widget.item.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Subtitle (Artist/Owner)
              Text(
                widget.item.subtitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Additional info (Duration/Song count)
              if (widget.item.additionalInfo != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.item.additionalInfo!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Icon(
        Icons.music_note,
        size: 48,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
