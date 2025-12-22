import 'package:app/controllers/address_controller.dart';
import 'package:app/controllers/auth_controller.dart';
import 'package:app/models/address.dart';
import 'package:app/router.dart';
import 'package:app/widgets/app_dialog.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressContainer extends StatelessWidget {
  final Address address;
  const AddressContainer({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>().user;
    final addressController = Get.find<AddressController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: address.isDefault
            ? Border.all(color: Colors.blue.shade600, width: 1.5)
            : Border.all(color: Colors.grey.withValues(alpha: 0.5), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                _getTypeLabel(address.addressType ?? 'لايوجد'),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (!address.isDefault)
                TextButton(
                  onPressed: () async {
                    await showCupertinoDialogBox(
                      context: context,
                      title: 'تعيين كافتراضي',
                      message: 'هل أنت متأكد من تعيين هذا العنوان كافتراضي؟',
                      onConfirm: () async {
                        addressController.makeDefault(address.id);
                      },
                      confirmText: 'نعم',
                      cancelText: 'لا',
                    );
                  },
                  child: Text(
                    'افتراضي',
                    style: TextStyle(color: Colors.blue, fontSize: 11),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.mapModal, arguments: address);
                },
                child: Text(
                  'تعديل',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await showCupertinoDialogBox(
                    context: context,
                    title: 'حذف العنوان',
                    message: 'هل أنت متأكد من حذف هذا العنوان؟',
                    onConfirm: () async {
                      addressController.deleteAddress(address.id);
                    },
                    confirmText: 'نعم',
                    cancelText: 'لا',
                  );
                },
                child: Text(
                  'حذف',
                  style: TextStyle(
                    color: Colors.redAccent.shade400,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 0.5, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          _buildInfoRow('الاسم', auth.value?.name ?? 'غير معروف'),
          _buildInfoRow('الشارع', address.street),
          _buildInfoRow('المدينة', address.city),
          const SizedBox(height: 5),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  'الهاتف',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: flutter.TextDirection.ltr,
                  child: Text(
                    address.altPhone ?? auth.value?.phone ?? 'غير معروف',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                    textAlign: flutter.TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              info,
              style: TextStyle(fontSize: 13, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'home':
        return 'المنزل';
      case 'work':
        return 'العمل';
      case 'other':
        return 'أخرى';
      default:
        return 'غير معروف';
    }
  }
}
