// repo/crud.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/models/album.dart';

Map<String, Album> _albumCache = {};
Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<Album?> fetchAlbumById(String id) async {
  if (_albumCache.containsKey(id)) {
    debugPrint('Fetching album from cache: $id');
    return _albumCache[id];
  }
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'));
  debugPrint('Fetch response status: ${response.statusCode}');
  debugPrint('Fetch response body: ${response.body}');
  if (response.statusCode == 200) {
    final album = Album.fromJson(jsonDecode(response.body));
    _albumCache[id] = album;
    return album;
  } else {
    throw Exception('Failed to load album with id: $id');
  }
}

Future<void> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
    },
  );
  debugPrint('Delete response status: ${response.statusCode}');
  debugPrint('Delete response body: ${response.body}');
  if (response.statusCode == 200) {
    _albumCache.remove(id);
    return;
  } else {
    throw Exception('Failed to delete album');
  }
}

Future<Album> updateAlbum(String id, String title) async {
  try {
    final http.Response response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': int.parse(id),
        'title': title,
      }),
    );
    debugPrint('Update response status: ${response.statusCode}');
    debugPrint('Update response body: ${response.body}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['id'] != null && json['title'] != null) {
        final updatedAlbum = Album.fromJson(json);
        _albumCache[id] = updatedAlbum; // Update cache to simulate persistence
        return updatedAlbum;
      } else {
        throw Exception('Invalid response format: Missing id or title');
      }
    } else {
      throw Exception('Failed to update album: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('updateAlbum error: $e');
    rethrow;
  }
}