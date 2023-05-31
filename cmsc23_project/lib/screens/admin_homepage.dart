import 'package:flutter/material.dart';

import '../models/entry_model.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Entry> entries = [];
  int _selectedIndex = 0;

  //builds the four buttons that will be used to view students
  Widget students_buttons() {
    return ListView(
      scrollDirection: Axis.vertical,
      //direction: Axis.vertical,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20,
            ),
            //1st column of buttons
            Column(
              children: [
                Card(
                  color: Color.fromARGB(255, 185, 105, 36),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor:
                        Color.fromARGB(255, 227, 130, 44).withAlpha(20),
                    onTap: () {
                      //TODO functionality of this card
                      //Navigator.push emerut
                    },
                    child: const SizedBox(
                      width: 150,
                      height: 200,
                      child: Center(
                        child: Text(
                          "Requests",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  clipBehavior: Clip.hardEdge,
                  color: Color.fromARGB(255, 245, 247, 245),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      //TODO functionality of this card
                    },
                    child: const SizedBox(
                      width: 150,
                      height: 200,
                      child: Center(
                        child: Text("All Students"),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
            //sizedbox as pading
            SizedBox(
              width: 20,
            ),
            //2nd column of buttons
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Card(
                  clipBehavior: Clip.hardEdge,
                  color: Color.fromARGB(255, 245, 247, 245),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      //TODO functionality of this card
                    },
                    child: const SizedBox(
                      width: 150,
                      height: 200,
                      child: Center(
                        child: Text(
                          "Quarantined Students",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  color: Color.fromARGB(255, 46, 160, 201),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor:
                        Color.fromARGB(255, 46, 160, 201).withAlpha(20),
                    onTap: () {
                      //TODO functionality of this card
                    },
                    child: const SizedBox(
                      width: 150,
                      height: 200,
                      child: Center(
                        child: Text(
                          "Under Monitoring",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ],
    );
  }

  Widget profileBuilder() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person),
          Text("FULL NAME"),
          ElevatedButton(
            onPressed: () {},
            child: Text("Generate Building Pass"),
          ),
        ],
      ),
    );
  }

  body(int index) {
    if (index == 0) {
      return students_buttons();
    } else if (index == 1) {
      if (entries.isEmpty) {
        return Center(
          child: Text("No entries yet"),
        );
      } else {
        return Center(
          child: Text("ENTRIES WOOSH"),
        );
      }
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
        title: Text("Admin View"),
      ),
      body: body(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_4),
            label: "Students",
            backgroundColor: Color.fromARGB(255, 201, 115, 39),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Entries",
            backgroundColor: Color.fromARGB(255, 46, 160, 201),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Color(0xfff09819),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _itemOnTapped,
      ),
    );
  }
}
