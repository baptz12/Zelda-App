import 'package:flutter/material.dart';
import 'package:zelda_app/api/api.dart';
import 'package:zelda_app/database/isar_setup.dart';
import 'package:zelda_app/main.dart';
import 'package:zelda_app/pages/home_screen.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initData();
  }

  Future<void> _initData() async {
    try {
      await ApiService.fetchAndCacheMonstersData(isar);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreenPage())
        );
      }
    } catch (e) {
      print("Error while fetching API data in splash screen: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/loading.gif', width: 100),
            const SizedBox(height: 20),
            const Text("Loading data...", style: TextStyle(
              fontFamily: 'Zelda',
              fontSize: 20
            ))
          ],
        ),
      ),
    );
  }
}