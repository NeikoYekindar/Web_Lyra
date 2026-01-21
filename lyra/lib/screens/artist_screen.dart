import 'package:flutter/material.dart';
import 'package:lyra/widgets/center widget/artist_page.dart';
import 'package:lyra/models/artist.dart';

class ArtistScreen extends StatelessWidget {
  final Artist artist;
  const ArtistScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: ArtistPage(artist: artist),
      ),
    );
  }
}
