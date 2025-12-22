import 'package:app/controllers/auth_controller.dart';
import 'package:app/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      final isAuthenticated = auth.isAuthenticated.value;
      final menu = [
        {
          'title': 'حسابي',
          'children': [
            {
              'title': 'العناوين',
              'icon': LucideIcons.mapPin300,
              'action': () => {Get.toNamed(Routes.addressScreen)},
              'auth': true,
            },
            {
              'title': 'الدفع',
              'icon': LucideIcons.creditCard300,
              'action': () {},
              'auth': true,
            },
            {
              'title': 'كود QR',
              'icon': LucideIcons.qrCode300,
              'action': () => {Get.toNamed(Routes.qrCodeScreen)},
              'auth': true,
            },
          ],
        },
        {
          'title': 'الإعدادات',
          'children': [
            {
              'title': 'اللغة',
              'icon': LucideIcons.languages300,
              'action': (BuildContext ctx) {},
              'auth': false,
            },
            {
              'title': 'الإشعارات',
              'icon': LucideIcons.bell300,
              'action': () {},
              'auth': false,
            },
            {
              'title': 'إعدادات الأمان',
              'icon': LucideIcons.shield300,
              'action': () => {},
              'auth': true,
            },
            {
              'title': 'سياسة الخصوصية',
              'icon': LucideIcons.fileLock300,
              'action': () => {
                Get.toNamed(
                  Routes.staticPage,
                  arguments: {
                    'title': 'سياسة الخصوصية',
                    'settingKey': 'privacy_policy',
                  },
                ),
              },
              'auth': false,
            },
            {
              'title': 'شروط الخدمة',
              'icon': LucideIcons.fileText300,
              'action': () {
                Get.toNamed(
                  Routes.staticPage,
                  arguments: {
                    'title': 'شروط الخدمة',
                    'settingKey': 'terms_conditions',
                  },
                );
              },
              'auth': false,
            },
            {
              'title': 'حول التطبيق',
              'icon': LucideIcons.info300,
              'action': () {
                Get.toNamed(
                  Routes.staticPage,
                  arguments: {'title': 'حول التطبيق', 'settingKey': 'about_us'},
                );
              },
              'auth': false,
            },
            {
              'title': 'مساعدة',
              'icon': LucideIcons.handHelping300,
              'action': () {},
              'auth': false,
            },
          ],
        },
      ];

      final filteredMenu = menu
          .map((section) {
            final children = (section['children'] as List)
                .where((item) => !(item['auth'] as bool) || isAuthenticated)
                .toList();
            return {'title': section['title'], 'children': children};
          })
          .where((section) => (section['children'] as List).isNotEmpty)
          .toList();

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredMenu.length,
        separatorBuilder: (_, __) => const SizedBox(height: 25),
        itemBuilder: (context, index) {
          final section = filteredMenu[index];
          final children = section['children'] as List;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  section['title'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: children.length,
                  separatorBuilder: (_, __) => Divider(
                    thickness: 0.4,
                    height: 1,
                    color: Colors.grey.shade300,
                    indent: 10,
                    endIndent: 10,
                  ),
                  itemBuilder: (context, idx) {
                    final item = children[idx];
                    return ListTile(
                      leading: Icon(
                        item['icon'] as IconData,
                        size: 25,
                        color: Colors.grey.shade600,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          if (item['secondary'] != null)
                            Text(
                              item['secondary'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                        ],
                      ),
                      trailing: Icon(LucideIcons.chevronLeft300, size: 16),
                      onTap: () {
                        final action = item['action'];
                        if (action is void Function(BuildContext)) {
                          action(context);
                        } else if (action is void Function()) {
                          action();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
