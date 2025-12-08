import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackItem extends StatefulWidget {
  final int index;
  final String title;
  final String artist;
  final String albumArtist;
  final String duration;
  final String image;

  const TrackItem({
    super.key,
    required this.index,
    required this.title,
    required this.artist,
    required this.albumArtist,
    required this.duration,
    required this.image,
  });

  @override
  State<TrackItem> createState() => _TrackItemState();
}

class _TrackItemState extends State<TrackItem> {
  bool _hovering = false;
  bool _pressed = false;

  Color _backgroundColor(BuildContext context) {
    if (_pressed) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.13);
    }
    if (_hovering) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.07);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          color: _backgroundColor(context),
          child: Row(
            children: [
              // Số thứ tự
              SizedBox(
                width: 28,
                child: Text(
                  widget.index.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              // Ảnh bài hát
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: buildCoverImage(widget.image),
              ),
              const SizedBox(width: 12),

              // Tên + Nghệ sĩ
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      widget.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Album artist (hoặc artist thứ 2)
              Expanded(
                flex: 2,
                child: Text(
                  widget.albumArtist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              // Duration
              SizedBox(
                width: 50,
                child: Text(
                  widget.duration,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildCoverImage(String coverUrl) {
  if (coverUrl.startsWith('http')) {
    return Image.network(coverUrl, fit: BoxFit.cover, width: 50, height: 50);
  } else {
    return Image.asset(coverUrl, fit: BoxFit.cover, width: 50, height: 50);
  }
}
