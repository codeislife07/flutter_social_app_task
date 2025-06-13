import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'src/database/db_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBProvider.initialize();
  runApp(const MyApp());
}
