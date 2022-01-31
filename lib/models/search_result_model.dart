class SearchResultModel {
  final String? name;
  final String? imageUrl;
  final String? songId;
  SearchResultModel({
    this.name,
    this.imageUrl,
    this.songId,
  });
  factory SearchResultModel.fromJSON(Map<String, dynamic> map) =>
      SearchResultModel(
          name: map['result']['full_title'] ?? "unknown",
          imageUrl: map['result']['song_art_image_thumbnail_url'],
          songId: map['result']['id'].toString());
}
