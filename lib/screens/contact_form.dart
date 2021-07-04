import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    throw Scaffold(
      appBar: AppBar(
        title: Text('New contact'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Full name'),
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: TextField(
                controller: _accountNameController,
                decoration: InputDecoration(labelText: 'Account number'),
                style: TextStyle(fontSize: 24.0),
                keyboardType: TextInputType.number),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: () {
                        final String name = _nameController.text;
                        final int? accountNumber =
                            int.tryParse(_accountNameController.text);
                        final Contact contact = Contact(0, name, accountNumber);
                        saveContact(contact)
                            .then((id) => Navigator.pop(context, contact));
                      },
                      child: Text('create'))))
        ],
      ),
    );
  }
}
