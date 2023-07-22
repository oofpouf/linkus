class Profile {
  Profile({
    required this.name,
    required this.distance,
    required this.imageAsset,
    required this.year,
    this.isMatched = false,
    List<String>? likes,
    required this.email,
    this.isLiked = false,
  }) : likes = likes ?? [];

  final String name;
  final String distance;
  final String imageAsset;
  final String year;
  bool isMatched;
  List<String> likes;
  final String email;
  bool isLiked;
}
