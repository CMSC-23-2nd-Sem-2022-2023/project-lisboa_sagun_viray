import 'package:cmsc23_project/models/user_model.dart';
import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewStudents extends StatefulWidget {
  const ViewStudents({super.key});

  @override
  _ViewStudentsState createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
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
            context.read<EntryListProvider>().getAllStudents();

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

          return Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                UserRecord user = UserRecord.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>,
                );
                return Container(
                  height: 80,
                  child: Card(
                    elevation: 9,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  title: Center(
                                      child: Text(
                                    '${user.name}\'s DETAILS',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  content: Container(
                                    width: 200,
                                    height: 330,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "Name: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child: Text(user.name),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "Student Number: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child:
                                                  Text(user.studno.toString()),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "Email: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child: Text(user.email),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "College: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child:
                                                  Text(user.college.toString()),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "Course: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child:
                                                  Text(user.course.toString()),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  title: Center(
                                                      child: Text(
                                                    'PROMOTE TO ADMIN',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                  content: Text(
                                                      'Are you sure you want to promote this user to admin?'),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  0,
                                                                  67,
                                                                  19),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          context
                                                              .read<
                                                                  EntryListProvider>()
                                                              .turnToAdmin(user
                                                                  .id); // Close the dialog
                                                          // Perform the promotion logic here
                                                        },
                                                        child: Text("PROMOTE")),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 0, 37, 67),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: Text('CANCEL'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('PROMOTE TO ADMIN'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromARGB(255, 0, 37, 67),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20), // Set the border radius
                                            ),
                                            minimumSize: Size(200,
                                                50), // Set the minimum size of the button
                                            padding: EdgeInsets.all(
                                                20), // Set the padding around the button
                                            // You can customize other properties like background color, text style, etc.
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  title: Center(
                                                      child: Text(
                                                    'PROMOTE TO MONITOR',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                  content: Text(
                                                      'Are you sure you want to promote this student to monitor?'),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 0, 67, 19),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                        context
                                                            .read<
                                                                EntryListProvider>()
                                                            .turnToMonitor(user
                                                                .id); // Perform the promotion logic here
                                                      },
                                                      child: Text('PROMOTE'),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 0, 37, 67),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: Text('CANCEL'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('PROMOTE TO MONITOR'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromARGB(255, 0, 67, 19),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20), // Set the border radius
                                            ),
                                            minimumSize: Size(200,
                                                50), // Set the minimum size of the button
                                            padding: EdgeInsets.all(
                                                20), // Set the padding around the button
                                            // You can customize other properties like background color, text style, etc.
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  title: Center(
                                                      child: Text(
                                                    'PUT IN QUARANTINE',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                  content: Text(
                                                      'Are you sure you want to put this student into quarantine?'),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 0, 67, 19),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        context
                                                            .read<
                                                                EntryListProvider>()
                                                            .addToQuarantine(user
                                                                .id); // Close the dialog
                                                        // Perform the promotion logic here
                                                      },
                                                      child: Text('QUARANTINE'),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 0, 37, 67),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: Text('CANCEL'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('PUT IN QUARANTINE'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromARGB(255, 67, 0, 0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20), // Set the border radius
                                            ),
                                            minimumSize: Size(200,
                                                50), // Set the minimum size of the button
                                            padding: EdgeInsets.all(
                                                20), // Set the padding around the button
                                            // You can customize other properties like background color, text style, etc.
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "GO BACK",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 0, 37, 67)),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: ListTile(
                          title: Text(
                            'user.name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "Student number: " + user.studno.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 0, 37, 67),
                            child: Text((index + 1).toString()),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );

          // return Center();
        });
  }

  Scaffold displayScaffold(
      BuildContext context, Stream<QuerySnapshot<Object?>> studentStream) {
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
        // title: Text("Admin Dashboard"),
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
