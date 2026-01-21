import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/widgets/common/header_info_section.dart';
import 'package:lyra/widgets/common/favorite_card.dart';
import '../../models/current_user.dart';
import '../../models/user.dart';
import '../../core/di/service_locator.dart';
import '../../services/playlist_service_v2.dart';
import 'package:lyra/l10n/app_localizations.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<Playlist>? _userPlaylists;
  bool _isLoadingPlaylists = true;

  @override
  void initState() {
    super.initState();
    _loadUserPlaylists();
  }

  Future<void> _loadUserPlaylists() async {
    try {
      final playlists = await serviceLocator.playlistService.getUserPlaylists();
      if (mounted) {
        setState(() {
          _userPlaylists = playlists;
          _isLoadingPlaylists = false;
        });
      }
    } catch (e) {
      print('Error loading playlists in profile view: $e');
      if (mounted) {
        setState(() {
          _userPlaylists = [];
          _isLoadingPlaylists = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> types = ['Folk', 'Pop', 'Latin'];
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

                      final publicCount = user?.publicPlaylists ?? 0;
                      final followingCount = user?.following ?? 0;

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
                              "$publicCount ${AppLocalizations.of(context)!.publicPlaylist}",
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
                              "$followingCount ${AppLocalizations.of(context)!.following}",
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        bio: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.bio ?? 'kakakakakaka',
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                if (user?.email != null)
                                  Text(
                                    user!.email,
                                    style: GoogleFonts.inter(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                if (user?.gender != null)
                                  Text(
                                    user!.gender ?? '',
                                    style: GoogleFonts.inter(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                if (user?.dateOfBirth != null)
                                  Text(
                                    '${user!.dateOfBirth!.day.toString().padLeft(2, '0')}/${user.dateOfBirth!.month.toString().padLeft(2, '0')}/${user.dateOfBirth!.year}',
                                    style: GoogleFonts.inter(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                if (user?.userType != null)
                                  Text(
                                    user!.userType,
                                    style: GoogleFonts.inter(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                              ],
                            ),
                          ],
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
                    child: ValueListenableBuilder<UserModel?>(
                      valueListenable: CurrentUser.instance.userNotifier,
                      builder: (context, user, _) {
                        final favs = user?.favoriteGenres ?? types;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: favs.length,
                          itemBuilder: (context, i) {
                            return Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: FavoriteCard(
                                item: favs[i],
                                isPicked: true,
                              ),
                            );
                          },
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
                  child: _isLoadingPlaylists
                      ? const Center(child: CircularProgressIndicator())
                      : (_userPlaylists == null || _userPlaylists!.isEmpty)
                      ? Center(
                          child: Text(
                            "No playlists yet",
                            style: GoogleFonts.inter(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _userPlaylists!.length,
                            itemBuilder: (context, i) {
                              final playlist = _userPlaylists![i];
                              Widget playlistImage;
                              if (playlist.coverUrl != null &&
                                  playlist.coverUrl!.isNotEmpty) {
                                if (playlist.coverUrl!.startsWith('http')) {
                                  playlistImage = Image.network(
                                    playlist.coverUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceVariant,
                                        child: Icon(
                                          Icons.music_note,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  playlistImage = Image.asset(
                                    playlist.coverUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceVariant,
                                        child: Icon(
                                          Icons.music_note,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      );
                                    },
                                  );
                                }
                              } else {
                                playlistImage = Container(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceVariant,
                                  child: Icon(
                                    Icons.music_note,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                );
                              }

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
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  horizontalPadding: 4,
                                  image: playlistImage,
                                  imageShape: BoxShape.rectangle,
                                  imageBorderRadius: BorderRadius.circular(10),
                                  imageSize: 55,
                                  title: Text(
                                    playlist.name,
                                    style: GoogleFonts.inter(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        "Playlist",
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
                                        playlist.ownerName ?? 'Unknown',
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
