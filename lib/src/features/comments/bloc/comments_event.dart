abstract class CommentsEvent {}

class LoadComments extends CommentsEvent {
  final int postId;

  LoadComments(this.postId);
}

class AddComment extends CommentsEvent {
  final int postId;
  final String username;
  final String text;

  AddComment({
    required this.postId,
    required this.username,
    required this.text,
  });
}
