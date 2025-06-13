import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app_task/src/widgets/animated_button.dart';
import 'package:flutter_social_app_task/src/widgets/post_action_button.dart';
import 'package:image_loader_flutter/Screens/image_loader_widget.dart';
import 'package:path_provider/path_provider.dart';
import '../models/post_model.dart';
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
    print("likes user ${post.likedBy}");
    print("likes ${post.likes}");

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
                    handleImage(post.imagePath, context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleImage(String imagePath, BuildContext context) async {
    // Check if the image path is a network URL or a local file path
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      // Image is from a network URL, so download it using Dio
      try {
        // Get the image name from the URL (e.g., the last part after "/")
        final fileName = imagePath.split('/').last;

        // Get the temporary directory of the app
        final tempDir = await getTemporaryDirectory();
        final savePath = '${tempDir.path}/$fileName';

        // Create an instance of Dio
        Dio dio = Dio();

        // Download the image from the URL
        await dio.download(imagePath, savePath);

        // Show success message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Image saved')));
      } catch (e) {
        // Handle errors (e.g., no internet, download failed)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error downloading image: $e')));
      }
    } else {
      // Image is a local file, prompt user for a location to copy the image
      try {
        // Show file picker for user to select location
        final result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          allowMultiple: false,
        );

        if (result != null && result.files.isNotEmpty) {
          final selectedPath = result.files.single.path;
          if (selectedPath != null) {
            final destinationPath =
                '$selectedPath/${DateTime.now().millisecondsSinceEpoch}.jpg';
            final file = File(imagePath);

            // Copy the local file to the selected location
            await file.copy(destinationPath);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image copied to selected location'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('No location selected')));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error copying image: $e')));
      }
    }
  }
}
