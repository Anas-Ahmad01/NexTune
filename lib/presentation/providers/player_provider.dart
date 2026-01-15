import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../domain/entities/song.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool _isShuffle = false;
  LoopMode _loopMode = LoopMode.off;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<Song> _playlist = [];
  int _currentIndex = -1;
  Song? _currentSong;

  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  LoopMode get loopMode => _loopMode;
  Duration get duration => _duration;
  Duration get position => _position;
  Song? get currentSong => _currentSong;

  bool get hasNext => _playlist.isNotEmpty && (_isShuffle || _currentIndex < _playlist.length - 1 || _loopMode == LoopMode.all);
  bool get hasPrevious => _playlist.isNotEmpty && (_isShuffle || _currentIndex > 0 || _loopMode == LoopMode.all);

  PlayerProvider() {
    _listenToPlayerState();
  }

  void _listenToPlayerState() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final processingState = playerState.processingState;

      // Auto-play next song when finished
      if (processingState == ProcessingState.completed) {
        _isPlaying = false;
        _position = Duration.zero;
        _audioPlayer.pause();
        _audioPlayer.seek(Duration.zero);

        // AUTO SKIP Logic
        if (_loopMode == LoopMode.one) {
          playSong(_currentSong!, _playlist); // Replay same
        } else {
          skipNext(); // Go to next
        }
      } else {
        _isPlaying = playerState.playing;
      }
      notifyListeners();
    });

    _audioPlayer.positionStream.listen((p) {
      _position = p;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((d) {
      _duration = d ?? Duration.zero;
      notifyListeners();
    });
  }

  // Requires the Playlist now
  Future<void> playSong(Song song, List<Song> queue) async {

    _playlist = queue;
    _currentIndex = _playlist.indexWhere((s) => s.id == song.id);

    if (_currentSong?.id == song.id) {
      if (_audioPlayer.processingState == ProcessingState.ready ||
          _audioPlayer.processingState == ProcessingState.buffering ||
          _audioPlayer.processingState == ProcessingState.completed) {
        togglePlayPause();
        return;
      }
    }

    try {
      _currentSong = song;
      notifyListeners();


      // Load URL
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(song.audioUrl)),
      );

      _audioPlayer.play();
      _isPlaying = true;
      notifyListeners();

    } catch (e) {
      debugPrint("❌ Error playing song: $e");
      _currentSong = null;
      _isPlaying = false;
      notifyListeners();
    }
  }

  // ⏭️ SKIP NEXT
  void skipNext() {
    if (_playlist.isEmpty) return;

    int nextIndex;

    if (_isShuffle) {
      // Pick random index
      nextIndex = Random().nextInt(_playlist.length);
    } else {
      // Normal next
      nextIndex = _currentIndex + 1;
      // Loop back to start if at end
      if (nextIndex >= _playlist.length) {
        if (_loopMode == LoopMode.all) {
          nextIndex = 0;
        } else {
          return;
        }
      }
    }

    if (nextIndex >= 0 && nextIndex < _playlist.length) {
      playSong(_playlist[nextIndex], _playlist);
    }
  }

  // SKIP PREVIOUS
  void skipPrevious() {
    if (_playlist.isEmpty) return;

    int prevIndex;

    if (_position.inSeconds > 3) {
      seek(Duration.zero);
      return;
    }

    if (_isShuffle) {
      prevIndex = Random().nextInt(_playlist.length);
    } else {
      prevIndex = _currentIndex - 1;
      if (prevIndex < 0) {
        if (_loopMode == LoopMode.all) {
          prevIndex = _playlist.length - 1; // Go to last song
        } else {
          return; // Stop at start
        }
      }
    }

    if (prevIndex >= 0 && prevIndex < _playlist.length) {
      playSong(_playlist[prevIndex], _playlist);
    }
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void seek(Duration position) => _audioPlayer.seek(position);

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleLoop() {
    if (_loopMode == LoopMode.off) {
      _loopMode = LoopMode.all;
    } else if (_loopMode == LoopMode.all) {
      _loopMode = LoopMode.one;
    } else {
      _loopMode = LoopMode.off;
    }
    _audioPlayer.setLoopMode(_loopMode);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}