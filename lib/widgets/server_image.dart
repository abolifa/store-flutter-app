import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServerImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final BoxShape boxShape;
  final EdgeInsetsGeometry? padding;

  const ServerImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
    this.border,
    this.boxShadow,
    this.boxShape = BoxShape.rectangle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = url != null && url!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: url!,
            width: width,
            height: height,
            fit: fit,
            placeholder: (_, __) =>
                placeholder ??
                Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CupertinoActivityIndicator(radius: 10),
                  ),
                ),
            errorWidget: (_, __, ___) =>
                errorWidget ??
                const Icon(Icons.broken_image, color: Colors.grey),
          )
        : (errorWidget ??
              const Icon(Icons.image_not_supported, color: Colors.grey));

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
        border: border,
        boxShadow: boxShadow,
        shape: boxShape,
        borderRadius: boxShape == BoxShape.circle
            ? null
            : (borderRadius ?? BorderRadius.zero),
      ),
      child: ClipRRect(
        borderRadius: boxShape == BoxShape.circle
            ? BorderRadius.circular(9999) // دائري كامل
            : (borderRadius ?? BorderRadius.zero),
        child: imageWidget,
      ),
    );
  }
}
