import 'package:bytebank/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> createDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute('CREATE TABLE contacts('
        'id INTEGER PRIMARY_KEY,'
        'name TEXT, '
        'account_number INTEGER)');
  }, version: 1);
}

Future<int> saveContact(Contact contact) async {
  final Database db = await createDatabase();
  final Map<String, dynamic> contactMap = Map();
  contactMap['id'] = contact.id;
  contactMap['name'] = contact.name;
  contactMap['account_number'] = contact.accountNumber;
  return db.insert('contacts', contactMap);
}

Future<List<Contact>> findAll() async {
  final Database db = await createDatabase();
  final List<Map<String, dynamic>> result = await db.query('contacts');
  final List<Contact> contactsList = List.empty(growable: true);
  for (Map<String, dynamic> tableRow in result) {
    final Contact contact = Contact(
      tableRow['id'],
      tableRow['name'],
      tableRow['account_number'],
    );
    contactsList.add(contact);
  }
  return contactsList;
}
