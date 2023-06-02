import 'package:cmsc23_project/screens/user/entryform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          print("$userId is logged in");
          print(snapshot.connectionState);
          // Query the Firestore collection to get the documents associated with the user
          Stream<QuerySnapshot<Map<String, dynamic>>> userEntriesStream =
              FirebaseFirestore.instance
                  .collection('entries')
                  .where('UID', isEqualTo: userId)
                  .snapshots();
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: userEntriesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot<Map<String, dynamic>> entriesSnapshot =
                    snapshot.data!;
                List<QueryDocumentSnapshot<Map<String, dynamic>>> entries =
                    entriesSnapshot.docs;

                // Access and work with the documents in the 'entries' list
                // ...

                // Example: Display the titles of the entries
                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Map<String, dynamic>> entry =
                        entries[index];
                    String title = entry.data()['title'];
                    return ListTile(
                      title: Text(title),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error retrieving entries');
              } else {
                return CircularProgressIndicator();
              }
            },
          );
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(child: Text('Drawer')),
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
      body: entryList(context, _selectedIndex),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 37, 67),
        onPressed: () {
          // Navigator.pushNamed(context, '/entryform');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EntryForm()));
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
