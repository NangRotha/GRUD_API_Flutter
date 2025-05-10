// screens/update_album.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/album.dart';
import 'package:myapp/repo/crud.dart';

class UpdateAlbum extends StatefulWidget {
  final String id;
  const UpdateAlbum({super.key, required this.id});

  @override
  State<UpdateAlbum> createState() => _UpdateAlbumState();
}

class _UpdateAlbumState extends State<UpdateAlbum> {
  late Future<Album?> futureAlbum;
  bool _isUpdating = false; // Track if update is in progress
  bool _isUpdated = false; // Track if update is complete
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbumById(widget.id);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _updateAndRefresh(BuildContext context, String id, String newTitle) async {
    setState(() {
      _isUpdating = true;
      _isUpdated = false;
    });
    try {
      final updatedAlbum = await updateAlbum(id, newTitle);
      debugPrint('Updated album: ${updatedAlbum.title}');
      setState(() {
        _isUpdating = false;
        _isUpdated = true;
        futureAlbum = fetchAlbumById(id); // Re-fetch from cache
      });
    } catch (e) {
      debugPrint('Update error: $e');
      setState(() {
        _isUpdating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update album: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Mobile App'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: FutureBuilder<Album?>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (_isUpdating) {
            return const CircularProgressIndicator();
          }

          if (_isUpdated && snapshot.hasData && snapshot.data != null) {
            final updatedAlbum = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Updated and again fetching',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('The album has been updated successfully'),
                const SizedBox(height: 20),
                Text('New Title: ${updatedAlbum.title}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isUpdated = false;
                      _isUpdating = false;
                      futureAlbum = fetchAlbumById(widget.id);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Edit Again'),
                ),
              ],
            );
          }

          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Error occurred while fetching album',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Error: ${snapshot.error}'),
              ],
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No album found',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('The album might not exist.'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      futureAlbum = fetchAlbumById(widget.id);
                      _isUpdated = false;
                      _isUpdating = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry Fetching'),
                ),
              ],
            );
          }

          final album = snapshot.data!;
          if (_titleController.text.isEmpty) {
            _titleController.text = album.title;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Album ID: ${album.id}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Album Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final newTitle = _titleController.text.trim();
                    if (newTitle.isNotEmpty) {
                      _updateAndRefresh(context, widget.id, newTitle);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Update Data'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}