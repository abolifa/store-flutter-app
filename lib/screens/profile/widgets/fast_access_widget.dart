import 'package:app/controllers/auth_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FastAccessWidget extends StatelessWidget {
  const FastAccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    final fs = [
      {
        'title': 'الطلبات',
        'slogan': 'إدارة وتتبع',
        'icon': LucideIcons.package200,
      },
      {
        'title': 'المرتجعات',
        'slogan': '0 قيد المراجعة',
        'icon': LucideIcons.refreshCcw200,
      },
      {
        'title': 'رصيد المحفظة',
        'slogan': '0.00 د.ل',
        'icon': LucideIcons.wallet200,
      },
      {'title': 'المفضلة', 'slogan': '0 منتجات', 'icon': LucideIcons.heart200},
    ];

    return Obx(() {
      if (!auth.isAuthenticated.value) {
        return const SizedBox.shrink();
      }
      return SizedBox(
        width: double.infinity,
        height: 202,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.2,
          ),
          itemCount: fs.length,
          itemBuilder: (context, index) {
            final item = fs[index];

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [Constants.boxShadow],
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 36,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['slogan'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
