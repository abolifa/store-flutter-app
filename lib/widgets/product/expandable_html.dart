import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandableHtml extends StatefulWidget {
  final String html;
  final double collapsedHeight;

  const ExpandableHtml({
    super.key,
    required this.html,
    this.collapsedHeight = 120,
  });

  @override
  State<ExpandableHtml> createState() => _ExpandableHtmlState();
}

class _ExpandableHtmlState extends State<ExpandableHtml>
    with SingleTickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ConstrainedBox(
              constraints: expanded
                  ? const BoxConstraints()
                  : BoxConstraints(maxHeight: widget.collapsedHeight),
              child: Html(
                data: widget.html,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(13),
                    lineHeight: LineHeight.number(1.3),
                  ),
                  "p": Style(margin: Margins.only(bottom: 8)),
                  "ul": Style(margin: Margins.only(left: 16, bottom: 8)),
                  "li": Style(margin: Margins.only(bottom: 6)),
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            text: expanded ? 'عرض أقل' : 'عرض المزيد',
            onPressed: () {
              setState(() => expanded = !expanded);
            },
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.grey.shade800,
            border: BorderSide(color: Colors.grey.shade800),
            height: 38,
          ),
        ],
      ),
    );
  }
}
