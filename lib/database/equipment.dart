

import 'package:isar/isar.dart';

part 'equipment.g.dart';

@collection
class Equipment {
  Id id = Isar.autoIncrement;

  int? apiId;

  @Index(type: IndexType.value)
  String? name;

  String? description;
  String? image;
  bool? dlc;

  List<String>? commonLocations;
  EquipmentProperties? properties;

  @Index()
  String? game;
}

@embedded
class EquipmentProperties {
  int? attack;
  int? defense;
  String? effect;
  String? type;

  EquipmentProperties({
    this.attack,
    this.defense,
    this.effect,
    this.type,
  });

  factory EquipmentProperties.fromJson(Map<String, dynamic> json) {
    return EquipmentProperties(
      attack: json['attack'],
      defense: json['defense'],
      effect: json['effect'],
      type: json['type'],
    );
  }
}