

import 'package:flutter/material.dart';
import 'package:zelda_app/pages/equipment_screen.dart';
import 'package:zelda_app/pages/random_monster.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {

  late AssetImage logoImage;

  @override
  void initState() {
    super.initState();
    logoImage = const AssetImage('assets/images/logo2.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logoImage, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Image(image: logoImage, width: 140, gaplessPlayback: true),
        elevation: 0,
        toolbarHeight: 130,
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 247, 255, 255),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
                opacity: 0.8,
              )
            ),
          ) ,
          Align(
            alignment: Alignment.topCenter,
            child:
              Padding(padding: const EdgeInsets.only(top:200),
              child:
                Column(
                children: [
                  const Text("Welcome to the Zelda App !", style: const TextStyle(
                    fontFamily: 'Zelda',
                    fontSize: 30,
                  ),)
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EquipmentPage()
                ),
              );
            },
            borderRadius: BorderRadius.circular(60),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlue.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ]
              ),
              child: Image.asset(
                'assets/images/botw_hylian_shield_icon.png',
                width: 55,),
            ),
          ),
          const SizedBox(height: 20,),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RandomMonsterPage()
                    ),
                );
              },
              borderRadius: BorderRadius.circular(60),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
                ),
                child: Image.asset(
                  'assets/images/mob.png',
                  width: 50,)
              )
          ),
        ],
      ),
    );
  }
}