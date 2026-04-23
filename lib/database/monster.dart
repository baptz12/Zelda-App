import 'package:isar/isar.dart';

part 'monster.g.dart';

@collection
class Monster {
  Id id = Isar.autoIncrement;

  int? apiId;

  @Index(type: IndexType.value)
  String? name;

  String? description;
  String? image;
  bool? dlc;

  List<String>? commonLocations;
  List<String>? drops;

  @Index()
  String? game;
}