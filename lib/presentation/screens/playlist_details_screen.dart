
import 'package:flutter/material.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailsScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: Colors.black,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Album Name"),
              background: Container(color: Colors.grey[800]),
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

                  },
                );
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

