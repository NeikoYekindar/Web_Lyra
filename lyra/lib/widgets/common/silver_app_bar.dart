import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'header_info_section.dart';
import '../profile/profile_view.dart';

class ProfileSliverAppBar extends StatelessWidget {
  final ValueNotifier<double> offset;

  const ProfileSliverAppBar({super.key, required this.offset});

  @override
  Widget build(BuildContext context) {
    const double expandedHeight = 350;

    return ValueListenableBuilder<double>(
      valueListenable: offset,
      builder: (context, value, _) {
        final double t = (value / expandedHeight).clamp(0, 1);

        return SliverPersistentHeader(
          pinned: true,
          delegate: _RoundedSliverDelegate(
            expandedHeight: expandedHeight,
            scrollValue: t,
          ),
        );
      },
    );
  }
}

class _RoundedSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double scrollValue;

  _RoundedSliverDelegate({
    required this.expandedHeight,
    required this.scrollValue,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double t = (shrinkOffset / expandedHeight).clamp(0, 1);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(6),
        topRight: Radius.circular(6),
      ),
      child: Container(
        color: const Color(0xFF121212),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // HEADER LỚN — fade khi scroll
            Opacity(
              opacity: 1 - t,
              child: HeaderInfoSection(
                imageSize: 220 - (t * 60),
                imageShape: BoxShape.circle,
                image: Image.asset('assets/images/avatar.png'),
                type: Text(
                  "Profile",
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 20),
                ),
                title: Text(
                  "Trùm UIT",
                  style: GoogleFonts.inter(
                    fontSize: 80,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      "18 Public Playlists",
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "  •  ",
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "36 Following",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ICON BUTTON — CHỒNG LÊN Ở GÓC PHẢI
            if (t < 1)
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.open_in_new_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black54,
                      builder: (context) {
                        return Center(
                          child: const ProfileView(),

                          // child: const Text(
                          //   'Hello',
                          //   style: TextStyle(color: Colors.white),
                          // ),
                        );
                      },
                    );
                  },
                ),
              ),

            // MINI HEADER khi scroll thu nhỏ
            Align(
              alignment: Alignment.bottomLeft,
              child: Opacity(
                opacity: t,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 14),
                  child: Text(
                    "Trùm UIT",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 10;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
