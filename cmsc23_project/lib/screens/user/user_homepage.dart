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
  List<dynamic> entries = [1, 2, 3];

  Widget entryList(
    BuildContext context,
    int index,
  ) {
    context.read<AuthProvider>().fetchAuthentication();
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
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return Text("snapshot has no data");
        }

        String UID = snapshot.data!.uid;
        Stream<QuerySnapshot> entriesStream =
            context.read<EntryListProvider>().getEntries(UID);
        // Delay the execution of code until after the build method has complete
        // If user is logged in, display the scaffold containing the streambuilder for the todos
        return entriesBuilder(entriesStream, UID);
      },
    );
  }

  Widget entriesBuilder(Stream<QuerySnapshot> entriesStream, String UID) {
    print("at entries builder");
    return StreamBuilder(
      stream: entriesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('this is loading'),
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
              snapshot.data?.docs[index].data() as Map<String, dynamic>,
            );

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
                        context.read<EntryListProvider>().setToEdit(docrefID);
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

                      // Perform edit operation for the entry
                      // You can navigate to an edit screen or show a dialog
                      // to allow the user to modify the entry.
                      // Example: navigate to EditEntryScreen(entry);
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
                            content: Text("Entry is now pending for delete"),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Entry is already pending"),
                          ),
                        );
                      }

                      // Perform edit operation for the entry
                      // You can navigate to an edit screen or show a dialog
                      // to allow the user to modify the entry.
                      // Example: navigate to EditEntryScreen(entry);
                    },
                  ),
                ],
              ),
            );
          },
        );
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
    String? uid = context.read<AuthProvider>().getCurrentUser()?.uid;
    print('this is the uid: $uid');

    return FutureBuilder<bool>(
      future: context.read<EntryListProvider>().isQuarantined(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the future is in progress
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle the error case
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          // Future completed successfully
          bool isQuarantined = snapshot.data ?? false;
          print('THIS IS THE BOOLEAN $isQuarantined');

          return Scaffold(
            // drawer: Drawer(child: Text('Drawer')),
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 0, 37, 67),
              automaticallyImplyLeading: false,
              // actions: [
              //   TextButton(
              //     onPressed: () {
              //       print('pessed logout');
              //       context.read<AuthProvider>().signOut();
              //       Navigator.pop(context);
              //     },
              //     child: Text('Logout'),
              //     style: TextButton.styleFrom(
              //       primary: Colors.white,
              //       textStyle: TextStyle(fontSize: 16),
              //     ),
              //   ),
              // ],
              // title: Text(isQuarantined ? "Quarantined!" : "Not Quarantined"),
              title: Text("User's "),
            ),
            body: entryList(context, _selectedIndex),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 0, 37, 67),
              onPressed: () {
                // Navigator.pushNamed(context, '/entryform');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EntryForm()),
                );
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
              selectedItemColor: Color.fromARGB(255, 255, 255, 255),
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}
