import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imagePath;
  final double? height;
  const EmptyScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.imagePath,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * (height ?? 0.7),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath ?? 'assets/images/no-products.png',
            height: 180,
            width: 180,
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.8),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }
}
