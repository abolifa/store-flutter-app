import 'package:app/helpers/helpers.dart';
import 'package:app/models/section.dart';
import 'package:app/screens/home/widgets/home_product_container.dart';
import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  final Section section;
  const SectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    if (section.products == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.only(top: 15.0, right: 10.0, bottom: 15.0),
      decoration: BoxDecoration(
        color: section.color != null
            ? Helpers.hexToColor(section.color!)
            : Colors.white,
      ),
      height: 410,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  section.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                if (section.shortDescription != null)
                  Text(
                    section.shortDescription!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: section.products!.length,
              itemBuilder: (context, index) {
                final product = section.products![index];
                return Row(
                  children: [
                    SizedBox(
                      width: 180,
                      child: HomeProductContainer(product: product),
                    ),
                    const SizedBox(width: 5),
                    if (index == section.products!.length - 1)
                      const SizedBox(width: 20),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
