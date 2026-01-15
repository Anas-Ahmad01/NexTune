import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/song_repository.dart';
import '../models/song_model.dart';

class SongRepositoryImpl extends SongRepository{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<List<Song>> getSongs() async{
    try{
      final snapshot = await _firestore.collection('songs').get();

      return snapshot.docs.map((doc) {
        return SongModel.fromMap(doc.data(), doc.id);
      }).toList();
    }
    catch (e) {
      throw Exception("Error fetching songs: $e");
    }
  }

  Future<void> toggleFavorite(String songId, bool isLiked) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userFavoritesRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(songId);

    if (isLiked) {
      await userFavoritesRef.delete();
    } else {

      await userFavoritesRef.set({'addedAt': FieldValue.serverTimestamp()});
    }
  }

  // Get List of Liked Song IDs
  Future<List<String>> getLikedSongIds() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
