import 'dart:convert';
import 'package:bytebank/http/logging_interceptor.dart';
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
  for (Map<String, dynamic> element in decodedJson) {
    transactions.add(Transaction.fromJson(element));
  }
  return transactions;
}

Future<Transaction> saveTransaction(Transaction transaction) async {
  final String transactionJson = jsonEncode(transaction.toJson());

  final Response response = await client.post(Uri.parse(baseUrl),
      headers: {'Content-type': 'application/json', 'password': '1000'},
      body: transactionJson);

  Map<String, dynamic> json = jsonDecode(response.body);
  return Transaction.fromJson(json);
}
