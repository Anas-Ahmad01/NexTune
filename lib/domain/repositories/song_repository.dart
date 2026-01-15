import '../entities/song.dart';

abstract class SongRepository {
  Future<List<Song>> getSongs();

  Future<void> toggleFavorite(String songId, bool isLiked);
  Future<List<String>> getLikedSongIds();
}