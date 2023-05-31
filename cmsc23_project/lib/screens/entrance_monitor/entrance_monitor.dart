import 'package:cmsc23_project/screens/entrance_monitor/QR_scanner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'QR_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EntranceMonitor extends StatefulWidget {
  const EntranceMonitor({super.key});

  @override
  _EntranceMonitorState createState() => _EntranceMonitorState();
}

class _EntranceMonitorState extends State<EntranceMonitor> {
  List<dynamic> student_logs = ["maria", "Jason", "louie"];
  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();
  performSearch() {
    //handle search
    //mas maganda if mag generate ako ng material page to the searched student
  }

  //builds the four buttons that will be used to view students
  Widget students_cards() {
    return Column(
      children: [
        searchBar(),
        Expanded(
          child: ListView.builder(
            itemCount:
                student_logs.length, // Replace with the desired number of cards
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  leading:
                      Icon(Icons.image), // Replace with your desired card image
                  title: Text('Card $index'), // Replace with your card title
                  subtitle: Text(
                      '${student_logs[index]}'), // Replace with your card description
                  onTap: () {
                    // Action to perform when the card is tapped
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: performSearch,
          ),
        ],
      ),
    );
  }

  bool _isVisible = false;

  Widget profileBuilder() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person),
          Text("FULL NAME"),
          Visibility(
            visible: _isVisible,
            child: QrImage(
              // TODO change the data to an instance of entry, but for that to work
              // need to implement getting of entries from stream first
              data: '1234567890',
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            child: Text("View Building Pass"),
          ),
        ],
      ),
    );
  }

  body(int index) {
    if (index == 0) {
      if (student_logs.isEmpty) {
        return Center(
          child: Text("No entries yet"),
        );
      } else {
        return students_cards();
      }
    } else if (index == 1) {
      // Navigator.pushNamed(context, '/QR_scanner_page');
      return QRViewExample();
    } else if (index == 2) {
      return profileBuilder();
    }
  }

  _itemOnTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              print('pessed logout');
              context.read<AuthProvider>().signOut();
              Navigator.pop(context);
            },
            child: Text('Logout'),
            style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
        title: Text("Monitor View"),
      ),
      body: body(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_4),
            label: "Students",
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: "Scan QR",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _itemOnTapped,
      ),
    );
  }
}
