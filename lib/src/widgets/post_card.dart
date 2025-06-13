import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app_task/src/models/post_model.dart';
import 'package:flutter_social_app_task/src/widgets/animated_button.dart';
import 'package:flutter_social_app_task/src/widgets/post_action_button.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_loader_flutter/Screens/image_loader_widget.dart';
import '../features/feed/bloc/feed_bloc.dart';
import '../features/feed/bloc/feed_event.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final String currentUser;

  const PostCard({super.key, required this.post, required this.currentUser});

  bool hasUserLiked() => post.likedBy.contains(currentUser);

  @override
  Widget build(BuildContext context) {
    bool isLiked = hasUserLiked();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Text(post.username[0].toUpperCase()),
            ),
            title: Text(
              post.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post.timestamp,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),

          // Image
          GestureDetector(
            onDoubleTap: () {
              if (!isLiked) {
                context.read<FeedBloc>().add(
                  LikePost(postId: post.id, username: currentUser),
                );
              }
            },
            onTap:
                () => showDialog(
                  context: context,
                  builder:
                      (_) => Dialog(
                        backgroundColor: Colors.black,
                        child: InteractiveViewer(
                          child: ImageLoaderFlutterWidgets(
                            radius: 0,
                            circle: false,
                            image: post.imagePath,
                          ),
                        ),
                      ),
                ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ImageLoaderFlutterWidgets(
                      radius: 0,
                      circle: false,
                      image: post.imagePath,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Caption
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(post.caption),
            ),

          const Divider(),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedLikeButton(
                  isLiked: isLiked,
                  likeCount: post.likes,
                  onTap: () {
                    context.read<FeedBloc>().add(
                      LikePost(postId: post.id, username: currentUser),
                    );
                  },
                ),
                PostActionButton(
                  icon: Icons.comment,
                  label: 'Comment',
                  onPressed: () {
                    Navigator.pushNamed(context, '/comments/${post.id}');
                  },
                ),
                PostActionButton(
                  icon: Icons.download,
                  label: 'Save',
                  onPressed: () async {
                    await ImageDownloader.downloadImage(post.imagePath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image saved')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
