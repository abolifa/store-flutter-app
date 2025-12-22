import 'package:app/controllers/address_controller.dart';
import 'package:app/helpers/helpers.dart';
import 'package:app/screens/profile/widgets/address_container.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final controller = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'عناويني'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return Center(child: Text(controller.error.value!));
        }
        final addresses = controller.addresses;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Column(
            children: [
              CustomButton(
                width: double.infinity,
                height: 40,
                text: 'إضافة عنوان جديد',
                onPressed: () {
                  Helpers.showMapModal(context);
                },
                icon: Icon(LucideIcons.plus),
                borderRadius: 5,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.blue.shade600,
                border: BorderSide(color: Colors.blue.shade600),
              ),
              const SizedBox(height: 10),
              addresses.isEmpty
                  ? const EmptyScreen(
                      title: 'لا توجد عناوين محفوظة',
                      subtitle: 'لم تقم بإضافة أي عنوان بعد',
                      imagePath: 'assets/images/no-address.webp',
                    )
                  : Expanded(
                      child: ListView.separated(
                        itemCount: addresses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final address = addresses[i];
                          return AddressContainer(address: address);
                        },
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}
