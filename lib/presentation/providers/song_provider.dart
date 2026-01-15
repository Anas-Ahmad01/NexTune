import 'package:flutter/material.dart';
import '../../domain/entities/song.dart';
import '../../data/repositories/song_repository_impl.dart';

class SongProvider extends ChangeNotifier {
  final SongRepositoryImpl _songRepository = SongRepositoryImpl();

  // 1. MASTER LIST (All data)
  List<Song> _allSongs = [];

  // 2. CATEGORY LISTS (To be randomized)
  List<Song> _popularSongs = [];
  List<Song> _newReleases = [];
  List<Song> _recentlyPlayed = [];
  List<Song> _searchResults = [];

  Set<String> _likedSongIds = {};

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Song> get songs => _searchResults;
  List<Song> get mostPopularSongs => _popularSongs;
  List<Song> get newReleases => _newReleases;
  List<Song> get recentlyPlayed => _recentlyPlayed;
  List<Song> get likedSongs => _allSongs.where((song) => _likedSongIds.contains(song.id)).toList();

  // FETCH & RANDOMIZE
  Future<void> fetchSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allSongs = await _songRepository.getSongs();
      _searchResults = _allSongs;

      // RANDOMIZATION LOGIC:
      if (_allSongs.isNotEmpty) {
        // Create a temporary copy and shuffle it
        var randomList = List<Song>.from(_allSongs)..shuffle();

        // Take top 5 for "Popular"
        _popularSongs = randomList.take(5).toList();

        // Shuffle again for "New Releases"
        randomList.shuffle();
        _newReleases = randomList.take(5).toList();
      }

      // 4. Fetch user's likes
      final likedIds = await _songRepository.getLikedSongIds();
      _likedSongIds = likedIds.toSet();

    } catch (e) {
      debugPrint("error : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // SEARCH LOGIC
  void search(String query) {
    if (query.isEmpty) {
      _searchResults = _allSongs;
    } else {
      _searchResults = _allSongs.where((song) {
        return song.title.toLowerCase().contains(query.toLowerCase()) ||
            song.artist.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  // FAVORITES LOGIC
  bool isLiked(String songId) {
    return _likedSongIds.contains(songId);
  }

  Future<void> toggleLike(String songId) async {
    final isCurrentlyLiked = _likedSongIds.contains(songId);

    if (isCurrentlyLiked) {
      _likedSongIds.remove(songId);
    } else {
      _likedSongIds.add(songId);
    }
    notifyListeners();

    try {
      await _songRepository.toggleFavorite(songId, isCurrentlyLiked);
    } catch (e) {
      if (isCurrentlyLiked) {
        _likedSongIds.add(songId);
      } else {
        _likedSongIds.remove(songId);
      }
      notifyListeners();
    }
  }


  void addToRecentlyPlayed(Song song) {

    _recentlyPlayed.removeWhere((s) => s.id == song.id);

    _recentlyPlayed.insert(0, song);

    if (_recentlyPlayed.length > 10) {
      _recentlyPlayed.removeLast();
    }
    notifyListeners();
  }
}