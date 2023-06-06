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
import 'package:intl/intl.dart';

class EntranceMonitor extends StatefulWidget {
  const EntranceMonitor({super.key});

  @override
  _EntranceMonitorState createState() => _EntranceMonitorState();
}

class _EntranceMonitorState extends State<EntranceMonitor> {
  List<Entry> entries = [];
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
                entries.add(entry);
                //access entry like 'entry.'
                return ListTile(
                  title: Text(
                    entry.date + " ENTRY",
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

  Future<bool> checkConditions(String UID) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    bool today = false;
    bool isUnderQuarantine =
        await context.read<EntryListProvider>().isQuarantined(UID);
    bool isUnderMonitoring =
        await context.read<EntryListProvider>().isUnderMonitoring(UID);
    for (Entry entry in entries) {
      print(entry.date);
      if (entry.date == formattedDate) {
        today = true;
      }
    }
    if (today == true &&
        isUnderQuarantine == false &&
        isUnderMonitoring == false) {
      print('@@@@@@@@@@@@$today, $isUnderQuarantine, $isUnderMonitoring');
      return true;
    } else {
      print('!!!!!!!!!!!!!!!!$today, $isUnderQuarantine, $isUnderMonitoring');
      return false;
    }
  }

  Widget profileBuilder(String UID) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print('###################$formattedDate');
    Stream<QuerySnapshot> userDocs =
        context.watch<AuthProvider>().getUserDocs(UID);

    return StreamBuilder(
        stream: userDocs,
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() async {
                        bool able = await checkConditions(UID);
                        if (able) {
                          UserRecord user = UserRecord.fromJson(
                              snapshot.data?.docs[0].data()
                                  as Map<String, dynamic>);
                          Map<String, dynamic> message = {
                            'date': formattedDate,
                            'name': user.name,
                            'location': 'Physci'
                          };
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(
                                  child: Text(
                                    'QR CODE GENERATED.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                content: Container(
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: QrImage(
                                      // TODO change the data to an instance of entry, but for that to work
                                      // need to implement getting of entries from stream first
                                      data: message.toString(),
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
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(
                                  child: Text(
                                    'QR CODE CANT BE GENERATED.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                content: Container(
                                  width: 200,
                                  height: 200,
                                  child: Text(
                                    'Either: You dont\'t have an entry for today\nYou are under quarantine\n You are under monitoring',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                        }
                        // _isVisible = !_isVisible;
                      });
                    },
                    child: Text("VIEW BUILDING PASS"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 0, 37, 67),
                      ),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
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
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
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
          // return Center();
        });
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
      return profileBuilder(UID);
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
        title: Text("Viewing as Entrance Monitor"),
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
