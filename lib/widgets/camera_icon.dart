import 'dart:convert';
import 'dart:io';

import 'package:app/helpers/constants.dart';
import 'package:app/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class CameraIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final bool upload;
  const CameraIcon({
    super.key,
    required this.icon,
    this.size = 40,
    this.upload = true,
  });

  @override
  State<CameraIcon> createState() => _CameraIconState();
}

class _CameraIconState extends State<CameraIcon>
    with SingleTickerProviderStateMixin {
  bool _isShimmering = true;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _startCycle();
  }

  void _startCycle() async {
    while (mounted) {
      setState(() => _isShimmering = true);
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isShimmering = false);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) return;

      if (widget.upload) {
        setState(() => _isLoading = true);
        await _uploadImage(File(photo.path));
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في فتح الكاميرا: $e',
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final uri = Uri.parse('${Constants.apiUrl}/products/search-by-image');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        Get.snackbar(
          'تم التحليل',
          'تم العثور على ${data["results"].length} منتج مشابه',
          backgroundColor: Colors.green.shade100,
        );
        Get.toNamed(
          Routes.productsByIds,
          arguments: {
            'productIds': List<int>.from(
              data['results'].map((item) => item['id']),
            ),
          },
        );
      } else {
        Get.snackbar(
          'خطأ',
          'فشل التحليل (${response.statusCode})',
          backgroundColor: Colors.red.shade100,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل رفع الصورة: $e',
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 30,
        width: 30,
        child: CupertinoActivityIndicator(radius: 12, color: Colors.black87),
      );
    }

    final icon = Icon(
      widget.icon,
      size: widget.size,
      color: Colors.grey.shade800,
    );

    final shimmered = _isShimmering
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.amber,
            period: const Duration(seconds: 1),
            direction: ShimmerDirection.ltr,
            child: icon,
          )
        : icon;

    return InkWell(
      borderRadius: BorderRadius.circular(widget.size / 2),
      onTap: _openCamera,
      child: shimmered,
    );
  }
}
