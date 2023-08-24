import 'package:flutter/material.dart';
import 'imagepage.dart';
import 'userdatabase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await UserDatabase.instance.database;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePage(),
    );
  }
}
