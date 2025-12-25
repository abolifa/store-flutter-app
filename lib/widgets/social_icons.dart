import 'package:app/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    final settings = controller.settings;

    final socialLinks = [
      {'url': settings.value?.facebookUrl, 'icon': FontAwesomeIcons.facebookF},
      {'url': settings.value?.instagramUrl, 'icon': FontAwesomeIcons.instagram},
      {'url': settings.value?.snapchatUrl, 'icon': FontAwesomeIcons.snapchat},
      {'url': settings.value?.tiktokUrl, 'icon': FontAwesomeIcons.tiktok},
    ];

    final availableLinks = socialLinks
        .where(
          (item) => item['url'] != null && (item['url'] as String).isNotEmpty,
        )
        .toList();

    if (availableLinks.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < availableLinks.length; i++) ...[
          _buildSocialIcon(
            availableLinks[i]['icon'] as IconData,
            availableLinks[i]['url'] as String,
            context,
          ),
          if (i != availableLinks.length - 1) const SizedBox(width: 40),
        ],
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String url, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.tryParse(url);
        if (uri != null) {
          final success = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (!success && context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('لا يمكن فتح الرابط: $url')));
          }
        }
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Icon(icon, size: 22, color: Colors.grey.shade500),
      ),
    );
  }
}
