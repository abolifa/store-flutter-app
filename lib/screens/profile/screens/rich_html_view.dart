import 'package:app/controllers/settings_controller.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class RichHtmlView extends StatefulWidget {
  final String title;
  final String settingKey;

  const RichHtmlView({
    super.key,
    required this.title,
    required this.settingKey,
  });

  @override
  State<RichHtmlView> createState() => _RichHtmlViewState();
}

class _RichHtmlViewState extends State<RichHtmlView> {
  final SettingsController controller = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    controller.fetchSetting(widget.settingKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }
        final html = controller.singleSetting[widget.settingKey] ?? '';
        if (html.isEmpty) {
          return const Center(child: Text('لا توجد بيانات للعرض'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Html(
              data: html,
              style: {
                "body": Style(
                  fontSize: FontSize(16),
                  lineHeight: LineHeight(1.6),
                ),
                "h1": Style(fontSize: FontSize(24)),
                "h2": Style(fontSize: FontSize(20)),
                "h3": Style(fontSize: FontSize(18)),
                "li": Style(margin: Margins.only(bottom: 6)),
              },
            ),
          ),
        );
      }),
    );
  }
}
