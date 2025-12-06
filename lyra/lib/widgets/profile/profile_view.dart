import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/widgets/common/header_info_section.dart';

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
            color: const Color(0xFF111111),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile View",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                // --- Header info ---
                SizedBox(
                  height: 70, // Đảm bảo Stack có chiều cao xác định
                  child: HeaderInfoSection(
                    background: LinearGradient(
                      colors: [Colors.transparent, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    horizontalPadding: 10,
                    imageSize: 64,
                    imageShape: BoxShape.circle,
                    image: Image.asset('assets/images/avatar.png'),
                    title: Text(
                      "Trùm UIT",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          "18 Public Playlists",
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          "  •  ",
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          "36 Following",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    bio: Text(
                      "kakakakakaka",
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Favorite",
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 30,
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
                          child: FavoriteCard(item: types[i]),
                        );
                      },
                    ),
                  ),
                ),
                Divider(color: Colors.white24, thickness: 1, height: 30),
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
                            color: const Color(0xFF1F1F1F),
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
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  apiResponse[i]['type'],
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  "  •  ",
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  apiResponse[i]['owner'],
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
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

class FavoriteCard extends StatelessWidget {
  final String item;

  const FavoriteCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 63,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            item,
            style: GoogleFonts.inter(
              color: const Color(0xFF111111),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
