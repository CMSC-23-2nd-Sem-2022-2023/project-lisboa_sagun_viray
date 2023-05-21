import 'package:flutter/material.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({super.key});

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formkey = GlobalKey<FormState>;

  bool hyperIsChecked = false;
  bool diabetesIsChecked = false;
  bool tbIsChecked = false;
  bool cancerIsChecked = false;
  bool kidneyIsChecked = false;
  bool cardiacIsChecked = false;
  bool autoIsChecked = false;
  bool asthmaIsChecked = false;
  bool allergyIsChecked = false;

  Widget preExistingIllness() {
    return Column(
      children: [
        CheckboxListTile(
          value: hyperIsChecked,
          onChanged: (value) {
            setState(() {
              hyperIsChecked = !hyperIsChecked;
            });
          },
          title: Text('Hypertension'),
        ),
        CheckboxListTile(
          value: diabetesIsChecked,
          onChanged: (value) {
            setState(() {
              diabetesIsChecked = !diabetesIsChecked;
            });
          },
          title: Text('Diabetes'),
        ),
        CheckboxListTile(
          value: tbIsChecked,
          onChanged: (value) {
            setState(() {
              tbIsChecked = !tbIsChecked;
            });
          },
          title: Text('Tuberculosis'),
        ),
        CheckboxListTile(
          value: cancerIsChecked,
          onChanged: (value) {
            setState(() {
              cancerIsChecked = !cancerIsChecked;
            });
          },
          title: Text('Cancer'),
        ),
        CheckboxListTile(
          value: kidneyIsChecked,
          onChanged: (value) {
            setState(() {
              kidneyIsChecked = !kidneyIsChecked;
            });
          },
          title: Text('Kidney Disease'),
        ),
        CheckboxListTile(
          value: autoIsChecked,
          onChanged: (value) {
            setState(() {
              autoIsChecked = !autoIsChecked;
            });
          },
          title: Text('Autoimmune Disease'),
        ),
        CheckboxListTile(
          value: asthmaIsChecked,
          onChanged: (value) {
            setState(() {
              asthmaIsChecked = !asthmaIsChecked;
            });
          },
          title: Text('Asthma'),
        ),
        CheckboxListTile(
          value: allergyIsChecked,
          onChanged: (value) {
            setState(() {
              allergyIsChecked = !allergyIsChecked;
            });
          },
          title: Text('Allergies'),
        ),
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
                children: [preExistingIllness()],
              ),
            ),
          ],
        ));
  }
}
