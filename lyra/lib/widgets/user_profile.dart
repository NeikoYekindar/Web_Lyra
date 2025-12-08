import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/widgets/common/header_info_section.dart';
import 'package:lyra/widgets/common/silver_app_bar.dart';
import 'package:lyra/widgets/common/playlist_card.dart';
import 'package:lyra/widgets/common/trackItem.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ValueNotifier<double> scrollOffset = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> followed = [
      {
        'id': '1',
        'name': 'Sơn Tùng M-TP',
        'type': 'Artist',
        'reference_url': 'abcdefg',
        'image': 'assets/images/album_3.png',
      },
      {
        'id': '2',
        'name': 'Hoàng Dũng',
        'type': 'Artist',
        'reference_url': 'abcdefg',
        'image': 'assets/images/album_2.png',
      },
    ];
    final List<Map<String, dynamic>> apiResponse = [
      {
        'id': '1',
        'name': 'KhongBuon_PL',
        'type': 'Playlist',
        'owner': 'TrumUIT',
        'image': 'assets/images/khongbuon.png',
      },
      {
        'id': '2',
        'name': 'EM XIN "SAY HI" 2025',
        'type': 'Playlist',
        'owner': 'TrumUIT',
        'image': 'assets/images/emxinsayhi_2025.png',
      },
      {
        'id': '3',
        'name': 'Playlist Sơn Tùng M-TP',
        'type': 'Playlist',
        'owner': 'TrumUIT',
        'image': 'assets/images/playlist_mtp.png',
      },
      {
        'id': '4',
        'name': 'SonTung_pl',
        'type': 'Playlist',
        'owner': 'TrumUIT',
        'image': 'assets/images/album_2.png',
      },
      {
        'id': '5',
        'name': 'HoangDung_pl',
        'type': 'Playlist',
        'owner': 'TrumUIT',
        'image': 'assets/images/album_3.png',
      },

      // Thêm các bài hát khác tương tự
    ];
    final List<Map<String, dynamic>> track_recent = [
      {
        "rank": 1,
        "title": "Buông Đôi Tay Nhau Ra",
        "artist": "Sơn Tùng M-TP",
        "albumArtist": "m-tp M-TP",
        "albumArt": "https://picsum.photos/seed/album1/200",
        "duration": "3:47",
        "last_listen": "2025-12-06T10:15:20",
      },
      {
        "rank": 2,
        "title": "Nơi Này Có Anh",
        "artist": "Sơn Tùng M-TP",
        "albumArtist": "Single - Nơi Này Có Anh",
        "albumArt": "https://picsum.photos/seed/album2/200",
        "duration": "4:05",
        "last_listen": "2025-12-06T09:58:44",
      },
      {
        "rank": 3,
        "title": "Chúng Ta Của Hiện Tại",
        "artist": "Sơn Tùng M-TP",
        "albumArtist": "Single - Chúng Ta Của Hiện Tại",
        "albumArt": "https://picsum.photos/seed/album3/200",
        "duration": "5:12",
        "last_listen": "2025-12-05T21:02:10",
      },
      {
        "rank": 4,
        "title": "Hãy Trao Cho Anh",
        "artist": "Sơn Tùng M-TP ft. Snoop Dogg",
        "albumArtist": "m-tp M-TP",
        "albumArt": "https://picsum.photos/seed/album4/200",
        "duration": "4:04",
        "last_listen": "2025-12-04T18:11:55",
      },
      {
        "rank": 5,
        "title": "Muộn Rồi Mà Sao Còn",
        "artist": "Sơn Tùng M-TP",
        "albumArtist": "Single - Muộn Rồi Mà Sao Còn",
        "albumArt": "https://picsum.photos/seed/album5/200",
        "duration": "4:30",
        "last_listen": "2025-12-01T11:33:22",
      },
    ];
    final playlists = List.generate(
      apiResponse.length,
      (i) => PlaylistItem(
        title: apiResponse[i]['name'],
        author: apiResponse[i]['owner'],
        coverUrl: apiResponse[i]['image'],
        songCount: 5 + i,
        duration: '${30 + i} phút',
      ),
    );
    final followedItems = List.generate(
      followed.length,
      (i) => PlaylistItem(
        title: followed[i]['name'],
        author: followed[i]['type'],
        coverUrl: followed[i]['image'],
        imageShape: BoxShape.circle,
        imageFit: BoxFit.fill,
      ),
    );
    track_recent.sort(
      (a, b) => DateTime.parse(
        b['last_listen'],
      ).compareTo(DateTime.parse(a['last_listen'])),
    );
    final recentTracks = List.generate(
      track_recent.length,
      (i) => TrackItem(
        index: i + 1,
        title: track_recent[i]['title'],
        artist: track_recent[i]['artist'],
        albumArtist: track_recent[i]['albumArtist'],
        duration: track_recent[i]['duration'],
        image: track_recent[i]['albumArt'],
      ),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notif) {
          if (notif.metrics.axis == Axis.vertical) {
            scrollOffset.value = notif.metrics.pixels;
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            ProfileSliverAppBar(offset: scrollOffset),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Your Playlists",
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 260,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind
                            .mouse, // quan trọng khi chạy debug / desktop / web
                      },
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: playlists.length,
                      itemBuilder: (context, i) => Container(
                        width: 180,
                        margin: const EdgeInsets.only(right: 16),
                        child: PlaylistCard(item: playlists[i]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Following",
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 280,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind
                            .mouse, // quan trọng khi chạy debug / desktop / web
                      },
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: followedItems.length,
                      itemBuilder: (context, i) => Container(
                        width: 180,
                        margin: const EdgeInsets.only(right: 16),
                        child: PlaylistCard(item: followedItems[i]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Thêm nội dung để có thể scroll dọc
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Recently Played",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => recentTracks[index],
                childCount: recentTracks.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
