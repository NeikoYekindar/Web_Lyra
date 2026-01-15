import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/widgets/common/header_info_section.dart';
import 'package:lyra/widgets/common/favorite_card.dart';
import '../../models/current_user.dart';
import '../../models/user.dart';
import 'package:lyra/l10n/app_localizations.dart';


class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> types = ['Folk', 'Pop', 'Latin'];
    final List<Map<String, dynamic>> apiResponse = [
      {
        'id': '1',
        'name': 'SonTung_pl',
        'type': 'Playlist',
        'owner': 'Trùm UIT',
        'image': 'assets/images/album_2.png',
      },
      {
        'id': '2',
        'name': 'HoangDung_pl',
        'type': 'Playlist',
        'owner': 'Trùm UIT',
        'image': 'assets/images/album_3.png',
      },

      // Thêm các bài hát khác tương tự
    ];
    return Center(
      child: SizedBox(
        width: 380,
        height: 380, // Fixed height for modal
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile View",
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                // --- Header info (reactive to CurrentUser) ---
                SizedBox(
                  height: 70, // Đảm bảo Stack có chiều cao xác định
                  child: ValueListenableBuilder<UserModel?>(
                    valueListenable: CurrentUser.instance.userNotifier,
                    builder: (context, user, _) {
                      final profileImage = user?.profileImageUrl;
                      Widget imageWidget;
                      if (profileImage == null || profileImage.isEmpty) {
                        imageWidget = Image.asset('assets/images/avatar.png');
                      } else if (profileImage.startsWith('http')) {
                        imageWidget = Image.network(profileImage);
                      } else {
                        imageWidget = Image.asset(profileImage);
                      }

                      return HeaderInfoSection(
                        background: LinearGradient(
                          colors: [Colors.transparent, Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        horizontalPadding: 10,
                        imageSize: 64,
                        imageShape: BoxShape.circle,
                        image: imageWidget,
                        title: Text(
                          user?.displayName ?? 'Trùm UIT',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              "18 "+ AppLocalizations.of(context)!.publicPlaylist,
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              "  •  ",
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              "36 "+ AppLocalizations.of(context)!.following,
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        bio: Text(
                          user?.bio ?? 'kakakakakaka',
                          style: GoogleFonts.inter(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Favorite",
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: types.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: FavoriteCard(item: types[i], isPicked: true),
                        );
                      },
                    ),
                  ),
                ),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withAlpha((0.2 * 255).round()),
                  thickness: 1,
                  height: 30,
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: apiResponse.length,
                      itemBuilder: (context, i) {
                        return Container(
                          height: 63,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                          ),
                          child: HeaderInfoSection(
                            background: LinearGradient(
                              colors: [Colors.transparent, Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            horizontalPadding: 4,
                            image: Image.asset(apiResponse[i]['image']),
                            imageShape: BoxShape.rectangle,
                            imageBorderRadius: BorderRadius.circular(10),
                            imageSize: 55,
                            title: Text(
                              apiResponse[i]['name'],
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  apiResponse[i]['type'],
                                  style: GoogleFonts.inter(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  "  •  ",
                                  style: GoogleFonts.inter(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  apiResponse[i]['owner'],
                                  style: GoogleFonts.inter(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
