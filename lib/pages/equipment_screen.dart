
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zelda_app/database/equipment.dart';
import 'package:zelda_app/database/isar_setup.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<StatefulWidget> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {

  late Future<List<Equipment>> _dataFuture;
  bool botw = true;

  Future<List<Equipment>> fetchEquipmentImageAndData() async {
    String game;

    if (botw) {
      game = "botw";
    } else {
      game = "totk";
    }

    final List<Equipment> equipmentData = await isar.equipments.filter().gameEqualTo(game).findAll();

    // if (randomMonster.image != null && mounted) {
    //   try {
    //     var fileInfo = await DefaultCacheManager().getSingleFile(randomMonster.image!);
    //     await precacheImage(FileImage(fileInfo), context);
    //   } catch (e) {
    //     print("Error while preloading the image");
    //   }
    // }

    return equipmentData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dataFuture = fetchEquipmentImageAndData();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('equipments', style: TextStyle(
          fontFamily: 'Zelda',
          fontSize: 27,
        ),),
        backgroundColor: Colors.black.withOpacity(0.05),
        elevation: 0,
          actions: [
            Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Center( // Utiliser Center pour l'aligner verticalement
              child: SizedBox(
                height: 30,
                child: ToggleSwitch(
                  minWidth: 70.0,
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
                    setState(() {
                      if (index == 0) {
                        botw = true;
                      } else {
                        botw = false;
                      }
                      _dataFuture = fetchEquipmentImageAndData();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body:
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/equipment_back.jpg'),
                fit: BoxFit.cover,
                opacity: 0.7
                )
            ),
          ),
          FutureBuilder<List<Equipment>>
          (future: _dataFuture,
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
                final items = snapshot.data!;
                return GridView.builder(
                  padding: EdgeInsets.only(
                    top: topPadding + 10,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      shadowColor: Colors.black.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.amber.withOpacity(0.4), width: 1.5)
                      ),
                      color: Colors.black.withOpacity(0.6),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: CachedNetworkImage(
                                imageUrl: '${item.image}',
                                fit: BoxFit.cover,
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                placeholderFadeInDuration: Duration.zero,
                                errorWidget: (context, url, error) {
                                  return Text("Image failed to load. You may be offline.");
                                },
                                width: 160,
                                height: 150,
                              ),
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.name ?? '', textAlign: TextAlign.center, style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Zelda',
                              fontSize: 18,
                            )), 
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              else {
                return const Text("No data were found");
              }
          })
        ]
      )
    );
  }
}