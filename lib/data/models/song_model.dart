import '../../domain/entities/song.dart';

class SongModel extends Song{
  SongModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.albumArtUrl,
    required super.audioUrl,
  });

  factory SongModel.fromMap(Map<String , dynamic> map , String docId){
    return SongModel(
        id: docId,
        title: map['title'] ?? 'Unknown title',
        artist: map['artist'] ?? 'Unknown Artist',
        albumArtUrl: map['albumArtUrl'] ?? '',
        audioUrl: map['audioUrl'] ?? ''
    );
  }

  Map<String , dynamic> toMap(){
    return{
      'title': title,
      'artist': artist,
      'albumArtUrl': albumArtUrl,
      'audioUrl': audioUrl,
    };
  }
}