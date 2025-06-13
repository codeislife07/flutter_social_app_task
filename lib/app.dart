import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app_task/src/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_social_app_task/src/features/auth/bloc/auth_event.dart';
import 'package:flutter_social_app_task/src/features/auth/screens/login_screen.dart';
import 'package:flutter_social_app_task/src/features/comments/bloc/comments_bloc.dart';
import 'package:flutter_social_app_task/src/features/comments/screens/comments_screen.dart';
import 'package:flutter_social_app_task/src/features/feed/bloc/feed_bloc.dart';
import 'package:flutter_social_app_task/src/features/feed/bloc/feed_event.dart';
import 'package:flutter_social_app_task/src/features/feed/screens/feed_screen.dart';
import 'package:flutter_social_app_task/src/features/feed/screens/post_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AuthCheck())),
        BlocProvider(create: (_) => FeedBloc()..add(LoadFeed())),
        BlocProvider(create: (_) => CommentsBloc()),
      ],
      child: MaterialApp(
        title: 'InstaFeed',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/feed': (context) => const FeedScreen(),
          '/post': (context) => const PostScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name!.startsWith('/comments/')) {
            final id = int.parse(settings.name!.split('/').last);
            return MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    create: (_) => CommentsBloc(),
                    child: CommentsScreen(postId: id),
                  ),
            );
          }
          return null;
        },
      ),
    );
  }
}
