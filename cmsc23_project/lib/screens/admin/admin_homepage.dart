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
              Navigator.pushNamed(context, '/monitor_quarantined');
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
                      children: const [
                        Icon(
                          Icons.device_thermostat,
                          size: 50,
                          color: Color.fromARGB(255, 0, 37, 67),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                            child: Text(
                          "Quarantined Students",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color.fromARGB(255, 0, 37, 67)),
                        ))
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
                      children: const [
                        Icon(
                          Icons.remove_red_eye,
                          size: 50,
                          color: Color.fromARGB(255, 0, 37, 67),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Under Monitoring",
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

    // return ListView(
    //   scrollDirection: Axis.vertical,
    //   //direction: Axis.vertical,
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         const SizedBox(
    //           width: 20,
    //         ),
    //         //1st column of buttons
    //         Column(
    //           children: [

    //             // GridView.count(
    //             //   crossAxisCount: 2,
    //             //   children: [
    //             //     Card(
    //             //       child: Center(child: Text('Item 1')),
    //             //     ),
    //             //     Card(
    //             //       child: Center(child: Text('Item 2')),
    //             //     ),
    //             //     Card(
    //             //       child: Center(child: Text('Item 3')),
    //             //     ),
    //             //     Card(
    //             //       child: Center(child: Text('Item 4')),
    //             //     ),
    //             //   ],
    //             // ),
    //             Card(
    //               color: const Color.fromARGB(255, 185, 105, 36),
    //               clipBehavior: Clip.hardEdge,
    //               shape: const RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(25),
    //                 ),
    //               ),
    //               child: InkWell(
    //                 splashColor:
    //                     const Color.fromARGB(255, 227, 130, 44).withAlpha(20),
    //                 onTap: () {
    //                   //TODO functionality of this card
    //                   //Navigator.push emerut
    //                 },
    //                 child: const SizedBox(
    //                   width: 150,
    //                   height: 200,
    //                   child: Center(
    //                     child: Text(
    //                       "Requests",
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             Card(
    //               clipBehavior: Clip.hardEdge,
    //               color: const Color.fromARGB(255, 245, 247, 245),
    //               shape: const RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(25),
    //                 ),
    //               ),
    //               child: InkWell(
    //                 splashColor: Colors.blue.withAlpha(30),
    //                 onTap: () {
    //                   //TODO functionality of this card
    //                 },
    //                 child: const SizedBox(
    //                   width: 150,
    //                   height: 200,
    //                   child: Center(
    //                     child: Text("All Students"),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         //sizedbox as pading
    //         const SizedBox(
    //           width: 20,
    //         ),
    //         //2nd column of buttons
    //         Column(
    //           children: [
    //             const SizedBox(
    //               height: 50,
    //             ),
    //             Card(
    //               shadowColor: Colors.black54,
    //               clipBehavior: Clip.hardEdge,
    //               color: const Color.fromARGB(255, 245, 247, 245),
    //               shape: const RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(25),
    //                 ),
    //               ),
    //               child: InkWell(
    //                 splashColor: Colors.blue.withAlpha(30),
    //                 onTap: () {
    //                   //TODO functionality of this card
    //                 },
    //                 child: const SizedBox(
    //                   width: 150,
    //                   height: 200,
    //                   child: Center(
    //                     child: Text(
    //                       "Quarantined Students",
    //                       style: TextStyle(color: Colors.black),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             Card(
    //               color: const Color.fromARGB(255, 46, 160, 201),
    //               clipBehavior: Clip.hardEdge,
    //               shape: const RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(25),
    //                 ),
    //               ),
    //               child: InkWell(
    //                 splashColor:
    //                     const Color.fromARGB(255, 46, 160, 201).withAlpha(20),
    //                 onTap: () {
    //                   //TODO functionality of this card
    //                 },
    //                 child: const SizedBox(
    //                   width: 150,
    //                   height: 200,
    //                   child: Center(
    //                     child: Text(
    //                       "Under Monitoring",
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           width: 20,
    //         ),
    //       ],
    //     ),
    //   ],
    // );
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
          // ElevatedButton(onPressed: (){
          //   context.read<AuthProvider>().signOut();
          //   // Navigator.pop(context);
          // }, child: const Text("Log out"))
        ],
      ),
    );
  }

  //builds entries from stream
  Widget entriesBuilder(Stream<QuerySnapshot> entriesStream) {
    return const Center();

    // return StreamBuilder(
    //   stream: entriesStream,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         return Center(
    //           child: Text("Error encountered! ${snapshot.error}"),
    //         );
    //       } else if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else if (!snapshot.hasData) {
    //         return const Center(
    //           child: Text("No Entries Found"),
    //         );
    //       }

    //       return ListView.builder(itemBuilder: itemBuilder);
    //     }
    //   );
  }

  //this function returns a different widget depending on the index of the
  //bottomnav bar
  body(int index, Stream<QuerySnapshot> entriesStream) {
    if (index == 0) {
      return students_buttons();
    } else if (index == 1) {
      if (entries.isEmpty) {
        return const Center(
          child: Text("No entries yet"),
        );
      } else {
        return entriesBuilder(entriesStream);
      }
    } else if (index == 2) {
      return profileBuilder();
    }
  }

  _itemOnTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> entriesStream =
        context.watch<EntryListProvider>().entries;
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;

    return StreamBuilder(
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
          // Navigator.pop(context);
          // print("no data");
        }
        // print("user currently logged in: ${snapshot.data!.uid}");
        //get the uid of current logged in user, then kunin sa admin collection yung data nya
        //then store to an instance of AdminRecord?
        // String crrntlogged = snapshot.data!.uid;
        return displayScaffold(context, entriesStream);
      },
    );
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
        title: Text("Admin View"),
      ),
      body: body(_selectedIndex, entriesStream),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Students",
            backgroundColor: Color.fromARGB(255, 128, 150, 209),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Entries",
            backgroundColor: Color.fromARGB(255, 46, 160, 201),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Color.fromARGB(255, 105, 194, 173),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 0, 37, 67),
        onTap: _itemOnTapped,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 0, 37, 67),
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/entryform');
          }),
    );
  }
}
