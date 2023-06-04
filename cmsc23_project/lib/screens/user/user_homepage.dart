import 'package:cmsc23_project/screens/login.dart';
import 'package:cmsc23_project/screens/user/entryform.dart';
import 'package:cmsc23_project/screens/user/editform.dart';
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
  Widget body(int index, Stream<QuerySnapshot> entriesStream, String UID) {
    // context.read<AuthProvider>().fetchAuthentication();
    if (index == 1) {
      return profileBuilder();
    } else {
      return displayUserEntries(entriesStream, UID);
    }
  }

  Widget displayUserEntries(Stream<QuerySnapshot> entriesStream, String UID) {
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
                          String? docrefID = entry.id;
                          String? status = entry.status;
                          if (status == "open") {
                            context
                                .read<EntryListProvider>()
                                .entryPendingEdit(docrefID);
                            context
                                .read<EntryListProvider>()
                                .setToEdit(docrefID);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Entry is now pending for edit"),
                              ),
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditForm()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Entry is already pending"),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          String? docrefID = entry.id;
                          String? status = entry.status;
                          if (status == "open") {
                            context
                                .read<EntryListProvider>()
                                .entryPendingDelete(docrefID);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Entry is now pending for delete"),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Entry is already pending"),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              });
          // return Center();
        });
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
          return const LoginPage();
        }
        print("user currently logged in: ${snapshot.data!.uid}");
        //get the UID of currently logged in user and use it to get stream of their entries
        String UID = snapshot.data!.uid;
        Stream<QuerySnapshot> entriesStream = getEntriesStream(UID);

        return displayScaffold(context, entriesStream, UID);
      },
    );
  }

  Scaffold displayScaffold(BuildContext context,
      Stream<QuerySnapshot<Object?>> entriesStream, String UID) {
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
        title: Text("User View"),
      ),
      body: body(_selectedIndex, entriesStream, UID),
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
