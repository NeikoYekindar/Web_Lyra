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

class PlaylistCard extends StatelessWidget {
  final PlaylistItem item;
  final VoidCallback? onTap;

  const PlaylistCard({Key? key, required this.item, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cardSize = item.size ?? 180;
    final double coverSize = item.imageSize ?? (cardSize - 10);
    final BoxShape imageShape = item.imageShape ?? BoxShape.rectangle;
    final BoxFit imageFit = item.imageFit ?? BoxFit.cover;

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: cardSize,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
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
                      : (item.imageBorderRadius ?? BorderRadius.circular(5)),
                  color: Colors.grey[800],
                  image: item.coverUrl != null
                      ? DecorationImage(
                          image: NetworkImage(item.coverUrl!),
                          fit: imageFit,
                        )
                      : null,
                ),
                child: item.coverUrl == null
                    ? Center(
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white54,
                          size: coverSize * 0.3,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Author
              Text(
                item.author,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Song count & duration
              if (item.songCount != null || item.duration != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    children: [
                      if (item.songCount != null)
                        Text(
                          '${item.songCount} bài hát',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      if (item.songCount != null && item.duration != null)
                        const Text(
                          ' • ',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      if (item.duration != null)
                        Text(
                          item.duration!,
                          style: const TextStyle(
                            color: Colors.grey,
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
