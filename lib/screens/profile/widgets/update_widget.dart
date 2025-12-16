import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class UpdateWidget extends StatelessWidget {
  const UpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Icon(Icons.update, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نسخة جديدة!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'نزل أحدث نسخة لتجربة أفضل.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            text: "تحديث",
            onPressed: () {},
            width: 70,
            height: 28,
            textStyle: TextStyle(fontSize: 10),
            borderRadius: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
