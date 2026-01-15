import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../providers/player_provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/song_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.keyboard_arrow_down, color:Colors.white,size: 30,),
        ),
        title: const Text("Now Playing", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: -5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    song?.albumArtUrl ?? "https://via.placeholder.com/300",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[900], child: const Icon(Icons.music_note, size: 50, color: Colors.white)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Text(
              song?.title ?? "No Song Playing",
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              song?.artist ?? "Unknown Artist",
              style: const TextStyle(color: Colors.grey, fontSize: 18),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 30),

            // Like and Share
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    context.watch<SongProvider>().isLiked(song?.id ?? "")
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: context.watch<SongProvider>().isLiked(song?.id ?? "")
                        ? AppTheme.primary
                        : Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    if (song != null) {
                      context.read<SongProvider>().toggleLike(song.id);
                    }
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white, size: 25),
                  onPressed: () {},
                ),
              ],
            ),

            // Progress Bar
            ProgressBar(
              progress: player.position,
              total: player.duration,
              onSeek: (duration) {
                player.seek(duration);
              },
              baseBarColor: Colors.white24,
              progressBarColor: AppTheme.primary,
              thumbColor: Colors.white,
              thumbRadius: 8,
              timeLabelTextStyle: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),

            // CONTROLS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SHUFFLE
                IconButton(
                  icon: Icon(Icons.shuffle,
                      color: player.isShuffle ? AppTheme.primary : Colors.white,
                      size: 20
                  ),
                  onPressed: () => player.toggleShuffle(),
                ),

                // PREVIOUS ⏪
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
                  onPressed: player.hasPrevious ? () => player.skipPrevious() : null,
                ),

                // PLAY/PAUSE
                IconButton(
                  iconSize: 70,
                  icon: Icon(
                    player.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: Colors.white,
                  ),
                  onPressed: () => player.togglePlayPause(),
                ),

                // NEXT ⏩
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
                  onPressed: player.hasNext ? () => player.skipNext() : null,
                ),

                // LOOP
                IconButton(
                  icon: Icon(
                      player.loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
                      color: player.loopMode != LoopMode.off ? AppTheme.primary : Colors.white,
                      size: 20
                  ),
                  onPressed: () => player.toggleLoop(),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}