// screens/delete.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/album.dart';
import 'package:myapp/repo/crud.dart';

class Deletealbum extends StatefulWidget {
  final String id;
  const Deletealbum({super.key, required this.id});

  @override
  State<Deletealbum> createState() => _DeletealbumState();
}

class _DeletealbumState extends State<Deletealbum> {
  late Future<Album?> futureAlbum;
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbumById(widget.id);
  }

  Future<void> _deleteAndRefresh(BuildContext context, String id) async {
    try {
      await deleteAlbum(id);
      setState(() {
        _isDeleted = true;
        futureAlbum = fetchAlbumById(id); // Re-fetch to simulate checking
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete album: $e')),
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
          if (_isDeleted && snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (_isDeleted) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Deleted and again fetching',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("It is giving 'Null' because we deleted that content"),
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'quidem molestiae enim',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _deleteAndRefresh(context, widget.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Delete Data'),
              ),
            ],
          );
        },
      ),
    );
  }
}