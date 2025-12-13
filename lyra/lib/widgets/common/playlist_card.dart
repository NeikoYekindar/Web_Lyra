import 'package:flutter/material.dart';

class PlaylistItem {
  final String title;
  final String author;
  final String? coverUrl;
  final int? songCount;
  final String? duration;
  final double? size;
  final double? imageSize; // Thêm kích thước ảnh
  final BoxShape? imageShape; // Thêm hình dạng ảnh
  final BorderRadius? imageBorderRadius; // Thêm bo góc tùy chỉnh
  final BoxFit? imageFit; // Thêm cách fit ảnh

  const PlaylistItem({
    required this.title,
    required this.author,
    this.coverUrl,
    this.songCount,
    this.duration,
    this.size,
    this.imageSize,
    this.imageShape,
    this.imageBorderRadius,
    this.imageFit,
  });
}

class PlaylistCard extends StatefulWidget {
  final PlaylistItem item;
  final VoidCallback? onTap;

  const PlaylistCard({Key? key, required this.item, this.onTap})
    : super(key: key);

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  bool _hovering = false;
  bool _pressed = false;

  Color _backgroundColor(BuildContext context) {
    if (_pressed) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.15);
    }
    if (_hovering) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.08);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final double cardSize = widget.item.size ?? 180;
    final double coverSize = widget.item.imageSize ?? (cardSize - 10);
    final BoxShape imageShape = widget.item.imageShape ?? BoxShape.rectangle;
    final BoxFit imageFit = widget.item.imageFit ?? BoxFit.cover;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() {
        _hovering = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          width: cardSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: _backgroundColor(context),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover với hình dạng tùy chỉnh
              Container(
                width: coverSize,
                height: coverSize,
                decoration: BoxDecoration(
                  shape: imageShape,
                  borderRadius: imageShape == BoxShape.circle
                      ? null
                      : (widget.item.imageBorderRadius ??
                            BorderRadius.circular(5)),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  image: widget.item.coverUrl != null
                      ? DecorationImage(
                          image: NetworkImage(widget.item.coverUrl!),
                          fit: imageFit,
                        )
                      : null,
                ),
                child: widget.item.coverUrl == null
                    ? Center(
                        child: Icon(
                          Icons.music_note,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: coverSize * 0.3,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                widget.item.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Author
              Text(
                widget.item.author,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Song count & duration
              if (widget.item.songCount != null || widget.item.duration != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    children: [
                      if (widget.item.songCount != null)
                        Text(
                          '${widget.item.songCount} bài hát',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      if (widget.item.songCount != null &&
                          widget.item.duration != null)
                        Text(
                          ' • ',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      if (widget.item.duration != null)
                        Text(
                          widget.item.duration!,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
