import 'dart:async';

import 'package:app/helpers/perk_icons.dart';
import 'package:app/models/perk.dart';
import 'package:flutter/material.dart';

class PerksWidget extends StatefulWidget {
  final List<Perk>? perks;
  final Duration displayDuration;
  final Duration transitionDuration;
  final double? fontSize;

  const PerksWidget({
    super.key,
    required this.perks,
    this.displayDuration = const Duration(seconds: 4),
    this.transitionDuration = const Duration(milliseconds: 600),
    this.fontSize,
  });

  @override
  State<PerksWidget> createState() => _PerksWidgetState();
}

class _PerksWidgetState extends State<PerksWidget> {
  late final PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1000);

    final perks = widget.perks ?? [];
    if (perks.length > 1) {
      _timer = Timer.periodic(widget.displayDuration, (_) {
        if (!mounted) return;
        _pageController.nextPage(
          duration: widget.transitionDuration,
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final perks = widget.perks ?? [];
    if (perks.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 22,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final perk = perks[index % perks.length];
          final Color iconColor =
              _colorFromHex(perk.color) ?? Colors.grey.shade600;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (perk.icon != null)
                Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PerkIcons.perkIcon(perk.icon),
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              if (perk.icon != null) const SizedBox(width: 4),
              Expanded(
                child: Text(
                  perk.title ?? '',
                  style: TextStyle(
                    fontSize: widget.fontSize ?? 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color? _colorFromHex(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    var formatted = hex.replaceAll('#', '');
    if (formatted.length == 6) formatted = 'FF$formatted';
    return Color(int.tryParse('0x$formatted') ?? 0xFFAAAAAA);
  }
}
