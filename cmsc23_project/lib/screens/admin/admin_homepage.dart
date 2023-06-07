import 'package:cmsc23_project/screens/admin/admin_quarantined.dart';
import 'package:cmsc23_project/screens/admin/admin_requests.dart';
import 'package:cmsc23_project/screens/admin/admin_students.dart';
import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminRequests()));
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuarantinedStudents()));
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuarantinedStudents()));
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
                          Icons.coronavirus,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 0, 13, 47),
            ),
            child: Icon(
              Icons.person,
              size: 50,
              color: Color.fromARGB(255, 252, 253, 255),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "LASTNAME, FIRSTNAME MIDDLENAME",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(
            "type of User: ADMIN",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          // Visibility(
          //   visible: _isVisible,
          //   child: QrImage(
          //     // TODO change the data to an instance of entry, but for that to work
          //     // need to implement getting of entries from stream first
          //     data: entry.toJson(entry).toString(),
          //     version: QrVersions.auto,
          //     size: 200.0,
          //   ),
          // ),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  // _isVisible = !_isVisible;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(
                          child: Text(
                            'QR CODE GENERATED.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        content: Container(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: Text("QR"),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                });
              },
              child: Text("VIEW BUILDING PASS"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 0, 37, 67),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<StadiumBorder>(
                  const StadiumBorder(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 67, 0, 0),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<StadiumBorder>(
                  const StadiumBorder(),
                ),
              ),
              onPressed: () {
                context.read<AuthProvider>().signOut();
                Navigator.pop(context);
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.exit_to_app), Text("LOGOUT")],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget hasContactWidget(entry) {
    for (int i = 0; i < entry.symptoms.length; i++) {
      if (entry.symptoms[i] == true) {
        // print("hey");
        return Row(
          children: [
            Center(
              child: Text(
                "Has Symptoms: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text("TRUE"),
            )
          ],
        );
        break;
      } else {
        // print("hello");
        return Row(
          children: [
            Center(
              child: Text(
                "has Symptoms: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text("FALSE"),
            )
          ],
        );
      }
    }
    return Text("back to u hey");
    return Row(
      children: [
        Center(
          child: Text(
            "has Symptoms: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text("FALSE"),
        )
      ],
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

          return Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  Entry entry = Entry.fromJson(snapshot.data?.docs[index].data()
                      as Map<String, dynamic>);
                  //access entry like 'entry.'
                  return SizedBox(
                    height: 80,
                    child: Card(
                      elevation: 9,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Center(
                        child: ListTile(
                          onTap: () {
                            print(entry.symptoms);
                            // hasContactWidget(entry);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    title: Center(
                                        child: Text(
                                      'ENTRY DETAILS',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    content: Container(
                                      width: 200,
                                      height: 80,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Center(
                                                child: Text(
                                                  "Date Submitted: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Center(
                                                child: Text(entry.date),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Center(
                                                child: Text(
                                                  "Has Contact: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Center(
                                                child: Text(entry.hasContact
                                                    .toString()
                                                    .toUpperCase()),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Center(
                                                child: Text(
                                                  "Status: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                    entry.status.toString()),
                                              )
                                            ],
                                          ),
                                          hasContactWidget(entry),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromARGB(255, 0, 37, 67),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("CLOSE")),
                                    ],
                                  );
                                });
                          },
                          dense: false,
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 0, 37, 67),
                            child: Text((index + 1).toString()),
                          ),
                          title: Text(
                            entry.date + " ENTRY",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                        ),
                      ),
                    ),
                  );
                }),
          );
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 0, 37, 67),
        automaticallyImplyLeading: false,
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       print('pressed logout');
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
        // title: Center(
        //     child: Text("ADMIN VIEW",
        //         style: TextStyle(fontWeight: FontWeight.bold))),
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
