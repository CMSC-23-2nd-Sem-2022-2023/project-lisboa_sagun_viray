import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO make stream builder and list builder for list of entries
      //connect it to firebase
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Column(
        children: [
          Text("No entries yet"),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, '/entryform');
      }),
    );
  }
}
