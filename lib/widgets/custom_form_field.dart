import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final int maxLines;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool noBorder;
  final bool isDense;
  final FloatingLabelBehavior floatingLabelBehavior;
  final double? height;
  final bool? enabled;

  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.maxLines = 1,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.fillColor,
    this.contentPadding,
    this.noBorder = false,
    this.isDense = false,
    this.floatingLabelBehavior = FloatingLabelBehavior.never,
    this.height,
    this.enabled,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.borderRadius ?? 8.0);

    final OutlineInputBorder enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: widget.noBorder
          ? BorderSide.none
          : BorderSide(
              color: widget.borderColor ?? Colors.grey.shade300,
              width: widget.borderWidth ?? 1.0,
            ),
    );

    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: widget.noBorder
          ? BorderSide.none
          : BorderSide(
              color: widget.borderColor ?? Colors.black87,
              width: widget.borderWidth ?? 1.2,
            ),
    );

    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: widget.noBorder
          ? BorderSide.none
          : BorderSide(color: Colors.red.shade600, width: 1.2),
    );

    final OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: widget.noBorder
          ? BorderSide.none
          : BorderSide(color: Colors.red.shade700, width: 1.4),
    );

    final contentPadding =
        widget.contentPadding ??
        EdgeInsets.symmetric(
          vertical: (widget.height != null)
              ? (widget.height! / 3.5).clamp(8, 24)
              : 15.0,
          horizontal: 10.0,
        );

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscure : false,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      style: const TextStyle(fontSize: 15.0, color: Colors.black87),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
        errorStyle: const TextStyle(fontSize: 11.0, height: 1.7),
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        filled: widget.fillColor != null,
        fillColor: widget.fillColor,
        contentPadding: contentPadding,
        isDense: widget.isDense,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, size: 20)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.lock : Icons.lock_open,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}
