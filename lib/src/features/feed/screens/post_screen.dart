import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  File? _image;
  final TextEditingController _captionController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _submitPost(BuildContext context) {
    final caption = _captionController.text.trim();
    final authState = context.read<AuthBloc>().state;

    if (_image == null || authState is! Authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image to post.')),
      );
      return;
    }

    context.read<FeedBloc>().add(
      AddPost(
        imagePath: _image!.path,
        caption: caption,
        username: authState.username,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('New Post', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _image == null ? null : () => _submitPost(context),
            child: Text(
              'Share',
              style: TextStyle(
                color: _image == null ? Colors.grey : const Color(0xFF1877F2),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Image preview with overlay buttons
            GestureDetector(
              onTap: () => _showImageSourceActionSheet(context),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  image:
                      _image != null
                          ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    _image == null
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to add photo',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                        : null,
              ),
            ),

            const SizedBox(height: 20),

            // Caption input
            TextField(
              controller: _captionController,
              maxLines: 4,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),

            const Spacer(),

            // Share button fixed at bottom if you want, else appbar action is enough
            // Here I skip button at bottom because we have share on top bar
          ],
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
