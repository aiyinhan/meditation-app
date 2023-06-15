
class Song {
  final String title;
  final String artist;
  final String url;

  Song({
    required this.title,
    required this.artist,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'url':url,
    };
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      artist: json['artist'],
      url: json['url'],
    );
  }
}
