abstract class FeedEvent {}

class LoadFeed extends FeedEvent {}

class AddPost extends FeedEvent {
  final String imagePath;
  final String caption;
  final String username;

  AddPost({
    required this.imagePath,
    required this.caption,
    required this.username,
  });
}

class LikePost extends FeedEvent {
  final int postId;
  final String username;

  LikePost({required this.postId, required this.username});
}
