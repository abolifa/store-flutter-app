import 'package:app/helpers/helpers.dart';
import 'package:app/models/brand.dart';
import 'package:app/router.dart';
import 'package:app/widgets/server_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandsWidget extends StatelessWidget {
  final List<Brand> brands;
  const BrandsWidget({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تسوق حسب الماركة',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.brands);
                  },
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Brands grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
              ),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      Routes.brandProducts,
                      arguments: {'brandId': brand.id, 'brandName': brand.name},
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ServerImage(
                              url: Helpers.getServerImage(brand.image ?? ""),
                              fit: BoxFit.contain,
                              backgroundColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                              padding: const EdgeInsets.all(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Brand name
                        Text(
                          brand.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
