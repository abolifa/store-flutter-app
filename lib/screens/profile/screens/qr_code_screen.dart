import 'dart:convert';

import 'package:app/services/api_service.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String? qrImage;
  String? name;
  String? url;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadQrData();
  }

  Future<void> _loadQrData() async {
    try {
      final response = await ApiService.get('/customer/qr');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          qrImage = data['qr'];
          name = data['name'];
          url = data['url'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'فشل تحميل رمز QR (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'حدث خطأ أثناء تحميل الرمز: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildQrWidget(String qrData) {
    if (qrData.startsWith('data:image/svg+xml;base64,')) {
      final base64Data = qrData.split(',').last;
      final svgBytes = base64Decode(base64Data);
      return SvgPicture.memory(svgBytes, width: 230, height: 230);
    } else if (qrData.startsWith('data:image/png;base64,')) {
      final base64Data = qrData.split(',').last;
      final pngBytes = base64Decode(base64Data);
      return Image.memory(pngBytes, width: 230, height: 230);
    } else {
      return const Icon(Icons.error, color: Colors.red, size: 64);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'رمز التعريف الشخصي'),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
            ? Text(errorMessage!, style: const TextStyle(color: Colors.red))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (qrImage != null) _buildQrWidget(qrImage!),
                  const SizedBox(height: 20),
                  const Text(
                    'امسح هذا الرمز في نقطة التسليم لعرض بياناتك',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
      ),
    );
  }
}
