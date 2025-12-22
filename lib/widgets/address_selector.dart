import 'package:app/controllers/address_controller.dart';
import 'package:app/models/address.dart';
import 'package:app/router.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddressSelector extends StatelessWidget {
  AddressSelector({super.key});

  final AddressController addressCtrl = Get.find<AddressController>();

  void _openAddressSheet(BuildContext context) async {
    final Address? result = await showModalBottomSheet<Address>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                _header(context),
                Expanded(
                  child: Obx(() {
                    if (addressCtrl.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final addresses = addressCtrl.addresses;

                    if (addresses.isEmpty) {
                      return _emptyState();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(15),
                      itemCount: addresses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final addr = addresses[index];
                        final isSelected =
                            addressCtrl.selectedAddress.value?.id == addr.id;

                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => Navigator.pop(context, addr),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.green.withValues(alpha: 0.06)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _icon(isSelected),
                                const SizedBox(width: 12),
                                Expanded(child: _addressText(addr, isSelected)),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                _addNewButton(),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      addressCtrl.selectAddress(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final addr = addressCtrl.selectedAddress.value;

      final label = addr == null
          ? 'اختر عنوان التوصيل'
          : '${addr.street}, ${addr.city}';

      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openAddressSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('تغيير', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'اختر عنوان التوصيل',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _icon(bool selected) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: selected ? Colors.green : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.location_on, color: Colors.white, size: 20),
    );
  }

  Widget _addressText(Address addr, bool selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          addr.addressType ?? 'عنوان',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.green : Colors.black,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${addr.landmark}, ${addr.street}, ${addr.city}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 60),
          const SizedBox(height: 10),
          const Text('لا توجد عناوين'),
          const SizedBox(height: 20),
          CustomButton(
            text: 'إضافة عنوان جديد',
            icon: Icon(LucideIcons.plus300),
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.mapModal);
            },
          ),
        ],
      ),
    );
  }

  Widget _addNewButton() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: CustomButton(
        width: double.infinity,
        height: 48,
        text: 'إضافة عنوان جديد',
        icon: Icon(LucideIcons.plus300),
        onPressed: () {
          Get.back();
          Get.toNamed(Routes.mapModal);
        },
      ),
    );
  }
}
