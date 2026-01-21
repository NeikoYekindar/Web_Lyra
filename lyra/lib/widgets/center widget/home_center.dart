import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:lyra/l10n/app_localizations.dart';
import '../../services/music_service_v2.dart' hide Artist;
import '../../models/track.dart';
import '../../models/artist.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../shell/app_shell_controller.dart';
import '../../shell/app_nav.dart';
import '../../shell/app_routes.dart';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
// Removed flutter_svg import (unused after cleanup)

class HomeCenter extends StatefulWidget {
  const HomeCenter({super.key});

  @override
  State<HomeCenter> createState() => _HomeCenterState();
}

class _HomeCenterState extends State<HomeCenter> {
  bool _isPlaying = false;
  int _selectedCategoryIndex = 0; // Index của category được chọn
  List<String> _categories = []; // Danh sách categories từ API
  List<Track> _trendingSongs = [];
  List<Artist> _popularArtists = [];
  bool _isLoadingCategories = true;
  bool _isLoadingTrendingSongs = true;
  bool _isLoadingPopularArtists = true;
  List<Map<String, dynamic>> _favoriteItems = []; // Danh sách yêu thích
  bool _isLoadingFavorites = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // Load all data in parallel for better performance
  Future<void> _loadAllData() async {
    await Future.wait([
      _loadCategories(),
      _loadFavoriteItems(),
      _loadTrendingSongs(),
      _loadPopularArtists(),
    ]);
  }

  Future<void> _loadPopularArtists() async {
    try {
      final musicservice = ServiceLocator().musicService;
      final response = await musicservice.getTopArtists(limit: 10);

      if (mounted) {
        setState(() {
          _popularArtists = response;
          _isLoadingPopularArtists = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _popularArtists = [];
          _isLoadingPopularArtists = false;
        });
      }
      print('❌ Error loading popular artists: $e');
    }
  }

  Future<void> _loadTrendingSongs() async {
    try {
      final musicservice = ServiceLocator().musicService;
      final response = await musicservice.getTrendingTracks(limit: 10);
      if (mounted) {
        setState(() {
          _trendingSongs = response;
          _isLoadingTrendingSongs = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _trendingSongs = [];
          _isLoadingTrendingSongs = false;
        });
      }
      print('Error loading trending songs: $e');
    }
  }

  // Gọi API
  Future<void> _loadCategories() async {
    try {
      // final List<String> apiResponse = await CategoryService.getCategories();

      // fake API
      await Future.delayed(const Duration(seconds: 1)); // Giả lập network delay
      final List<String> apiResponse = [
        'All',

        'Playlists',
        'Artists',
        'Albums',
      ];

      if (mounted) {
        setState(() {
          _categories = apiResponse;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _categories = ['All', 'Music', 'Podcasts']; // Fallback data
          _isLoadingCategories = false;
        });
      }
      print('Error loading categories: $e');
    }
  }

  // Gọi API để lấy danh sách yêu thích (tối đa 8 items)
  Future<void> _loadFavoriteItems() async {
    try {
      // Giả lập API call
      await Future.delayed(const Duration(milliseconds: 800));

      final List<Map<String, dynamic>> apiResponse = [
        {
          'id': '1',
          'title': 'Thiền Hạ Nghe Gì',
          'subtitle': 'Daily Mix',
          'image': 'assets/images/thienhanghegi.png',
          'type': 'playlist',
        },
        {
          'id': '2',
          'title': 'B Ray Radio',
          'subtitle': 'Daily',
          'image': 'assets/images/brayradio.png',
          'type': 'radio',
        },
        {
          'id': '3',
          'title': 'HIEUTHUHAI Radio',
          'subtitle': 'HIEUTHUHAI',
          'image': 'assets/images/HTH_radio.png',
          'type': 'radio',
        },
        {
          'id': '4',
          'title': 'Hoàng Dũng',
          'subtitle': 'Artist',
          'image': 'assets/images/hoangdung.png',
          'type': 'artist',
        },
        {
          'id': '5',
          'title': 'Have a sip',
          'subtitle': 'Playlist • 24 songs',
          'image': 'assets/images/haveasip.png',
          'type': 'playlist',
        },
        {
          'id': '6',
          'title': 'Vũ.',
          'subtitle': 'Artist • 2.1M followers',
          'image': 'assets/images/vu.png',
          'type': 'artist',
        },
        {
          'id': '7',
          'title': 'Ballad buồn',
          'subtitle': 'Made for you',
          'image': 'assets/images/balladbuon.png',
          'type': 'playlist',
        },
        {
          'id': '8',
          'title': 'Indie Việt',
          'subtitle': 'Playlist • 156 songs',
          'image': 'assets/images/indieviet.png',
          'type': 'playlist',
        },
      ];

      if (mounted) {
        setState(() {
          _favoriteItems = apiResponse
              .take(8)
              .toList(); // Chỉ lấy tối đa 8 items
          _isLoadingFavorites = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _favoriteItems = [];
          _isLoadingFavorites = false;
        });
      }
      print('Error loading favorite items: $e');
    }
  }

  // Method để xử lý khi user chọn category
  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });

    // Gọi API để lấy nội dung theo category đã chọn
    _loadContentByCategory(_categories[index]);
    print('Selected category: ${_categories[index]}');
  }

  // Method để xử lý khi user tap vào favorite item
  void _onFavoriteItemTapped(Map<String, dynamic> item) {
    print('Tapped favorite item: ${item['title']} (${item['type']})');

    // TODO: Implement navigation based on item type
    switch (item['type']) {
      case 'playlist':
        // Navigate to playlist detail
        break;
      case 'artist':
        // Navigate to artist profile
        break;
      case 'radio':
        // Start playing radio
        break;
      default:
        // Default action
        break;
    }
  }

  // Method để xử lý khi user tap vào trending song
  void _onTrendingSongTapped(Track song) async {
    try {
      final musicPlayerProvider = Provider.of<MusicPlayerProvider>(
        context,
        listen: false,
      );
      final shellController = Provider.of<AppShellController>(
        context,
        listen: false,
      );

      // Load the track into player with full trending songs as queue
      await musicPlayerProvider.setTrack(song, queue: _trendingSongs);

      // Always play the new track
      musicPlayerProvider.play();

      // Show player maximized view if not already shown
      if (!shellController.isPlayerMaximized) {
        shellController.toggleMaximizePlayer();
      }

      print('Playing: ${song.trackName} by ${song.artist}');
      print('Queue size: ${_trendingSongs.length}');
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  void _onPopularArtistTapped(Artist artist) {
    print('Tapped popular artist: ${artist.nickname}');

    // Use SchedulerBinding to navigate after current frame to avoid GlobalKey conflicts
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppNav.key.currentState?.pushNamed(AppRoutes.artist, arguments: artist);
      }
    });
  }

  // Gọi API để lấy nội dung theo category
  Future<void> _loadContentByCategory(String category) async {
    try {
      // OPTION 1:
      // final content = await CategoryService.getContentByCategory(category);

      // OPTION 2: Giả lập API call
      await Future.delayed(const Duration(milliseconds: 500));
      print('Loading content for category: $category');

      // TODO: Update UI với dữ liệu mới từ API
      // Ví dụ: setState(() { _contentList = content; });
    } catch (e) {
      print('Error loading content for category $category: $e');
    }
  }

  // Removed unused _selectedTrendingSongIndex and _buildCustomIcon to clean up warnings.

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // AppTheme.redPrimaryDark,
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface,
          ],
          stops: const [0.0, 0.55],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                // Adjust layout based on available width
                final isNarrow = constraints.maxWidth < 600;
                final isMedium = constraints.maxWidth < 900;

                return Container(
                  width: double.infinity,
                  height: isNarrow ? 180 : 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Side - Image
                      if (!isNarrow)
                        Container(
                          width: isNarrow ? 120 : (isMedium ? 150 : 200),
                          height: isNarrow ? 120 : (isMedium ? 150 : 200),
                          margin: EdgeInsets.all(isNarrow ? 12 : 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Image(
                            image: AssetImage('assets/images/HTH.png'),
                            fit: BoxFit.cover,
                          ),
                        ),

                      // Right Side - Text Info
                      Expanded(
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(isNarrow ? 12 : 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: isNarrow ? 10 : 30),
                                  Text(
                                    'Album',
                                    style: TextStyle(
                                      color: const Color(0xFFFFFFFF),
                                      fontSize: isNarrow
                                          ? 14
                                          : (isMedium ? 16 : 20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: isNarrow ? 8 : 20),
                                  Text(
                                    'Ai Cũng Phải Bắt Đầu Từ Đâu Đó',
                                    style: TextStyle(
                                      color: const Color(0xFFFFFFFF),
                                      fontSize: isNarrow
                                          ? 16
                                          : (isMedium ? 20 : 30),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.only(
                                      bottom: isNarrow ? 5 : 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (!isNarrow)
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                            child: const Image(
                                              image: AssetImage(
                                                'assets/images/HTH_icon.png',
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        if (!isNarrow)
                                          const SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            isNarrow
                                                ? 'HIEUTHUHAI • 2023'
                                                : (isMedium
                                                      ? 'HIEUTHUHAI • 2023 • 13 songs'
                                                      : 'HIEUTHUHAI • 2023 • 13 songs, 39 min 44 sec '),
                                            style: TextStyle(
                                              color: const Color(0xFFB0B0B0),
                                              fontSize: isNarrow
                                                  ? 11
                                                  : (isMedium ? 13 : 16),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _isPlaying = !_isPlaying;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            foregroundColor: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                            minimumSize: Size(
                                              isNarrow ? 60 : 95,
                                              isNarrow ? 36 : 50,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            _isPlaying
                                                ? (AppLocalizations.of(
                                                        context,
                                                      )?.pause ??
                                                      'Pause')
                                                : (AppLocalizations.of(
                                                        context,
                                                      )?.play ??
                                                      'Play'),
                                            style: TextStyle(
                                              fontSize: isNarrow ? 12 : 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Close button positioned at top right
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.close,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isNarrow) const SizedBox(width: 16),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.transparent),
              child: _isLoadingCategories
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.redPrimary,
                        strokeWidth: 2,
                      ),
                    )
                  : SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final isSelected = index == _selectedCategoryIndex;
                          return ElevatedButton(
                            onPressed: () => _onCategorySelected(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,

                              foregroundColor: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              minimumSize: Size(
                                _categories[index].length * 10.0 +
                                    20, // Dynamic width based on text length
                                40,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _categories[index],
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Favorite items grid - responsive based on available width
            _isLoadingFavorites
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.redPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate column count based on available width
                      int crossAxisCount;
                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 4; // Wide screen: 4 columns
                      } else if (constraints.maxWidth > 800) {
                        crossAxisCount = 3; // Medium: 3 columns
                      } else if (constraints.maxWidth > 500) {
                        crossAxisCount = 2; // Narrow: 2 columns
                      } else {
                        crossAxisCount = 1; // Very narrow: 1 column
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 6,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _favoriteItems.length > 8
                            ? 8
                            : _favoriteItems.length,
                        itemBuilder: (context, index) {
                          final item = _favoriteItems[index];
                          return _FavoriteItemCard(
                            item: item,
                            onTap: () => _onFavoriteItemTapped(item),
                          );
                        },
                      );
                    },
                  ),
            const SizedBox(height: 16),

            Text(
              AppLocalizations.of(context)?.trendingSongs ?? 'Trending Songs',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _isLoadingTrendingSongs
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.redPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : SizedBox(
                    height: 300,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child: ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _trendingSongs.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 20),
                        itemBuilder: (context, index) {
                          final song = _trendingSongs[index];
                          return _TrendingSongCard(
                            song: song,
                            onTap: () => _onTrendingSongTapped(song),
                          );
                        },
                      ),
                    ),
                  ),
            const SizedBox(height: 16),

            Text(
              'Popular artists',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _isLoadingPopularArtists
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.redPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : SizedBox(
                    height: 300,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child: ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _popularArtists.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 20),
                        itemBuilder: (context, index) {
                          final artist = _popularArtists[index];
                          return _PopularArtistCard(
                            artist: artist,
                            onTap: () => _onPopularArtistTapped(artist),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// Widget riêng để xử lý hover effect cho favorite items
class _FavoriteItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const _FavoriteItemCard({required this.item, required this.onTap});

  @override
  State<_FavoriteItemCard> createState() => _FavoriteItemCardState();
}

class _FavoriteItemCardState extends State<_FavoriteItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered
                ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7)
                : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.4 : 0.2),
                blurRadius: _isHovered ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Image container - tràn ra viền
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: Colors.grey[800],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: widget.item['image'] != null
                      ? Image.asset(
                          widget.item['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[700],
                              child: const Icon(
                                Icons.music_note,
                                color: Colors.white54,
                                size: 20,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[700],
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.white54,
                            size: 20,
                          ),
                        ),
                ),
              ),

              // Text container - bên phải của hình
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.item['title'] ?? '',
                        style: TextStyle(
                          color: _isHovered
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.95),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.item['subtitle'] ?? '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isHovered)
                Container(
                  width: 42,
                  height: 42,

                  decoration: BoxDecoration(
                    color: const Color(0xFFE62429),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 28,
                  ),
                ),

              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopularArtistCard extends StatefulWidget {
  final Artist artist;
  final VoidCallback onTap;

  const _PopularArtistCard({required this.artist, required this.onTap});

  @override
  State<_PopularArtistCard> createState() => _PopularArtistCardState();
}

class _PopularArtistCardState extends State<_PopularArtistCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.transparent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 200,
            padding: EdgeInsets.all(_isHovered ? 8 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child:
                          widget.artist.imageUrl != null &&
                              widget.artist.imageUrl!.startsWith('http')
                          ? Image.network(
                              widget.artist.imageUrl!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white54,
                                      size: 80,
                                    ),
                                  ),
                            )
                          : Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white54,
                                size: 80,
                              ),
                            ),
                    ),

                    if (_isHovered)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE62429),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.artist.nickname,
                  style: TextStyle(
                    color: _isHovered
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.95),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Artist',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget riêng để xử lý hover effect cho trending songs
class _TrendingSongCard extends StatefulWidget {
  final Track song;
  final VoidCallback onTap;

  const _TrendingSongCard({required this.song, required this.onTap});

  @override
  State<_TrendingSongCard> createState() => _TrendingSongCardState();
}

class _TrendingSongCardState extends State<_TrendingSongCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isHovered ? 216 : 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.transparent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildTrackImage(widget.song.trackImageUrl),
                  ),
                  if (_isHovered)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE62429),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          // Use theme color; can't be const because it depends on context
                          color: Theme.of(context).colorScheme.surface,
                          size: 28,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.song.trackName,
                style: TextStyle(
                  color: _isHovered
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.95),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget
                    .song
                    .artist, // Uses artist getter (nickname if available, else artistId)
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                _formatDuration(widget.song.duration),
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildTrackImage(String imageUrl) {
    // If empty or null, use default image immediately
    if (imageUrl.isEmpty) {
      return _buildDefaultImage();
    }

    // If it's a valid HTTP URL, try loading from network
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildDefaultImage(),
      );
    }

    // If it's a relative path, try loading from assets
    final assetPath = imageUrl.startsWith('assets/')
        ? imageUrl
        : 'assets/$imageUrl';

    return Image.asset(
      assetPath,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildDefaultImage(),
    );
  }

  Widget _buildDefaultImage() {
    return Image.asset(
      'assets/images/HTH.png',
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 200,
        height: 200,
        color: Colors.grey[800],
        child: const Icon(Icons.music_note, color: Colors.white54, size: 48),
      ),
    );
  }
}
