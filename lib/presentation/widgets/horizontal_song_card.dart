import 'package:flutter/material.dart';
import '../../domain/entities/song.dart';

class HorizontalSongCard extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;

  const HorizontalSongCard({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140, // Fixed width for the box
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                song.albumArtUrl,
                height: 140,
                width: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 140, width: 140, color: Colors.grey[800], child: const Icon(Icons.music_note, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              song.title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              song.artist,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}