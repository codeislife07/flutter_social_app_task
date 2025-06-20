import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app_task/src/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_social_app_task/src/features/auth/bloc/auth_state.dart';
import 'package:flutter_social_app_task/src/features/comments/bloc/comments_bloc.dart';
import 'package:flutter_social_app_task/src/features/comments/bloc/comments_event.dart';
import 'package:flutter_social_app_task/src/features/comments/bloc/comments_state.dart';
import 'package:flutter_social_app_task/src/features/comments/screens/comments_screen.dart';
import 'package:flutter_social_app_task/src/widgets/post_action_button.dart';
import 'package:image_loader_flutter/Screens/image_loader_widget.dart';
import 'package:intl/intl.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/post_model.dart';
import '../features/feed/bloc/feed_bloc.dart';
import '../features/feed/bloc/feed_event.dart';

import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final PostModel post;
  final String currentUser;

  const PostCard({super.key, required this.post, required this.currentUser});

  bool hasUserLiked() => post.likedBy.contains(currentUser);

  @override
  Widget build(BuildContext context) {
    final isLiked = hasUserLiked();
    final postTime = DateFormat(
      'MMM d • h:mm a',
    ).format(DateTime.parse(post.timestamp));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(
                22,
              ), // same radius as CircleAvatar
              child: SizedBox(
                width: 44,
                height: 44,
                child: ImageLoaderFlutterWidgets(
                  image:
                      'https://i.pravatar.cc/150?u=${post.username}', // random avatar url keyed by username
                  radius: 22,
                  circle: true,
                  onTap: false,
                ),
              ),
            ),
            title: Text(
              post.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Rajkot,Gujarat - ${timeago.format(DateTime.parse(post.timestamp))}",
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {}, // Optional: add menu
            ),
          ),

          // Image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 200,
              child: GestureDetector(
                onDoubleTap: () {
                  if (!isLiked) {
                    context.read<FeedBloc>().add(
                          LikePost(postId: post.id, username: currentUser),
                        );
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ImageLoaderFlutterWidgets(
                    image: post.imagePath,
                    radius: 0,
                    circle: false,
                    onTap: false,
                  ),
                ),
              ),
            ),
          ),

          // Caption
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(post.caption, style: const TextStyle(fontSize: 15)),
            ),

          // Like count
          if (post.likes > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.thumb_up, size: 16, color: Colors.blueAccent),
                  const SizedBox(width: 6),
                  Text(
                    '${post.likes} likes',
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),

          // const Divider(height: 20),

          // Action buttons: Like, Comment, Save
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionButton(
                context,
                icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: 'Like',
                color: isLiked ? Colors.blue : Colors.grey[700],
                onTap: () => context.read<FeedBloc>().add(
                      LikePost(postId: post.id, username: currentUser),
                    ),
              ),
              _actionButton(
                context,
                icon: Icons.comment_outlined,
                label: 'Comment',
                color: Colors.grey[700],
                onTap: () {
                  // When loaded, show the bottom sheet with comments
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return CommentsScreen(postId: post.id);
                    },
                  );
                },
              ),
              _actionButton(
                context,
                icon: Icons.download_outlined,
                label: 'Save',
                color: Colors.grey[700],
                onTap: () => handleImage(post.imagePath, context),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 14)),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      ),
    );
  }

  Future<void> handleImage(String imagePath, BuildContext context) async {
    var status = Platform.isIOS
        ? PermissionStatus.granted
        : await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    } else {
      Platform.isAndroid
          ? OpenSettingsPlusAndroid().manageExternalSources()
          : true;
      return;
    }
    try {
      // Prompt user to select a directory
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        return;
      }

      final fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
      final savePath = '$selectedDirectory/$fileName';
      // File(savePath).create();
      if (imagePath.startsWith('http')) {
        // Download from URL
        final dio = Dio();
        await dio.download(imagePath, savePath);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.greenAccent),
                SizedBox(width: 10),
                Text('Image downloaded successfully'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Local image path
        final file = File(imagePath);
        await file.copy(savePath);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image copied to selected location'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save image: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
