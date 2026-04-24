import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:isar/isar.dart';
import 'package:zelda_app/api/api.dart';
import 'package:zelda_app/data/monsters_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zelda_app/database/isar_setup.dart';
import 'package:zelda_app/database/monster.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class RandomMonsterPage extends StatefulWidget {
  const RandomMonsterPage({super.key});

  @override
  State<RandomMonsterPage> createState() => _RandomMonsterPageState();
}

class _RandomMonsterPageState extends State<RandomMonsterPage> {

  late Future<Monster> _dataFuture;
  bool botw = true;

  Future<Monster> fetchMonsterImageAndData() async {
    String game;

    if (botw) {
      game = "botw";
    } else {
      game = "totk";
    }

    final List<Monster> monsterData = await isar.monsters.filter().gameEqualTo(game).findAll();

    final random = Random();

    final int randomIndex = random.nextInt(monsterData.length);

    final Monster randomMonster = monsterData[randomIndex];

    if (randomMonster.image != null && mounted) {
      try {
        var fileInfo = await DefaultCacheManager().getSingleFile(randomMonster.image!);
        await precacheImage(FileImage(fileInfo), context);
      } catch (e) {
        print("Error while preloading the image");
      }
    }

    return randomMonster;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dataFuture = fetchMonsterImageAndData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("random mob", style: TextStyle(
          fontFamily: 'Zelda',
          fontSize: 27,
        ),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 247, 255, 255),
      body:
          Stack (
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background_mobs.jpg"),
                    fit: BoxFit.cover,
                    opacity: 0.7,
                  )
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child:
                    Padding(
                      padding:  const EdgeInsets.only(top: 150.0, right: 20.0),
                      child: ToggleSwitch(
                        minHeight: 40,
                        minWidth: 100,
                        cornerRadius: 30,
                        animate: true,
                        curve: Curves.easeInOut,
                        dividerColor: Colors.transparent,
                        initialLabelIndex: botw ? 0 : 1,
                        totalSwitches: 2,
                        activeBgColors: [[Colors.deepPurple.shade200], [Colors.deepPurple.shade200]],
                        inactiveBgColor: Colors.deepPurple.shade50,
                        activeFgColor: const Color(0xFFFFFDE7),
                        inactiveFgColor: Colors.black54,
                        labels: ['BOTW', 'TOTK'],
                        customTextStyles: [
                          const TextStyle(
                            fontFamily: 'Zelda',
                            fontSize: 15,
                          )
                        ],
                        onToggle: (index) {
                        if (index != null) {
                          setState(() {
                          if (index == 0) {
                            botw = true;
                          } else {
                            botw = false;
                          }
                          _dataFuture = fetchMonsterImageAndData();
                        });
                      }
                    },
                  )
                ,
                ),
              ),
              Center(
                child: FutureBuilder<Monster>(
                    future: _dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Image.asset('assets/images/loading.gif',
                            width: 200,
                            height: 200,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error while resolving data : ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${data.name}", style: const TextStyle(
                              fontFamily: 'Zelda',
                              fontSize: 40,
                            ),),
                            const Divider(
                              color: Colors.grey,
                              thickness: 3,
                              indent: 50,
                              endIndent: 50,
                              height: 1,
                            ),
                            const SizedBox(height: 30),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: CachedNetworkImage(
                                imageUrl: '${data.image}',
                                fit: BoxFit.cover,
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                placeholderFadeInDuration: Duration.zero,
                                errorWidget: (context, url, error) {
                                  return Text("Image failed to load. You may be offline.");
                                },
                              ),
                            )
                          ],
                        );
                      }

                      else {
                        return const Text('No data were found');
                      }
                    }
                ),
              ),
            ],
          ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
              onPressed: () {
                setState(() {
                  _dataFuture = fetchMonsterImageAndData();
                });
              },
              tooltip: 'Refresh',
              child: const Icon(Icons.refresh)
              ),
          ]
        ),
    );
  }
}