import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:isar/isar.dart';
import 'package:zelda_app/data/monsters_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zelda_app/database/monster.dart';

class ApiService {

  static Future<void> fetchAndCacheMonstersData(Isar isar) async {
    // final http.Response response;

    // if (botw) {
    //   response = await http.get(Uri.parse("https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters?game=botw"));
    // } else {
    //   response = await http.get(Uri.parse("https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters?game=totk"));
    // }

    // if (response.statusCode == 200) {

    //   final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    //   final List<dynamic> monstersList = jsonResponse['data'];

    //   final random = Random();

    //   final int randomIndex = random.nextInt(monstersList.length);

    //   final Map<String, dynamic> randomMonsterJson = monstersList[randomIndex];

    //   return MonstersData.fromJson(randomMonsterJson);

    //   //return MonstersData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // } else {
    //   throw Exception('API is not available');
    // }

    final botwCount = await isar.monsters.filter().gameEqualTo('botw').count();
    final totkCount = await isar.monsters.filter().gameEqualTo('totk').count();

    if (botwCount > 80 && totkCount > 80) {
      // Display loading screen even if data
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      final responseBotw = await http.get(Uri.parse("https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters?game=botw")).timeout(const Duration(seconds: 15));
  
      final responseTotk = await http.get(Uri.parse("https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters?game=totk")).timeout(const Duration(seconds: 15));
  
  
      if (responseBotw.statusCode == 200 && responseTotk.statusCode == 200) {
        final jsonBotw = jsonDecode(responseBotw.body);
        final jsonTotk = jsonDecode(responseTotk.body);
  
        List<Monster> monstersToSave = [];
  
        for (var item in jsonBotw['data']) {
          monstersToSave.add(_parseMonster(item, 'botw'));
        }
  
        for (var item in jsonTotk['data']) {
          monstersToSave.add(_parseMonster(item, 'totk'));
        }
  
        await isar.writeTxn(() async {
          await isar.monsters.clear();
          await isar.monsters.putAll(monstersToSave);
        });
  
      } else {
        throw Exception("Error while fetching API Data at the startup");
      }
    } on TimeoutException catch (_) {
      throw Exception("Server timeout.");
    } catch (e) {
      throw Exception("Connection timeout.");
    }
  }

  static Monster _parseMonster(Map<String, dynamic> item, String game) {
    return Monster()
      ..apiId = item['id']
      ..name = item['name']
      ..description = item['description']
      ..image = item['image']
      ..dlc = item['dlc']
      ..commonLocations = List<String>.from(item['common_locations'] ?? [])
      ..drops = List<String>.from(item['drops'] ?? [])
      ..game = game;
  }
}