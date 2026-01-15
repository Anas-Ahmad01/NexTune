import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/song_provider.dart';
import '../providers/player_provider.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/horizontal_song_card.dart';
import '../../domain/entities/song.dart'; // Ensure Song is imported

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SongProvider>().fetchSongs());
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get Data from the updated Provider
    final songProvider = context.watch<SongProvider>();

    final allSongs = songProvider.songs;
    final recentlyPlayed = songProvider.recentlyPlayed;
    final mostPopular = songProvider.mostPopularSongs;
    final newReleases = songProvider.newReleases;
    // REMOVED: Duplicate definition of allSongs

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("NexTune", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1DB954))),
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.history), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                // 3. FILTER CHIPS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip("All", true),
                      _buildChip("Music", false),
                      _buildChip("Podcasts", false),
                      _buildChip("Live Events", false),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 4. SECTION: RECENTLY PLAYED
                if (recentlyPlayed.isNotEmpty) ...[
                  const SectionTitle(title: "Recently Played"),
                  const SizedBox(height: 16),
                  _buildHorizontalList(context, recentlyPlayed), // Pass list
                  const SizedBox(height: 30),
                ],

                // 5. SECTION: MOST POPULAR
                const SectionTitle(title: "Most Popular"),
                const SizedBox(height: 16),
                _buildHorizontalList(context, mostPopular), // Pass list

                const SizedBox(height: 30),

                // 6. SECTION: NEW RELEASES
                const SectionTitle(title: "New Releases"),
                const SizedBox(height: 16),
                _buildHorizontalList(context, newReleases), // Pass list

                const SizedBox(height: 30),

                // 7. SECTION: ALL SONGS (Vertical List)
                const SectionTitle(title: "Your Supermix"),
                const SizedBox(height: 10),
                _buildVerticalList(context, allSongs), // Pass list

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER METHODS ---

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1DB954) : Colors.white12,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // FIXED: Renamed 'List songs' to 'List<Song> songs' for type safety
  Widget _buildHorizontalList(BuildContext context, List<Song> songs) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return HorizontalSongCard(
            song: song,
            onTap: () {
              context.read<SongProvider>().addToRecentlyPlayed(song);
              // FIX: Use 'songs' (the local list) as the queue, not 'allSongs'
              context.read<PlayerProvider>().playSong(song, songs);
              context.push('/player');
            },
          );
        },
      ),
    );
  }

  // FIXED: Renamed 'List songs' to 'List<Song> songs'
  Widget _buildVerticalList(BuildContext context, List<Song> songs) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              song.albumArtUrl, width: 50, height: 50, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey, width: 50, height: 50),
            ),
          ),
          title: Text(song.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(song.artist, style: const TextStyle(color: Colors.grey)),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
          onTap: () {
            context.read<SongProvider>().addToRecentlyPlayed(song);
            // FIX: Added the missing second argument (the queue)
            context.read<PlayerProvider>().playSong(song, songs);
            context.push('/player');
          },
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
    );
  }
}