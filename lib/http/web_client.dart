import 'dart:convert';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

// This method uses my local ip to fetch data.
// The api was provided by Alura as a local project
Future<List<Transaction>> getAllTransactions() async {
  final Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);
  final Response response =
      await client.get(Uri.parse('http://192.168.15.133:8080/transactions'));
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

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print(data);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print(data);
    return data;
  }
}
