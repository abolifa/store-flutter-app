import 'package:app/controllers/store_controller.dart';
import 'package:app/helpers/helpers.dart';
import 'package:app/models/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProductSellerWidget extends StatefulWidget {
  final Store store;
  const ProductSellerWidget({super.key, required this.store});

  @override
  State<ProductSellerWidget> createState() => _ProductSellerWidgetState();
}

class _ProductSellerWidgetState extends State<ProductSellerWidget> {
  late final StoreController storeController;

  @override
  void initState() {
    super.initState();
    storeController = Get.isRegistered<StoreController>()
        ? Get.find<StoreController>()
        : Get.put(StoreController(), permanent: false);

    storeController.fetchStorePerks(storeId: widget.store.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.25),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      Helpers.getServerImage(widget.store.logo),
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'البائع',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.store.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey.shade400,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(thickness: 0.4, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Obx(() {
            if (storeController.isLoading.value) {
              return const SizedBox(height: 28);
            }
            final perks = storeController.storePerks.value;
            if (perks == null) {
              return const SizedBox();
            }
            return Row(
              spacing: 12,
              children: [
                _perkChip(LucideIcons.handshake300, 'شريك منذ', perks.since),
                _perkChip(
                  LucideIcons.packageCheck300,
                  'طلبات مؤكدة',
                  perks.confirmedOrders.toString(),
                ),
                _perkChip(
                  LucideIcons.star300,
                  'التقييم',
                  perks.reviewsAverage.toStringAsFixed(1),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _perkChip(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
