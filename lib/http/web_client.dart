import 'dart:convert';
import 'package:bytebank/http/logging_interceptor.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

final Client client =
    InterceptedClient.build(interceptors: [LoggingInterceptor()]);
const String baseUrl = 'http://192.168.15.107:8080/transactions';

Future<List<Transaction>> getAllTransactions() async {
  final Response response = await client.get(Uri.parse(baseUrl));
  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transaction> transactions = [];
  _handleResponse(decodedJson, transactions);
  return transactions;
}

void _handleResponse(
    List<dynamic> decodedJson, List<Transaction> transactions) {
  for (Map<String, dynamic> element in decodedJson) {
    final Transaction transaction = Transaction(
        element['value'],
        Contact(0, element['contact']['name'],
            element['contact']['accountNumber']));
    transactions.add(transaction);
  }
}

Future<Transaction> saveTransaction(Transaction transaction) async {
  final Map<String, dynamic> transactionMap = {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber
    }
  };

  final String transactionJson = jsonEncode(transactionMap);

  final Response response = await client.post(Uri.parse(baseUrl),
      headers: {'Content-type': 'application/json', 'password': '1000'},
      body: transactionJson);

  Map<String, dynamic> json = jsonDecode(response.body);
  return Transaction(json['value'],
      Contact(0, json['contact']['name'], json['contact']['accountNumber']));
}
