import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/song_provider.dart';
import '../providers/player_provider.dart';
import '../../core/theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final songProvider = context.watch<SongProvider>();
    final songs = songProvider.songs;

    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Search",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (value) {
                      context.read<SongProvider>().search(value);
                    },
                    decoration: InputDecoration(
                      hintText: "What do you want to listen to?",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                      child: songs.isEmpty
                          ? const Center(
                        child: Text("No songs found", style: TextStyle(color: Colors.grey)),
                      )
                          : ListView.builder(
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    song.albumArtUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[800],
                                        child: const Icon(
                                          Icons.music_note,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                title: Text(song.title, style: const TextStyle(color: Colors.white)),
                                subtitle: Text(song.artist, style: const TextStyle(color: Colors.grey)),
                                onTap: () {
                                  context.read<PlayerProvider>().playSong(song, songs);
                                  context.push('/player');
                                });
                          })),
                ],
              ))),
    );
  }
}