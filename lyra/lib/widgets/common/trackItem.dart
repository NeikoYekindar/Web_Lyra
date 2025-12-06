import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          // Số thứ tự
          SizedBox(
            width: 28,
            child: Text(
              index.toString(),
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
            ),
          ),

          // Ảnh bài hát
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: buildCoverImage(image),
          ),
          const SizedBox(width: 12),

          // Tên + Nghệ sĩ
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Album artist (hoặc artist thứ 2)
          Expanded(
            flex: 2,
            child: Text(
              albumArtist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400]),
            ),
          ),

          // Duration
          SizedBox(
            width: 50,
            child: Text(
              duration,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
            ),
          ),
        ],
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
