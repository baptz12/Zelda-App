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

  bool hasError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initData();
  }

  Future<void> _initData() async {
    setState(() => hasError = false);

    try {
      await ApiService.fetchAndCacheMonstersData(isar);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreenPage())
        );
      }
    } catch (e) {
      print("Error while fetching API data in splash screen: $e");
      setState(() => hasError = true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: hasError == false ? _buildLoading() : _buildError()
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/loading.gif', width: 180),
        const SizedBox(height: 20),
        const Text("Loading data", style: TextStyle(
          fontFamily: 'Zelda',
          fontSize: 22,
          color: Colors.white70,
        ))
      ],
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset('assets/images/link-cold.gif', fit: BoxFit.cover, width: 150, height: 100,),
          ),
          const SizedBox(height: 20),
          Text("Unaible to retrieve data, please check your internet connection",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16),),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
            onPressed: _initData,
            child: const Text("RETRY", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}