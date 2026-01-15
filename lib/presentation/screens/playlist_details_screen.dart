import 'package:flutter/material.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  final String playlistId; // We need to know WHICH playlist to show

  const PlaylistDetailsScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // We use CustomScrollView for that cool "Image fades as you scroll" effect
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: Colors.black,
            pinned: true, // App bar stays visible when scrolling
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Album Name"),
              background: Container(color: Colors.grey[800]), // Placeholder for Album Art
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return ListTile(
                  leading: Text("${index + 1}", style: const TextStyle(color: Colors.grey)),
                  title: Text("Song Name $index", style: const TextStyle(color: Colors.white)),
                  subtitle: const Text("Artist Name", style: TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.more_vert, color: Colors.grey),
                  onTap: () {
                    // This will eventually open the Player
                  },
                );
              },
              childCount: 10, // Just 10 fake songs for now
            ),
          ),
        ],
      ),
    );
  }
}