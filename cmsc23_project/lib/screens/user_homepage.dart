import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> entries = [];

  Widget entryList(int index) {
    if (entries.isEmpty) {
      return Center(
        child: Text("No entries yet"),
      );
    } else if (index == 1) {
      return profileBuilder();
    } else {
      return Center(
        child: Text("ENTRIES WOOSH"),
      );
    }
  }

  Widget profileBuilder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.person),
        Text("FULL NAME"),
        ElevatedButton(
          onPressed: () {},
          child: Text("Generate Building Pass"),
        ),
      ],
    );
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: Text('Drawer')),
      appBar: AppBar(
        title: Text("HOME PAGE"),
        backgroundColor: Color.fromARGB(255, 0, 37, 67),
      ),
      body: entryList(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 37, 67),
        onPressed: () {
          Navigator.pushNamed(context, '/entryform');
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Entries',
            backgroundColor: Color.fromARGB(255, 0, 37, 67),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
