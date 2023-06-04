import 'package:cmsc23_project/models/user_model.dart';
import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuarantinedStudents extends StatefulWidget {
  const QuarantinedStudents({super.key});

  @override
  _QuarantinedStudents createState() => _QuarantinedStudents();
}

class _QuarantinedStudents extends State<QuarantinedStudents> {
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

        Stream<QuerySnapshot> studentStream =
            context.read<EntryListProvider>().getAllQuarantinedStudents();

        return displayScaffold(context, studentStream);
      },
    );
  }

  Widget studentBuilder(Stream<QuerySnapshot> studentStream) {
    return StreamBuilder(
        stream: studentStream,
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
              UserRecord user = UserRecord.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>,
              );
              return ListTile(
                title: Text(
                  'Student number: ${user.studno} - ${user.name}',
                ),
                leading: Text(
                  user.id,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Promote to Admin'),
                              content: Text(
                                  'Are you sure you want to promote this student to admin?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context
                                        .read<EntryListProvider>()
                                        .turnToAdmin(
                                            user.id); // Close the dialog
                                    // Perform the promotion logic here
                                  },
                                  child: Text('Promote'),
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
                      },
                      child: Text('Promote to Admin'),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Promote to Monitor'),
                              content: Text(
                                  'Are you sure you want to promote this student to monitor?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    context
                                        .read<EntryListProvider>()
                                        .turnToMonitor(user
                                            .id); // Perform the promotion logic here
                                  },
                                  child: Text('Promote'),
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
                      },
                      child: Text('Promote to Monitor'),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Put in quarantine'),
                              content: Text(
                                  'Are you sure you want to put this student into quarantine?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    // Perform the promotion logic here
                                  },
                                  child: Text('Promote'),
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
                      },
                      child: Text('Promote to Monitor'),
                    ),
                  ],
                ),
              );
            },
          );

          // return Center();
        });
  }

  Scaffold displayScaffold(
      BuildContext context, Stream<QuerySnapshot<Object?>> studentStream) {
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
        child: studentBuilder(studentStream),
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
