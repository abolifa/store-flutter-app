import 'dart:typed_data';

import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfViewer extends StatelessWidget {
  final Uint8List pdfBytes;
  final int orderId;

  const PdfViewer({super.key, required this.pdfBytes, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'فاتورة طلب #$orderId'),
      body: PdfPreview(
        build: (_) async => pdfBytes,
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
    );
  }
}
