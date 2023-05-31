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
    return ListView(
      scrollDirection: Axis.vertical,
      //direction: Axis.vertical,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 20,
            ),
            //1st column of buttons
            Column(
              children: [
                Card(
                  color: const Color.fromARGB(255, 185, 105, 36),
                  clipBehavior: Clip.hardEdge,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: InkWell(
                    splashColor:
                        const Color.fromARGB(255, 227, 130, 44).withAlpha(20),
                    onTap: () {
                      //TODO functionality of this card
                      //Navigator.push emerut
                    },
                    child: const SizedBox(
                      width: 150,
                      height: 200,
                      child: Center(
                        child: Text(
                          "Requests",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  clipBehavior: Clip.hardEdge,
                  color: const Color.fromARGB(255, 245, 247, 245),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      //TODO functionality of this card
                    },
                    child: const SizedBox(
                      width: 150,
                      height: 200,
                      child: Center(
                        child: Text("All Students"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //sizedbox as pading
            const SizedBox(
              width: 20,
            ),
            //2nd column of buttons
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Card(
                  shadowColor: Colors.black54,
                  clipBehavior: Clip.hardEdge,
                  color: const Color.fromARGB(255, 245, 247, 245),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      //TODO functionality of this card
                    },
                    child: const SizedBox(
                      width: 150,
                      height: 200,
                      child: Center(
                        child: Text(
                          "Quarantined Students",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  color: const Color.fromARGB(255, 46, 160, 201),
                  clipBehavior: Clip.hardEdge,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: InkWell(
                    splashColor:
                        const Color.fromARGB(255, 46, 160, 201).withAlpha(20),
                    onTap: () {
                      //TODO functionality of this card
                    },
                    child: const SizedBox(
                      width: 150,
                      height: 200,
                      child: Center(
                        child: Text(
                          "Under Monitoring",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ],
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
  Widget entriesBuilder(Stream<QuerySnapshot> entriesStream){
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
    Stream<QuerySnapshot> entriesStream = context.watch<EntryListProvider>().entries;
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
      }else if (!snapshot.hasData){
        Navigator.pop(context);
      }

      return displayScaffold(context, entriesStream);
    },);
  }

  Scaffold displayScaffold(BuildContext context, Stream<QuerySnapshot<Object?>> entriesStream){
      return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Admin View"),
      ),
      body: body(_selectedIndex, entriesStream),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_4),
            label: "Students",
            backgroundColor: Color.fromARGB(255, 201, 115, 39),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Entries",
            backgroundColor: Color.fromARGB(255, 46, 160, 201),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Color(0xfff09819),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _itemOnTapped,
      ),
    );
    }
}
