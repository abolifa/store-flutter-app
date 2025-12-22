import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class NoAddressScreen extends StatelessWidget {
  const NoAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'إنهاء الطلب'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 20),
            Text(
              'لم يتم العثور على عنوان للتوصيل',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: CustomButton(
                    width: 150,
                    height: 45,
                    borderRadius: 50,
                    text: 'عودة',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
