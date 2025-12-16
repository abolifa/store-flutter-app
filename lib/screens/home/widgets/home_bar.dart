import 'package:app/widgets/animated_search_hint.dart';
import 'package:app/widgets/facorite_badge_button.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const HomeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(LucideIcons.search300, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SearchHintWidget(
                      hints: [
                        'الهواتف الذكية',
                        'سماعات لاسلكية',
                        'ساعات ذكية',
                        'أجهزة لوحية',
                        'إكسسوارات الكمبيوتر',
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.camera300,
                    color: Colors.grey.shade800,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          FavoriteBadgeButton(),
        ],
      ),
    );
  }
}
