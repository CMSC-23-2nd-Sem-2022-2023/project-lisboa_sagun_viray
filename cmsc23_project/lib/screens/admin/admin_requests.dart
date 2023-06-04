import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminRequests extends StatefulWidget {
  const AdminRequests({super.key});

  @override
  _AdminRequestsState createState() => _AdminRequestsState();
}

class _AdminRequestsState extends State<AdminRequests> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthProvider>().fetchAuthentication();
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;
    print(userStream);
    // Stream<QuerySnapshot> entriesStream =
    //     context.watch<EntryListProvider>()._myEntriesStream;

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
          print("snapshot has no data");
          return const AdminLoginPage();
        }
        print("user currently logged in: ${snapshot.data!.uid}");
        // String crrntlogged = snapshot.data!.uid;

        Stream<QuerySnapshot> entriesStream =
            context.read<EntryListProvider>().getAllPendingEntries();

        return displayScaffold(context, entriesStream);
      },
    );
  }

  Widget entriesBuilder(Stream<QuerySnapshot> entriesStream) {
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
              return ListTile(
                title: Text(
                  'entry id:${entry.id} has status: ${entry.status!}',
                ),
                leading: Text(
                  entry.date,
                ),
                trailing: TextButton(
                  onPressed: () {
                    if (entry.status == 'clone') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Approve Edit'),
                            content: Text(
                                'Are you sure you want to approve this edit?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  context
                                      .read<EntryListProvider>()
                                      .adminReplaceEntry(
                                          entry.replacementId, entry.id);
                                },
                                child: Text('Approve'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Entry'),
                            content: Text(
                                'Are you sure you want to delete this entry?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  context
                                      .read<EntryListProvider>()
                                      .adminDelete(entry.id);
                                },
                                child: Text('Delete'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Approve'),
                ),
              );
            },
          );

          // return Center();
        });
  }

  Scaffold displayScaffold(
      BuildContext context, Stream<QuerySnapshot<Object?>> entriesStream) {
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
        child: entriesBuilder(entriesStream),
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
