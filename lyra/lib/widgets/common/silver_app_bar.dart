import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'header_info_section.dart';
import '../popup/profile_view.dart';
import 'package:lyra/models/current_user.dart';
import 'package:lyra/models/user.dart';

class ProfileSliverAppBar extends StatefulWidget {
  final ValueNotifier<double> offset;

  const ProfileSliverAppBar({super.key, required this.offset});

  @override
  State<ProfileSliverAppBar> createState() => _ProfileSliverAppBarState();
}

class _ProfileSliverAppBarState extends State<ProfileSliverAppBar> {
  @override
  void initState() {
    super.initState();
    // restore persisted user for demo purposes
    Future.microtask(() => CurrentUser.instance.restoreFromPrefs());
  }

  @override
  Widget build(BuildContext context) {
    const double expandedHeight = 240;

    return ValueListenableBuilder<double>(
      valueListenable: widget.offset,
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
        color: overlapsContent
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surface,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.3),
                  ],
                ),
              ),
            ),
            // HEADER LỚN — fade khi scroll (reactive to CurrentUser)
            Opacity(
              opacity: 1 - t,
              child: ValueListenableBuilder<UserModel?>(
                valueListenable: CurrentUser.instance.userNotifier,
                builder: (context, user, _) {
                  final displayName = user?.displayName ?? 'Profile';
                  final profileImage = user?.profileImageUrl;
                  Widget imageWidget;
                  if (profileImage == null || profileImage.isEmpty) {
                    imageWidget = Image.asset(
                      'assets/images/avatar.png',
                      fit: BoxFit.cover,
                    );
                  } else if (profileImage.startsWith('http')) {
                    imageWidget = Image.network(
                      profileImage,
                      fit: BoxFit.cover,
                    );
                  } else {
                    imageWidget = Image.asset(profileImage, fit: BoxFit.cover);
                  }

                  return HeaderInfoSection(
                    background: null,
                    imageSize: 180 - (t * 60),
                    imageShape: BoxShape.circle,
                    image: imageWidget,
                    type: Text(
                      "Profile",
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20,
                      ),
                    ),
                    title: Text(
                      displayName,
                      style: GoogleFonts.inter(
                        fontSize: 60,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          user?.publicPlaylists != null
                              ? "${user!.publicPlaylists} Public Playlists"
                              : "0 Public Playlists",
                          style: GoogleFonts.inter(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          "  •  ",
                          style: GoogleFonts.inter(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          user?.following != null
                              ? "${user!.following} Following"
                              : "0 Following",
                          style: GoogleFonts.inter(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 1,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ICON BUTTON — CHỒNG LÊN Ở GÓC PHẢI
            if (t < 1)
              Positioned(
                top: 20,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.open_in_new_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
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

            // MINI HEADER khi scroll thu nhỏ (reactive)
            Align(
              alignment: Alignment.bottomLeft,
              child: Opacity(
                opacity: t,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 14),
                  child: ValueListenableBuilder<UserModel?>(
                    valueListenable: CurrentUser.instance.userNotifier,
                    builder: (context, user, _) {
                      final mini = user?.displayName ?? 'Trùm UIT';
                      return Text(
                        mini,
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
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
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
