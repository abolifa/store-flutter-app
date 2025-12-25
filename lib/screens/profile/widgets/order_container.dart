import 'package:app/helpers/helpers.dart';
import 'package:app/models/order.dart';
import 'package:app/router.dart';
import 'package:app/widgets/dev.dart';
import 'package:app/widgets/server_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderContainer extends StatelessWidget {
  final Order order;
  const OrderContainer({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.singleOrder, arguments: {'orderId': order.id});
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'طلب',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '#${order.id}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  DateFormat.yMMMd().add_jm().format(order.createdAt),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const Spacer(),
                _buildStoresIcons(order.stores ?? []),
              ],
            ),
            const Dev(),
            const SizedBox(height: 8),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: order.items?.length ?? 0,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = order.items![index];
                return Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${item.quantity} x ${item.productName}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Dev(),
            const SizedBox(height: 8),
            Row(
              spacing: 3,
              children: [
                Text(
                  Helpers.formatPriceFixed(order.total),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'د',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Helpers.getOrderStatusColor(order.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    Helpers.getOrderStatusLabel(order.status),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoresIcons(List<RelatedStore> stores) {
    if (stores.isEmpty) return const SizedBox();

    const double size = 42;
    const double overlap = 22;
    const int maxVisible = 2;

    if (stores.length == 1) {
      return ServerImage(
        url: Helpers.getServerImage(stores.first.store.logo),
        width: size,
        height: size,
        boxShape: BoxShape.circle,
        fit: BoxFit.contain,
      );
    }

    final bool hasExtra = stores.length > maxVisible;
    final int visibleCount = hasExtra ? maxVisible - 1 : stores.length;
    final int extraCount = stores.length - visibleCount;

    return SizedBox(
      height: size,
      width: size + (visibleCount) * overlap,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          for (int i = 0; i < visibleCount; i++)
            Positioned(
              left: i * overlap,
              child: Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: ServerImage(
                  url: Helpers.getServerImage(stores[i].store.logo),
                  width: size,
                  height: size,
                  boxShape: BoxShape.circle,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          if (hasExtra)
            Positioned(
              left: visibleCount * overlap,
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '+$extraCount',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
