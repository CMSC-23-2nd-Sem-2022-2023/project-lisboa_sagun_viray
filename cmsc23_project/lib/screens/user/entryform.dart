import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({super.key});

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController dateController = TextEditingController();

  static final List<String> choices = ["Yes", "No"];

  List<String> symptoms = [
    'Fever',
    'Feeling feverish',
    'Muscle or joint pains',
    'Cough',
    'Colds',
    'Sore throat',
    'Difficulty of breathing',
    'Diarrhea',
    'Loss of taste',
    'Loss of smell'
  ];

  List<bool> isCheckedList = List<bool>.filled(10, false);

  String isInContact = choices[0];

  bool contactCheck = true;

  Widget formHeader() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return Column(children: [
      SizedBox(
        height: 20,
      ),
      Text(
        'ENTRY FORM',
        style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 37, 67)),
      ),
      Text(
        'Date today: $formattedDate',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 37, 67)),
      ),
      SizedBox(
        height: 20,
      )
    ]);
  }

  Widget symptomsCheckbox() {
    return Column(
      children: [
        Divider(
          thickness: 5,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Do you have any pre-exisiting illness? Check all that applies.",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: symptoms.length,
            physics: const NeverScrollableScrollPhysics(),
            itemExtent: 40,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                activeColor: Color.fromARGB(255, 0, 37, 67),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  symptoms[index],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: isCheckedList[index],
                // saves currently selected radio button
                onChanged: (value) {
                  setState(() {
                    //print(value.toString());
                    // isInContact = value.toString();
                    isCheckedList[index] = !isCheckedList[index];
                  });
                },
              );
            })
      ],
    );
  }

  Widget covidContact() {
    return Column(
      children: [
        Divider(
          thickness: 5,
        ),
        SizedBox(
          height: 10,
        ),
        Text('Have you come in contact with a confirmed COVID-19 case?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: choices.length,
            physics: const NeverScrollableScrollPhysics(),
            itemExtent: 40,
            itemBuilder: (BuildContext context, int index) {
              // all mottos and their radio buttons
              return RadioListTile(
                title: Text(
                  choices[index],
                  style: const TextStyle(
                    color: Color.fromARGB(255, 66, 43, 110),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: choices[index],
                groupValue: isInContact,
                // saves currently selected radio button
                onChanged: (value) {
                  setState(() {
                    //print(value.toString());
                    isInContact = value.toString();
                  });
                },
              );
            }),
      ],
    );
  }

  Widget submitAndResetButtons() {
    return Column(
      children: [
        Divider(
          thickness: 5,
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              Size(double.infinity, 50), // Adjust the width here
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 0, 67, 27)),
            foregroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 0, 67, 27)),
            shape: MaterialStateProperty.all<StadiumBorder>(
              StadiumBorder(),
            ),
          ),
          onPressed: () async {
            // if (_formKey.currentState!.validate()) {
            //   await context.read<AuthProvider>().signIn(
            //         emailController.text.trim(),
            //         passwordController.text.trim(),
            //       );
            // }
          },
          child: Text('SUBMIT ENTRY', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(
          height: 5,
        ),
        ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(
                Size(double.infinity, 50), // Adjust the width here
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 67, 0, 0)),
              foregroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 67, 0, 0)),
              shape: MaterialStateProperty.all<StadiumBorder>(
                StadiumBorder(),
              ),
            ),
            onPressed: () {
              setState(() {
                for (var i = 0; i < isCheckedList.length; i++) {
                  isCheckedList[i] = false;
                }
                isInContact = choices[0];
                Navigator.pop(context);
              });
            },
            child: Text('RESET', style: TextStyle(color: Colors.white))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.read<AuthProvider>().uStream;

    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        print(snapshot.connectionState);
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
            child: Text("snapshot has no data"),
          );
        }

        String UID = snapshot.data!.uid;

        // if user is logged in, display the scaffold containing the streambuilder for the todos
        return displayScaffold(context, UID);
      },
    );
  }

  Scaffold displayScaffold(BuildContext context, String UID) {
    print('$UID is logged in');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 37, 67),
      ),
      //TODO make a form that accepts entries
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        children: [
          formHeader(),
          Form(
            key: _formkey,
            child: Column(
              children: [
                symptomsCheckbox(),
                SizedBox(
                  height: 15,
                ),
                covidContact(),
                submitAndResetButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
