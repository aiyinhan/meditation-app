
class Song {
  final String title;
  final String artist;
  final String url;
  bool isFavorite=false;

  Song({
    required this.title,
    required this.artist,
    required this.url,
    this.isFavorite=false,

  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'url':url,
      'isFavorite': isFavorite,
    };
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      artist: json['artist'],
      url: json['url'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
