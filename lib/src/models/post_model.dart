class PostModel {
  final int id;
  final String username;
  final String imagePath;
  final String caption;
  final String timestamp;
  final int likes;
  final List<String> likedBy; // 👈 Add this field

  PostModel({
    required this.id,
    required this.username,
    required this.imagePath,
    required this.caption,
    required this.timestamp,
    required this.likes,
    required this.likedBy,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      username: json['username'] ?? "",
      imagePath: json['imagePath'] ?? "",
      caption: json['caption'] ?? "",
      timestamp: json['timestamp'] ?? "",
      likes: json['likes'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []), // 👈 From JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'imagePath': imagePath,
      'caption': caption,
      'timestamp': timestamp,
      'likes': likes,
      'likedBy': likedBy, // 👈 To JSON
    };
  }
}
