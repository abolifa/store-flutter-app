import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final int productId;
  final String productName;

  const ShareButton({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final url = 'https://yourdomain.com/products/$productId';

        await SharePlus.instance.share(
          ShareParams(text: '$productName\n$url', subject: productName),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 35,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 0.7),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(LucideIcons.share2300, color: Colors.grey, size: 20),
      ),
    );
  }
}
