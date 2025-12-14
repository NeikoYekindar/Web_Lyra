import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../providers/music_player_provider.dart';
import '../../models/track.dart';

// =======================================================
// MODEL
// =======================================================

class LyricLine {
  final String text;
  final Duration timestamp;
  LyricLine(this.text, this.timestamp);
}

// =======================================================
// SCROLL BEHAVIOR
// =======================================================

class _NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

// =======================================================
// LYRIC WIDGET
// =======================================================

class LyricWidget extends StatefulWidget {
  const LyricWidget({super.key});

  @override
  State<LyricWidget> createState() => _LyricWidgetState();
}

class _LyricWidgetState extends State<LyricWidget> {
  final GlobalKey<_LyricViewState> _lyricKey = GlobalKey();

  List<LyricLine> _lyrics = [];
  Track? _lastTrack;

  bool _loading = true;
  String? _error;
  int _currentIndex = 0;

  StreamSubscription<int>? _posSub;

  // ===================================================
  // INIT
  // ===================================================

  @override
  void initState() {
    super.initState();

    final player = context.read<MusicPlayerProvider>();

    _posSub = player.positionMsStream.listen(_onPosition);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLyricsForCurrentTrack();
    });
  }

  @override
  void dispose() {
    _posSub?.cancel();
    super.dispose();
  }

  // ===================================================
  // POSITION HANDLER
  // ===================================================

  void _onPosition(int positionMs) {
    final player = context.read<MusicPlayerProvider>();
    final track = player.currentTrack;
    if (track == null) return;

    if (_lastTrack?.id != track.id) {
      _loadLyricsForCurrentTrack();
      return;
    }

    _syncLyric(positionMs);
  }

  // ===================================================
  // LOAD LYRIC
  // ===================================================

  Future<void> _loadLyricsForCurrentTrack() async {
    final player = context.read<MusicPlayerProvider>();
    final track = player.currentTrack;

    if (track == null || track.lyricUrl.isEmpty) return;
    if (_lastTrack?.id == track.id) return;

    _lastTrack = track;
    _currentIndex = 0;

    setState(() {
      _lyrics.clear();
      _loading = true;
      _error = null;
    });

    try {
      final res = await http.get(Uri.parse(track.lyricUrl));
      if (res.statusCode != 200) {
        throw Exception("Không tải được lyric");
      }

      final raw = utf8.decode(res.bodyBytes);
      final parsed = _parse(raw);

      if (!mounted) return;

      setState(() {
        _lyrics = parsed;
        _loading = false;
      });

      _lyricKey.currentState?.scrollTo(0, animate: false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // ===================================================
  // PARSE LRC
  // ===================================================

  List<LyricLine> _parse(String raw) {
    final out = <LyricLine>[];
    final lines = raw.split('\n');
    final reg = RegExp(r'\[(\d{2}):(\d{2}\.\d+)\]');

    for (final line in lines) {
      final matches = reg.allMatches(line);
      if (matches.isEmpty) continue;

      final text = line.substring(matches.last.end).trim();

      for (final m in matches) {
        final min = int.parse(m.group(1)!);
        final sec = double.parse(m.group(2)!);
        final ms = (min * 60000 + sec * 1000).round();
        out.add(LyricLine(text, Duration(milliseconds: ms)));
      }
    }

    out.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return out;
  }

  // ===================================================
  // SYNC
  // ===================================================

  void _syncLyric(int positionMs) {
    if (_lyrics.isEmpty) return;

    final pos = Duration(milliseconds: positionMs);
    int idx = 0;

    for (int i = 0; i < _lyrics.length - 1; i++) {
      if (pos >= _lyrics[i].timestamp && pos < _lyrics[i + 1].timestamp) {
        idx = i;
        break;
      }
    }

    if (idx != _currentIndex) {
      _currentIndex = idx;
      _lyricKey.currentState?.updateIndex(idx);
      _lyricKey.currentState?.scrollTo(idx);
    }
  }

  // ===================================================
  // BUILD
  // ===================================================

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    return LyricView(
      key: _lyricKey,
      lyrics: _lyrics,
      currentIndex: _currentIndex,
    );
  }
}

// =======================================================
// LYRIC VIEW (UI)
// =======================================================

class LyricView extends StatefulWidget {
  final List<LyricLine> lyrics;
  final int currentIndex;

  const LyricView({
    super.key,
    required this.lyrics,
    required this.currentIndex,
  });

  @override
  State<LyricView> createState() => _LyricViewState();
}

class _LyricViewState extends State<LyricView> {
  final ScrollController _scroll = ScrollController();
  late final List<GlobalKey> _itemKeys;

  int _current = 0;
  int _hover = -1;

  @override
  void initState() {
    super.initState();
    _current = widget.currentIndex;
    _itemKeys = List.generate(widget.lyrics.length, (_) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollTo(_current, animate: false);
    });
  }

  void updateIndex(int i) {
    if (i == _current) return;
    setState(() => _current = i);
  }

  void scrollTo(int idx, {bool animate = true}) {
    if (idx < 0 || idx >= _itemKeys.length) return;
    final ctx = _itemKeys[idx].currentContext;
    if (ctx == null) return;

    final itemBox = ctx.findRenderObject() as RenderBox;
    final listBox = context.findRenderObject() as RenderBox;

    final itemCenter =
        itemBox.localToGlobal(Offset.zero).dy + itemBox.size.height / 2;
    final listCenter = listBox.size.height / 2;

    final target = _scroll.offset + (itemCenter - listCenter);

    if (animate) {
      _scroll.animateTo(
        target.clamp(0, _scroll.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scroll.jumpTo(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: ScrollConfiguration(
          behavior: _NoScrollbarBehavior(),
          child: ListView.builder(
            controller: _scroll,
            itemCount: widget.lyrics.length,
            itemBuilder: (context, index) {
              final isCurrent = index == _current;
              final isHover = index == _hover;

              final dist = (index - _current).abs();
              double opacity = 1.0 - dist * 0.18;
              if (opacity < 0.25) opacity = 0.25;

              final baseColor = isCurrent
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant;

              final hoverColor = Theme.of(context).colorScheme.onSurface;

              return MouseRegion(
                key: _itemKeys[index],
                onEnter: (_) => setState(() => _hover = index),
                onExit: (_) => setState(() => _hover = -1),
                cursor: SystemMouseCursors.click,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  style: GoogleFonts.inter(
                    fontSize: isCurrent ? 36 : 34,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: (isHover && !isCurrent ? hoverColor : baseColor)
                        .withOpacity(opacity),
                    decoration: isHover && !isCurrent
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationThickness: 1.6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    child: Text(
                      widget.lyrics[index].text,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
