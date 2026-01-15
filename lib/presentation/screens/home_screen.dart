import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/song_provider.dart';
import '../providers/player_provider.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/horizontal_song_card.dart';
import '../../domain/entities/song.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _selectedFilter = "All";

  final List<String> _filters = ["All", "Music", "Podcasts", "Live Events"];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SongProvider>().fetchSongs());
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = context.watch<SongProvider>();
    final allSongs = songProvider.songs;
    final recentlyPlayed = songProvider.recentlyPlayed;
    final mostPopular = songProvider.mostPopularSongs;
    final newReleases = songProvider.newReleases;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

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

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      return _buildChip(
                          filter,
                          _selectedFilter == filter, // Check if this one is selected
                              () {
                            // Update state on tap
                            setState(() {
                              _selectedFilter = filter;
                            });
                          }
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 30),

                if (recentlyPlayed.isNotEmpty) ...[
                  const SectionTitle(title: "Recently Played"),
                  const SizedBox(height: 16),
                  _buildHorizontalList(context, recentlyPlayed),
                  const SizedBox(height: 30),
                ],

                // SECTION: MOST POPULAR
                const SectionTitle(title: "Most Popular"),
                const SizedBox(height: 16),
                _buildHorizontalList(context, mostPopular),

                const SizedBox(height: 30),

                // SECTION: NEW RELEASES
                const SectionTitle(title: "New Releases"),
                const SizedBox(height: 16),
                _buildHorizontalList(context, newReleases),

                const SizedBox(height: 30),

                // SECTION: ALL SONGS (Supermix)
                const SectionTitle(title: "Your Supermix"),
                const SizedBox(height: 10),
                _buildVerticalList(context, allSongs),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // 3. UPDATED CHIP BUILDER: Now accepts an onTap callback
  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1DB954) : Colors.white12, // Green if selected
          borderRadius: BorderRadius.circular(30),
          border: isSelected ? null : Border.all(color: Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

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

              context.read<PlayerProvider>().playSong(song, songs);
              context.push('/player');
            },
          );
        },
      ),
    );
  }

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