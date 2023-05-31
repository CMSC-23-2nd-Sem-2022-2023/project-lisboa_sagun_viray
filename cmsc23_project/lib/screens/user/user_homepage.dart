import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc23_project/providers/entry_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/entry_model.dart';
import '../../providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> entries = [1, 2, 3];

  Widget entryList(
    BuildContext context,
    int index,
  ) {
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;
    if (index == 0 && entries.isEmpty) {
      return Center(
        child: Text("No entries yet"),
      );
    } else if (index == 1) {
      return profileBuilder();
    } else {
      return displayUserEntries(userStream);
    }
  }

  Widget displayUserEntries(Stream<User?> userStream) {
    return StreamBuilder<User?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? user = snapshot.data;
          String? userId = user?.uid;
          print('this is the userId: $userId');
          context.read<EntryListProvider>().fetchUserEntries(userId!);
          Stream<QuerySnapshot>? userEntriesStream =
              context.read<EntryListProvider>().userEntries;
          return StreamBuilder(
              stream: userEntriesStream,
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                print(snapshot.data);
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error encountered! ${snapshot.error}"),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text("No Entries"),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: ((context, index) {
                    Entry entry = Entry.fromJson(snapshot.data?.docs[index]
                        .data() as Map<String, dynamic>);
                    return Dismissible(
                      key: Key(entry.UID.toString()),
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.delete),
                      ),
                      child: ListTile(
                        title: Text(
                          entry.date,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Checkbox(
                          value: entry.hasContact,
                          onChanged: (bool? value) {
                            context
                                .read<EntryListProvider>()
                                .toggleStatus(index, value!);
                          },
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) => TodoModal(
                                //     type: 'Edit',
                                //     entryIndex: index,
                                //   ),
                                // );
                              },
                              icon: const Icon(Icons.create_outlined),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              });
          // Query the Firestore collection to get the documents associated with the user
        } else if (snapshot.hasError) {
          return Text('Error retrieving user');
        } else {
          return CircularProgressIndicator();
        }
      },
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
        title: Text("User View"),
      ),
      body: entryList(context, _selectedIndex),
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
