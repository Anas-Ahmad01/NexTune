import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // --- HELPER: Upload Songs from JSON ---
  Future<void> _uploadSongsFromJSON(BuildContext context) async {
    try {
      final String response = await rootBundle.loadString('assets/songs.json');
      final List<dynamic> data = json.decode(response);
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();

      for (var item in data) {
        final docRef = firestore.collection('songs').doc();
        batch.set(docRef, {
          'title': item['title'],
          'artist': item['artist'],
          'albumArtUrl': item['albumArtUrl'],
          'audioUrl': item['audioUrl'],
        });
      }
      await batch.commit();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Songs Uploaded!")));
      }
    } catch (e) {
      debugPrint("Upload Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    final initial = user?.email != null && user!.email!.isNotEmpty
        ? user.email![0].toUpperCase()
        : "U";

    String displayName = "Guest";
    if (user?.email != null && user!.email!.isNotEmpty) {
      displayName = user!.email!.split('@')[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // BIG AVATAR
            CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primary,
              child: Text(
                initial,
                style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
            ),

            const SizedBox(height: 20),

            // USER NAME
            Text(
              displayName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),

            // 1. CHANGED: "Free Account" to "Premium Member" ✨
            const Text(
              "Premium Member",
              style: TextStyle(fontSize: 14, color: AppTheme.primary, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 40),

            // MENU OPTIONS (Now with interaction!)
            _buildProfileOption(context, Icons.person, "Edit Profile"),
            _buildProfileOption(context, Icons.notifications, "Notifications"),
            _buildProfileOption(context, Icons.lock, "Privacy & Security"),
            _buildProfileOption(context, Icons.headset_mic, "Help & Support"),

            // OPTIONAL: Button to Upload Songs (Hidden for normal users usually)
            // _buildProfileOption(context, Icons.cloud_upload, "Upload Database (Dev)", onTap: () => _uploadSongsFromJSON(context)),

            const SizedBox(height: 40),

            // LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthProvider>().logout();
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("LOG OUT"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Version 1.0.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 2. UPDATED Widget to handle taps
  Widget _buildProfileOption(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap ?? () {
        // Default Action: Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$title feature coming soon!"),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating, // Floats above bottom nav
            backgroundColor: Colors.white70,
          ),
        );
      },
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