import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app_task/app.dart';
import 'package:flutter_social_app_task/src/database/db_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBProvider.initialize();
  runApp(const MyApp());
}
