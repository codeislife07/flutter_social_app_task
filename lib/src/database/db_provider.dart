import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class DBProvider {
  static Database? _db;

  static Future<void> initialize() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'insta_feed.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            username TEXT PRIMARY KEY
          )
        ''');

        await db.execute('''
          CREATE TABLE posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            image_path TEXT,
            caption TEXT,
            timestamp TEXT,
            likes INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE comments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            post_id INTEGER,
            username TEXT,
            text TEXT,
            timestamp TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE liked_posts (
            post_id INTEGER,
            username TEXT,
            PRIMARY KEY (post_id, username)
          )
        ''');

        // Insert dummy data
        await _insertDummyData(db);
      },
    );
  }

  static Database get db {
    if (_db == null) throw Exception("Database not initialized.");
    return _db!;
  }

  static Future<void> _insertDummyData(Database db) async {
    for (int i = 0; i < 5; i++) {
      final username = 'user$i';
      await db.insert('users', {'username': username});
      await db.insert('posts', {
        'username': username,
        'image_path': 'https://picsum.photos/200/300?random=$i',
        'caption': 'Caption for post $i',
        'timestamp': DateTime.now().toIso8601String(),
        'likes': 0,
      });
    }
  }

  Future<void> insertDummyData() async {
    final usernames = ['alice', 'bob', 'charlie', 'dave', 'emma'];

    for (var name in usernames) {
      await db.insert('users', {'username': name});
    }

    for (int i = 0; i < 8; i++) {
      final user = usernames[i % usernames.length];
      final timestamp =
          DateTime.now().subtract(Duration(days: i)).toIso8601String();
      final image = 'https://picsum.photos/seed/post$i/400/300';
      final caption = 'This is a dummy caption for post $i by @$user';

      final postId = await db.insert('posts', {
        'username': user,
        'image_path': image,
        'caption': caption,
        'timestamp': timestamp,
      });

      await db.insert('comments', {
        'post_id': postId,
        'username': usernames[(i + 1) % usernames.length],
        'text': 'Nice post!',
        'timestamp': DateTime.now().toIso8601String(),
      });

      await db.insert('likes', {
        'post_id': postId,
        'username': usernames[(i + 2) % usernames.length],
      });
    }
  }

  Future<List<PostModel>> fetchPosts() async {
    final db = DBProvider.db;
    final posts = await db.query('posts', orderBy: 'id DESC');

    List<PostModel> result = [];

    for (final post in posts) {
      final likedUsers = await db.query(
        'liked_posts',
        columns: ['username'],
        where: 'post_id = ?',
        whereArgs: [post['id']],
      );

      final likedBy =
          likedUsers.map((row) => row['username'] as String).toList();
      post['likedBy'] = likedBy;
      result.add(PostModel.fromJson(post));
    }

    return result;
  }
}
