import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app_task/src/database/db_provider.dart';
import 'package:flutter_social_app_task/src/models/post_model.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<AddPost>(_onAddPost);
    on<LikePost>(_onLikePost);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    final result = await DBProvider.db.query('posts', orderBy: 'id DESC');
    final posts = result.map((e) => PostModel.fromJson(e)).toList();
    emit(FeedLoaded(posts));
  }

  Future<void> _onAddPost(AddPost event, Emitter<FeedState> emit) async {
    await DBProvider.db.insert('posts', {
      'username': event.username,
      'image_path': event.imagePath,
      'caption': event.caption,
      'timestamp': DateTime.now().toIso8601String(),
      'likes': 0,
    });
    add(LoadFeed());
  }

  Future<void> _onLikePost(LikePost event, Emitter<FeedState> emit) async {
    final liked = await DBProvider.db.query(
      'liked_posts',
      where: 'post_id = ? AND username = ?',
      whereArgs: [event.postId, event.username],
    );

    if (liked.isEmpty) {
      await DBProvider.db.insert('liked_posts', {
        'post_id': event.postId,
        'username': event.username,
      });
      await DBProvider.db.rawUpdate(
        'UPDATE posts SET likes = likes + 1 WHERE id = ?',
        [event.postId],
      );
    } else {
      await DBProvider.db.delete(
        'liked_posts',
        where: 'post_id = ? AND username = ?',
        whereArgs: [event.postId, event.username],
      );
      await DBProvider.db.rawUpdate(
        'UPDATE posts SET likes = likes - 1 WHERE id = ? AND likes > 0',
        [event.postId],
      );
    }

    add(LoadFeed());
  }
}
