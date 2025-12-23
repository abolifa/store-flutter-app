import 'dart:async';

import 'package:app/helpers/constants.dart';
import 'package:app/helpers/helpers.dart';
import 'package:app/models/product.dart';
import 'package:app/widgets/product/favorite_button.dart';
import 'package:app/widgets/product/image_light_box.dart';
import 'package:app/widgets/product/share_button.dart';
import 'package:flutter/material.dart';

class ProductImageGallery extends StatefulWidget {
  final Product product;
  final String mainImage;
  final List<String> images;

  const ProductImageGallery({
    super.key,
    required this.product,
    required this.mainImage,
    required this.images,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  late List<String> allImages;
  late PageController pageController;
  Timer? timer;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _buildImages();
    pageController = PageController();
    _startAutoSlide();
  }

  @override
  void didUpdateWidget(covariant ProductImageGallery oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mainImage != widget.mainImage ||
        oldWidget.images != widget.images) {
      _buildImages();
      selectedIndex = 0;
      pageController.jumpToPage(0);
      _restartAutoSlide();
    }
  }

  void _buildImages() {
    allImages = [
      widget.mainImage,
      ...widget.images.where((e) => e != widget.mainImage),
    ];
  }

  void _startAutoSlide() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (allImages.length <= 1) return;

      selectedIndex = (selectedIndex + 1) % allImages.length;

      pageController.animateToPage(
        selectedIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _restartAutoSlide() {
    timer?.cancel();
    _startAutoSlide();
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ImageLightbox(
                  images: allImages,
                  initialIndex: selectedIndex,
                ),
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: allImages.length,
                  onPageChanged: (index) {
                    setState(() => selectedIndex = index);
                    _restartAutoSlide();
                  },
                  itemBuilder: (context, index) {
                    return Image.network(
                      Helpers.getServerImage(allImages[index]),
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: FavoriteButton(productId: widget.product.id),
                ),
                Positioned(
                  top: 55,
                  left: 10,
                  child: ShareButton(
                    productId: widget.product.id,
                    productName: widget.product.name,
                  ),
                ),
                if (widget.product.approvedReviewsCount != null &&
                    widget.product.approvedReviewsCount! > 0)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [Constants.boxShadow],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.green.shade500,
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${widget.product.approvedReviewsAvgRating} (${widget.product.approvedReviewsCount})',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (allImages.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allImages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isActive = index == selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedIndex = index);
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    _restartAutoSlide();
                  },
                  child: Container(
                    width: 72,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isActive
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Image.network(
                      Helpers.getServerImage(allImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
