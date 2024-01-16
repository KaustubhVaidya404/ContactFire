import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:email_validator/email_validator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterContactPicker contactPicker = FlutterContactPicker();
  // List<Contact>? contacts;
  final emailcontroller = TextEditingController();
  final db = FirebaseFirestore.instance;
  static const snackbar1 = SnackBar(content: Text('Number saved'));
  static const snackbar2 = SnackBar(content: Text('Invalid email address'));

  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "ContactFire",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
        child: Column(
          children: [
            TextField(
              controller: emailcontroller,
              decoration:
                  const InputDecoration(hintText: "Enter email address"),
            ),
            const SizedBox(
              height: 25,
            ),
            MaterialButton(
              onPressed: () async {
                Contact? contact = await contactPicker.selectContact();
                setState(() {
                  final text = emailcontroller.text;
                  bool isValid = EmailValidator.validate(text);
                  if (isValid == true) {
                    db.collection('phone').doc(text).set({
                      "contactname": contact!.fullName,
                      "contactnumber": contact.phoneNumbers
                    });
                    ScaffoldMessenger.of(context).showSnackBar(snackbar1);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(snackbar2);
                  }
                });
              },
              color: Colors.deepPurpleAccent,
              child: const Text('Import contact'),
            ),
          ],
        ),
      ),
    );
  }
}
