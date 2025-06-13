import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app_task/src/database/db_provider.dart';
import 'package:flutter_social_app_task/src/models/comment_model.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial()) {
    on<LoadComments>(_onLoadComments);
    on<AddComment>(_onAddComment);
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentsState> emit,
  ) async {
    emit(CommentsLoading());
    final result = await DBProvider.db.query(
      'comments',
      where: 'post_id = ?',
      whereArgs: [event.postId],
      orderBy: 'id DESC',
    );
    final comments = result.map((e) => CommentModel.fromMap(e)).toList();
    emit(CommentsLoaded(comments));
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentsState> emit,
  ) async {
    await DBProvider.db.insert('comments', {
      'post_id': event.postId,
      'username': event.username,
      'text': event.text,
      'timestamp': DateTime.now().toIso8601String(),
    });
    add(LoadComments(event.postId));
  }
}
