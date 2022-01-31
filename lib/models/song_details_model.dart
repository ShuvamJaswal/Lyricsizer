class SongDetailsModel {
  final String? name;
  final String? imageUrl;
  final String? lyricsURL;

  /// A unique songId.
  final String? id;
  final String? spotifyUrl;
  final String? youTubeUrl;
  final String? soundCloudUrl;

  //The album this media item belongs to.
  final String? album;

  // The artist of this media item.
  final String? artist;
  final String? releaseDate;
  SongDetailsModel({
    this.name,
    this.imageUrl,
    this.id,
    this.album,
    this.artist,
    this.lyricsURL,
    this.releaseDate,
    this.soundCloudUrl,
    this.spotifyUrl,
    this.youTubeUrl,
  });
  factory SongDetailsModel.fromJSON(Map<String, dynamic> map) =>
      SongDetailsModel(
          name: map['title'] ?? "unknown",
          imageUrl: map['song_art_image_url'] ?? "unknown",
          lyricsURL: map['url'],
          id: map['id'].toString(),
          album: map['album']?['full_title'] ?? "Unknown",
          artist: map['primary_artist']?['name'] ?? 'unknown',
          releaseDate: map['release_date_for_display'] ?? 'unknown',
          soundCloudUrl: ({
            for (var e in map['media']) e["provider"]: e["url"]
          })["soundcloud"],
          spotifyUrl: ({
            for (var e in map['media']) e["provider"]: e["url"]
          })["spotify"],
          youTubeUrl: ({
            for (var e in map['media']) e["provider"]: e["url"]
          })["youtube"]);
}
