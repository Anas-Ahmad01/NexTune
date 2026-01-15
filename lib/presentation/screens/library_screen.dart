import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/song_provider.dart';
import '../providers/player_provider.dart';
import '../../core/theme/app_theme.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final likedSongs = context.watch<SongProvider>().likedSongs;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Your Library"),
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1DB954), // Spotify Green top
                      Colors.black,      // Black bottom
                    ],
                  ),
                ),
              ),
            ),
          ),

          // B. The Content
          if (likedSongs.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 20),
                    Text("No liked songs yet.", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),
                    Text("Go play some music! 🎵", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final song = likedSongs[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(song.albumArtUrl, width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(song.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(song.artist, style: const TextStyle(color: Colors.grey)),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: AppTheme.primary), // Always Green here
                      onPressed: () {
                        context.read<SongProvider>().toggleLike(song.id);
                      },
                    ),
                    onTap: () {
                      // ✅ FIX: Pass 'likedSongs' as the queue!
                      context.read<PlayerProvider>().playSong(song, likedSongs);
                      context.push('/player');
                    },
                  );
                },
                childCount: likedSongs.length,
              ),
            ),
        ],
      ),
    );
  }
}