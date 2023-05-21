import 'package:flutter/material.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({super.key});

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formkey = GlobalKey<FormState>;

  Map<String, bool> illnessList = {
    'Hypertension': false,
    'Diabetes': false,
    'Tuberculosis': false,
    'Cancer': false,
    'Kidney Disease': false,
    'Cardiac Disease': false,
    'Autoimmune Disease': false,
    'Asthma': false,
    'Allergies': false
  };

  Widget preExistingIllness() {
    return Column(
      children: [
        ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: illnessList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                  title: Text(illnessList[illnessList[index]]),
                  value: illnessList[index],
                  onChanged: () {});
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //TODO make a form that accepts entries
        appBar: AppBar(
          title: Text("EntryForm"),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            Form(
              child: Column(
                children: [],
              ),
            ),
          ],
        ));
  }
}
