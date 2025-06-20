import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_loader_flutter/Screens/image_loader_widget.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/comments_bloc.dart';
import '../bloc/comments_event.dart';
import '../bloc/comments_state.dart';

class CommentsScreen extends StatefulWidget {
  final int postId;

  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();

    // Load comments for the postId when bottom sheet opens
    context.read<CommentsBloc>().add(LoadComments(widget.postId));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _postComment() {
    final text = _commentController.text.trim();
    final authState = context.read<AuthBloc>().state;

    if (authState is Authenticated && text.isNotEmpty) {
      context.read<CommentsBloc>().add(
        AddComment(
          postId: widget.postId,
          username: authState.username,
          text: text,
        ),
      );
      _commentController.clear();

      // Reload comments after posting to update the list
      context.read<CommentsBloc>().add(LoadComments(widget.postId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Comments List - listen to CommentsBloc
              Expanded(
                child: BlocBuilder<CommentsBloc, CommentsState>(
                  builder: (context, state) {
                    if (state is CommentsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CommentsLoaded) {
                      if (state.comments.isEmpty) {
                        return const Center(child: Text('No comments yet.'));
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.comments.length,
                        itemBuilder: (context, index) {
                          final comment = state.comments[index];
                          final date = DateFormat(
                            'MMM dd - hh:mm a',
                          ).format(DateTime.parse(comment.timestamp));

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    22,
                                  ), // same radius as CircleAvatar
                                  child: SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: ImageLoaderFlutterWidgets(
                                      image:
                                          'https://i.pravatar.cc/150?u=${comment.username}', // random avatar url keyed by username
                                      radius: 22,
                                      circle: true,
                                      onTap: false,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.username,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        comment.text,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        format(
                                          DateTime.parse(comment.timestamp),
                                        ),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),

              // Comment input
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _postComment,
                      child: const Text('Post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
