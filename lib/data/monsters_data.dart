import 'dart:ffi';

import 'package:flutter/material.dart';

class MonstersData {
  final List<String> commonLocations;
  final String description;
  final bool dlc;
  final List<String> drops;
  final int id;
  final String image;
  final String name;

  MonstersData({
    required this.commonLocations,
    required this.description,
    required this.dlc,
    required this.drops,
    required this.id,
    required this.image,
    required this.name,
  });

  factory MonstersData.fromJson(Map<String, dynamic> json) {
    return MonstersData(
        commonLocations: json['common_locations'] != null ? List<String>.from(json['common_locations']):[],
        description: json['description'],
        dlc: json['dlc'],
        drops: json['drops'] != null ? List<String>.from(json['drops']):[],
        id: json['id'],
        image: json['image'],
        name: json['name']);
  }
}