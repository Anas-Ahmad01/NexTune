import 'dart:convert'; // Needed to read JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed to load the file
import 'package:cloud_firestore/cloud_firestore.dart'; // Needed for Firebase
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;

  // --- 🛠️ THE MAGIC UPLOAD FUNCTION ---
  Future<void> uploadSongsToFirebase() async {
    setState(() => _isUploading = true);

    try {
      // 1. Load the JSON file
      final String response = await rootBundle.loadString('assets/songs.json');
      final List<dynamic> data = jsonDecode(response);

      // 2. Get Firestore Reference
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch(); // We use a batch for faster uploading

      // 3. Loop through every song in the JSON
      for (var songData in data) {
        // Create a new document reference
        var docRef = firestore.collection('songs').doc();

        // Add the song to the batch
        batch.set(docRef, {
          "title": songData['title'],
          "artist": songData['artist'],
          "audioUrl": songData['audioUrl'],
          "albumArtUrl": songData['albumArtUrl'],
          "isFavorite": false, // Default value
        });
      }

      // 4. Commit (Send all 50 songs at once)
      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Success! All songs uploaded!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // User Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // User Email
            Text(
              user?.email ?? "Guest",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 40),

            // --- ADMIN AREA ---
            const Divider(color: Colors.grey),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Admin Zone", style: TextStyle(color: Colors.grey)),
            ),

            if (_isUploading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                onPressed: uploadSongsToFirebase,
                icon: const Icon(Icons.cloud_upload),
                label: const Text("Upload Songs from JSON"),
              ),

            const SizedBox(height: 20),

            // --- LOGOUT BUTTON ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<AuthProvider>().logout();
                context.go('/login');
              },
              child: const Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}


/*
import 'dart:convert'; // Needed to read JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed to load the file
import 'package:cloud_firestore/cloud_firestore.dart'; // Needed for Firebase
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;

  // --- 🛠️ THE MAGIC UPLOAD FUNCTION ---
  Future<void> uploadSongsToFirebase() async {
    setState(() => _isUploading = true);

    try {
      // 1. Load the JSON file
      final String response = await rootBundle.loadString('assets/songs.json');
      final List<dynamic> data = jsonDecode(response);

      // 2. Get Firestore Reference
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch(); // We use a batch for faster uploading

      // 3. Loop through every song in the JSON
      for (var songData in data) {
        // Create a new document reference
        var docRef = firestore.collection('songs').doc();

        // Add the song to the batch
        batch.set(docRef, {
          "title": songData['title'],
          "artist": songData['artist'],
          "audioUrl": songData['audioUrl'],
          "albumArtUrl": songData['albumArtUrl'],
          "isFavorite": false, // Default value
        });
      }

      // 4. Commit (Send all 50 songs at once)
      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Success! All songs uploaded!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // User Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // User Email
            Text(
              user?.email ?? "Guest",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 40),

            // --- ADMIN AREA ---
            const Divider(color: Colors.grey),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Admin Zone", style: TextStyle(color: Colors.grey)),
            ),

            if (_isUploading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                onPressed: uploadSongsToFirebase,
                icon: const Icon(Icons.cloud_upload),
                label: const Text("Upload Songs from JSON"),
              ),

            const SizedBox(height: 20),

            // --- LOGOUT BUTTON ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<AuthProvider>().logout();
                context.go('/login');
              },
              child: const Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}

 */