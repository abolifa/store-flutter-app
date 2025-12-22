import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final String title;
  final List<Widget>? actions;
  final bool? centerTitle;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double? fontSize;
  final bool? isBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.fontSize,
    this.isBackButton,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontSize: fontSize ?? 20, fontWeight: FontWeight.w600),
      ),
      actions: actions,
      centerTitle: centerTitle ?? true,
      leading: leading,
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.grey.shade800,
      elevation: elevation,
      automaticallyImplyLeading: isBackButton ?? true,
      scrolledUnderElevation: 0.0,
    );
  }
}
