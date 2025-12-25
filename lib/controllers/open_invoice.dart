import 'dart:typed_data';

import 'package:app/helpers/constants.dart';
import 'package:http/http.dart' as http;

Future<Uint8List> fetchInvoicePdf(int orderId) async {
  final uri = Uri.parse('${Constants.baseUrl}/orders/$orderId/invoice');

  final response = await http.get(uri, headers: {'Accept': 'application/pdf'});

  if (response.statusCode != 200) {
    throw Exception(response.statusCode);
  }

  return response.bodyBytes;
}
