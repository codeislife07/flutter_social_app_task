class CommentModel {
  final int id;
  final int postId;
  final String username;
  final String text;
  final String timestamp;

  CommentModel({
    required this.id,
    required this.postId,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'post_id': postId,
    'username': username,
    'text': text,
    'timestamp': timestamp,
  };

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
    id: map['id'],
    postId: map['post_id'],
    username: map['username'],
    text: map['text'],
    timestamp: map['timestamp'],
  );
}
