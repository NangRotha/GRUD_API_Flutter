// models/album.dart
import 'package:flutter/material.dart';

class Album {
  final int id;
  final String title;

  Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing JSON: $json');
    return Album(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}