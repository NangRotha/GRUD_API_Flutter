import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model class to represent the data we're fetching
class Album {
  final int userId;
  final int id;
  final String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'] ?? 0, // Provide a default value if null
      id: json['id'] ?? 0,         // Provide a default value if null
      title: json['title'] as String,
    );
  }
}

// Function to fetch the data from the API
Future<Album> createAlbum(String title) async {
  final http.Response response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    // If the server returns a 201 Created response, parse the JSON.
    return Album.fromJson(json.decode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 Created response,
    // throw an exception.
    throw Exception('Failed to create album: ${response.statusCode}');
  }
}

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Create> {
  final TextEditingController _controller = TextEditingController();
  Future<Album>? futureAlbum;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Fetch Data Example'),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Added padding for better UI
        child: (futureAlbum == null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(), // Added border for better UI
                    ),
                  ),
                  const SizedBox(height: 20), // Increased spacing
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Added padding
                    ),
                    child: const Text('Create Data'),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) { // Added input validation
                        setState(() {
                          futureAlbum = createAlbum(_controller.text);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a title!')),
                        );
                      }
                    },
                  ),
                ],
              )
            : FutureBuilder<Album>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Text Upate: ${snapshot.data!.title}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                       
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  return const CircularProgressIndicator();
                },
              ),
      ),
    );
  }
}
