import 'dart:async';

import 'package:flutter/material.dart';

class SearchHintWidget extends StatefulWidget {
  final List<String> hints;
  final Duration displayDuration;
  final Duration transitionDuration;
  final double fontSize;

  const SearchHintWidget({
    super.key,
    required this.hints,
    this.displayDuration = const Duration(seconds: 5),
    this.transitionDuration = const Duration(milliseconds: 500),
    this.fontSize = 14,
  });

  @override
  State<SearchHintWidget> createState() => _SearchHintWidgetState();
}

class _SearchHintWidgetState extends State<SearchHintWidget> {
  late final PageController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 1000);

    if (widget.hints.length > 1) {
      _timer = Timer.periodic(widget.displayDuration, (_) {
        if (!mounted) return;
        _controller.nextPage(
          duration: widget.transitionDuration,
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hints.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'ابحث عن ',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: widget.fontSize,
          ),
        ),
        SizedBox(
          width: 150,
          height: widget.fontSize + 4,
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final text = widget.hints[index % widget.hints.length];
              return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: widget.fontSize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
