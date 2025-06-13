import 'package:flutter_social_app_task/src/models/post_model.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<PostModel> posts;

  FeedLoaded(this.posts);
}
