import 'package:app/helpers/helpers.dart';
import 'package:app/models/category.dart';
import 'package:app/router.dart';
import 'package:app/widgets/server_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryBubble extends StatelessWidget {
  final List<Category> categories;
  const CategoryBubble({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 280,
      padding: const EdgeInsets.only(right: 10),
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 1.2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                Routes.categoryProducts,
                arguments: {
                  'categoryId': category.id,
                  'categoryName': category.name,
                },
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ServerImage(
                      url: Helpers.getServerImage(category.image),
                      fit: BoxFit.cover,
                      backgroundColor: Colors.transparent,
                      boxShape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 35,
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
