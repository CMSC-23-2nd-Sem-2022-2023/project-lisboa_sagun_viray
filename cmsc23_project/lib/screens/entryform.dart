import 'package:flutter/material.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({super.key});

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formkey = GlobalKey<FormState>();

  bool feverIsChecked = false;
  bool feverishIsChecked = false;
  bool painsIsChecked = false;
  bool coldsIsChecked = false;
  bool coughIsChecked = false;
  bool cardiacIsChecked = false;
  bool soreIsChecked = false;
  bool diffofbreathIsChecked = false;
  bool diarrheaIsChecked = false;
  bool tasteIsChecked = false;
  bool smellIsChecked = false;
  bool contact = false;

  static final List<String> choices = ["Yes", "No"];
  String isInContact = choices[0];

  bool contactCheck = true;

  Widget preExistingIllness() {
    return Column(
      children: [
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: feverIsChecked,
          onChanged: (value) {
            setState(() {
              feverIsChecked = !feverIsChecked;
            });
          },
          title: Text('Fever'),
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: feverishIsChecked,
          onChanged: (value) {
            setState(() {
              feverishIsChecked = !feverishIsChecked;
            });
          },
          title: Text('Feeling feverish'),
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: painsIsChecked,
          onChanged: (value) {
            setState(() {
              painsIsChecked = !painsIsChecked;
            });
          },
          title: Text('Muscle or joint pains'),
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: coldsIsChecked,
          onChanged: (value) {
            setState(() {
              coldsIsChecked = !coldsIsChecked;
            });
          },
          title: Text('Colds'),
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: coughIsChecked,
          onChanged: (value) {
            setState(() {
              coughIsChecked = !coughIsChecked;
            });
          },
          title: Text('Cough'),
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: soreIsChecked,
          onChanged: (value) {
            setState(() {
              soreIsChecked = !soreIsChecked;
            });
          },
          title: Text('Sore throat'),
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: diffofbreathIsChecked,
          onChanged: (value) {
            setState(() {
              diffofbreathIsChecked = !diffofbreathIsChecked;
            });
          },
          title: Text('Difficulty of breathing'),
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: diarrheaIsChecked,
          onChanged: (value) {
            setState(() {
              diarrheaIsChecked = !diarrheaIsChecked;
            });
          },
          title: Text('Diarrhea'),
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: tasteIsChecked,
          onChanged: (value) {
            setState(() {
              tasteIsChecked = !tasteIsChecked;
            });
          },
          title: Text('Loss of taste'),
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: smellIsChecked,
          onChanged: (value) {
            setState(() {
              smellIsChecked = !smellIsChecked;
            });
          },
          title: Text('Loss of smell'),
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
              key: _formkey,
              child: Column(
                children: [
                  Text(
                      "Do you have any pre-exisiting illness? Check all that applies."),
                  preExistingIllness(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Have you come in contact with a confirmed COVID-19 case?",
                    style: TextStyle(
                        //TODO add style
                        ),
                  ),
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
                      })
                ],
              ),
            ),
          ],
        ));
  }
}
