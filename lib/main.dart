import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:zelda_app/database/isar_setup.dart';
import 'package:zelda_app/pages/random_monster.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zelda_app/pages/splash_screen.dart';
import 'package:zelda_app/services/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeIsar();

  runApp(ChangeNotifierProvider(
    create: (_) => ConnectivityService(),
    child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zelda App',
      builder: (context, child) {
        return ConnectionWidget(child: child!);
      },
      home: const SplashScreenPage(),
    );
  }
}

class ConnectionWidget extends StatelessWidget {
  final Widget child;
  const ConnectionWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<ConnectivityService>().status;

    return Scaffold(
      body: Stack(
        children: [
          child,
          if (status == ConnectivityStatus.offline)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.wifi_off, color: Colors.red, size: 24),
              ),
            )
        ],
      )
    );
  }
}