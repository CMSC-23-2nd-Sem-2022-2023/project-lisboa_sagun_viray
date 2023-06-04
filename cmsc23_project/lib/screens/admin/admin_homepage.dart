import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return Center(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/monitor_requests');
            },
            child: SizedBox(
              width: 160,
              height: 200,
              child: Card(
                shadowColor: Color.fromRGBO(214, 214, 214, 1),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle_notifications,
                          size: 50,
                          color: Color.fromARGB(255, 0, 37, 67),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "All Requests",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 37, 67)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/monitor_students');
            },
            child: SizedBox(
              width: 160,
              height: 200,
              child: Card(
                shadowColor: Color.fromRGBO(214, 214, 214, 1),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.groups_2_sharp,
                          size: 50,
                          color: Color.fromARGB(255, 0, 37, 67),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "All Students",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 37, 67)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/monitor_students');
            },
            child: SizedBox(
              width: 160,
              height: 200,
              child: Card(
                shadowColor: Color.fromRGBO(214, 214, 214, 1),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.groups_2_sharp,
                          size: 50,
                          color: Color.fromARGB(255, 0, 37, 67),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Quarantined",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 37, 67)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/monitor_students');
            },
            child: SizedBox(
              width: 160,
              height: 200,
              child: Card(
                shadowColor: Color.fromRGBO(214, 214, 214, 1),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 50,
                          color: Color.fromARGB(255, 0, 37, 67),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Monitoring",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 37, 67)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //builds the profile of the admin
  Widget profileBuilder() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person),
          const Text("FULL NAME"),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Generate Building Pass"),
          ),
        ],
      ),
    );
  }

  //builds entries from stream
  Widget entriesBuilder(Stream<QuerySnapshot> entriesStream, String UID) {
    print("at entries builder");
    return StreamBuilder(
        stream: entriesStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Entries Found"),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Entry entry = Entry.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);
                //access entry like 'entry.'
                return ListTile(
                  title: Text(entry.UID),
                  leading: Text(entry.date),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Perform edit operation for the entry
                          // You can navigate to an edit screen or show a dialog
                          // to allow the user to modify the entry.
                          // Example: navigate to EditEntryScreen(entry);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Perform delete operation for the entry
                          // You can show a confirmation dialog before deleting
                          // the entry to confirm the user's intent.
                          // Example: showDeleteConfirmationDialog(entry);
                        },
                      ),
                    ],
                  ),
                );
              });
          // return Center();
        });
  }

  //this function returns a different widget depending on the index of the
  //bottomnav bar
  body(int index, Stream<QuerySnapshot> entriesStream, String UID) {
    if (index == 0) {
      return students_buttons();
    } else if (index == 1) {
      return entriesBuilder(entriesStream, UID);
    } else if (index == 2) {
      return profileBuilder();
    }
  }

  _itemOnTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Stream<QuerySnapshot> getEntriesStream(String UID) {
    Stream<QuerySnapshot> entriesStream =
        context.watch<EntryListProvider>().getEntries(UID);
    return entriesStream;
  }

  @override
  Widget build(BuildContext context) {
    //keep watching userStream
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;

    return StreamBuilder(
      stream: userStream,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          // if snapshot has no data, keep returning the login page
          //TODO have UI prompt like alertdialog or new screent instead
          print("snapshot has no data");
          return const AdminLoginPage();
        }
        print("user currently logged in: ${snapshot.data!.uid}");
        //get the UID of currently logged in user and use it to get stream of their entries
        String UID = snapshot.data!.uid;
        Stream<QuerySnapshot> entriesStream = getEntriesStream(UID);

        return displayScaffold(context, entriesStream, UID);
      },
    );
  }

  //if a user succesfully logs in, return this scaffold
  Scaffold displayScaffold(BuildContext context,
      Stream<QuerySnapshot<Object?>> entriesStream, String UID) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 37, 67),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              print('pressed logout');
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
        title: Text("Admin Dashboard"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 0, 37, 67), // First color
              Color.fromARGB(255, 128, 150, 209), // Second color
            ],
          ),
        ),
        child: body(_selectedIndex, entriesStream, UID),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Students",
            backgroundColor: Color.fromARGB(255, 0, 13, 47),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Entries",
            backgroundColor: Color.fromARGB(255, 0, 42, 57),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Color.fromARGB(255, 0, 43, 33),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
        onTap: _itemOnTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 37, 67),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/entryform');
        },
      ),
    );
  }
}
