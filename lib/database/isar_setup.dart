import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'monster.dart';
import 'equipment.dart';
import 'package:flutter/material.dart';

late Isar isar;

Future<void> initializeIsar() async {
  final dir = await getApplicationDocumentsDirectory();

  isar = await Isar.open(
    [
      MonsterSchema,
      EquipmentSchema,
    ],
    directory: dir.path,
  );
}
