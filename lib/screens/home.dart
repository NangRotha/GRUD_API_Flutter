// screens/home.dart
import 'package:flutter/material.dart';
import 'package:myapp/screens/delete.dart';
import 'package:myapp/screens/update_album.dart';
import 'package:myapp/screens/create.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget _buildButton(BuildContext context, String label, Widget page) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Home'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            _buildButton(context, 'Create', const Create()),
            const SizedBox(height: 16),
            _buildButton(context, 'Update', UpdateAlbum(id: '1')),
            const SizedBox(height: 16),
            _buildButton(context, 'Delete', Deletealbum(id: '1')), // Use a hardcoded id for testing
          ],
        ),
      ),
    );
  }
}