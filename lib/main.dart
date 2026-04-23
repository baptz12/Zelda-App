import 'dart:convert';

import 'package:zelda_app/database/isar_setup.dart';
import 'package:zelda_app/pages/random_monster.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zelda_app/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeIsar();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zelda App',
      home: const SplashScreenPage(),
    );
  }
}
