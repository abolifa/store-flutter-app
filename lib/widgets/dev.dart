import 'package:flutter/material.dart';

class Dev extends StatelessWidget {
  final double? thickness;
  final Color? color;
  const Dev({super.key, this.thickness, this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness ?? 0.4,
      color: color ?? Colors.grey.shade300,
    );
  }
}
