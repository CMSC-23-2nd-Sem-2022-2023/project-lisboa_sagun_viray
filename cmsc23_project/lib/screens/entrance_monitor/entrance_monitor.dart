import 'package:cmsc23_project/screens/entrance_monitor/QR_scanner.dart';
import 'package:cmsc23_project/screens/login/monitor_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../models/user_model.dart';
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
  Entry entry = Entry(
      date: "2023-05-01",
      UID: "3T30G7rbGxOnhHhzDff0Vnb06i82",
      symptoms: [],
      hasContact: false);

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
                  title: Text(
                    entry.date + " Entry",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // leading: Text(entry.date),
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
            height: 10,
          ),
          Text(
            "LASTNAME, FIRSTNAME MIDDLENAME",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
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
          ElevatedButton(
            onPressed: () {
              setState(() {
                // _isVisible = !_isVisible;

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(
                            child: Text(
                          'QR Code Generated.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        content: SizedBox(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: QrImage(
                              // TODO change the data to an instance of entry, but for that to work
                              // need to implement getting of entries from stream first
                              data: entry.toJson(entry).toString(),
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
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
                    });
              });
            },
            child: Text("View Building Pass"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 0, 37, 67)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<StadiumBorder>(
                const StadiumBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  body(int index, Stream<QuerySnapshot> entriesStream, String UID) {
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
    } else if (index == 3) {
      return profileBuilder();
    } else if (index == 2) {
      return entriesBuilder(entriesStream, UID);
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
          return const MonitorLoginPage();
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
        title: Text("Monitor View"),
      ),
      body: body(_selectedIndex, entriesStream, UID),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Students",
            backgroundColor: Color.fromARGB(255, 0, 13, 47),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: "Scan QR",
            backgroundColor: Color.fromARGB(255, 78, 0, 0),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
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
