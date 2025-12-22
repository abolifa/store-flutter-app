import 'package:app/controllers/address_controller.dart';
import 'package:app/helpers/helpers.dart';
import 'package:app/models/address.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressForm extends StatefulWidget {
  final Address? address;
  final Map<String, dynamic>? prefilled;

  const AddressForm({super.key, this.address, this.prefilled});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final AddressController controller = Get.find<AddressController>();

  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController postalCodeController;
  late TextEditingController landmarkController;
  late TextEditingController altPhoneController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  String addressType = 'home';
  bool isDefault = false;

  bool get isEditing => widget.address != null && widget.address!.id != 0;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};
    final data = args['address'] ?? widget.address;
    final prefill = args['prefilled'] ?? widget.prefilled ?? {};

    streetController = TextEditingController(
      text: prefill['street'] ?? data?.street ?? '',
    );
    cityController = TextEditingController(
      text: prefill['city'] ?? data?.city ?? '',
    );
    stateController = TextEditingController(
      text: prefill['state'] ?? data?.state ?? '',
    );
    postalCodeController = TextEditingController(
      text: prefill['postal_code'] ?? data?.postalCode ?? '',
    );
    landmarkController = TextEditingController(
      text: prefill['landmark'] ?? data?.landmark ?? '',
    );
    altPhoneController = TextEditingController(
      text: prefill['alt_phone'] ?? data?.altPhone ?? '',
    );
    latitudeController = TextEditingController(
      text: prefill['latitude']?.toString() ?? data?.latitude.toString() ?? '',
    );
    longitudeController = TextEditingController(
      text:
          prefill['longitude']?.toString() ?? data?.longitude.toString() ?? '',
    );

    addressType = prefill['address_type'] ?? data?.addressType ?? 'home';
    isDefault = prefill['is_default'] ?? data?.isDefault ?? false;
  }

  @override
  void dispose() {
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    landmarkController.dispose();
    altPhoneController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      'address_type': addressType,
      'street': streetController.text.trim(),
      'city': cityController.text.trim(),
      'state': stateController.text.trim().isEmpty
          ? null
          : stateController.text.trim(),
      'postal_code': postalCodeController.text.trim().isEmpty
          ? null
          : postalCodeController.text.trim(),
      'landmark': landmarkController.text.trim().isEmpty
          ? null
          : landmarkController.text.trim(),
      'alt_phone': altPhoneController.text.trim().isEmpty
          ? null
          : altPhoneController.text.trim(),
      'latitude': double.parse(latitudeController.text),
      'longitude': double.parse(longitudeController.text),
      'is_default': isDefault,
    };

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final success = isEditing
        ? await controller.updateAddress(widget.address!.id, payload)
        : await controller.addAddress(payload);

    Get.back();
    Get.back();

    if (!mounted) return;

    if (success) {
      Helpers.showToast(
        context,
        isEditing ? 'update_success' : 'create_success',
        ToastType.success,
      );
      await controller.fetchAddresses();
      Get.back();
    } else {
      Helpers.showToast(
        context,
        controller.error.value ?? 'error_occurred',
        ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: isEditing ? 'تعديل العنوان' : 'إضافة عنوان'),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildTypeSelector(),
                const SizedBox(height: 10),
                _buildDefaultToggle(),
                const SizedBox(height: 10),
                _buildFields(),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
          left: 20,
          right: 20,
          top: 10,
        ),
        child: CustomButton(
          text: isEditing ? 'تحديث العنوان' : 'حفظ العنوان',
          onPressed: _saveAddress,
          height: 50,
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'نوع العنوان',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'home', label: Text('المنزل')),
              ButtonSegment(value: 'work', label: Text('العمل')),
            ],
            selected: {addressType},
            onSelectionChanged: (v) => setState(() => addressType = v.first),
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.white,
              selectedBackgroundColor: Colors.black87,
              selectedForegroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Row(
            children: [
              Switch(
                value: isDefault,
                onChanged: (v) => setState(() => isDefault = v),
                activeThumbColor: Colors.black87,
                activeTrackColor: Colors.grey.shade300,
              ),
              const SizedBox(width: 10),
            ],
          ),
          const Text(
            'تعيين كعنوان افتراضي',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFields() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          CustomFormField(
            controller: streetController,
            label: 'الشارع',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: cityController,
            label: 'المدينة',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: stateController,
            label: 'المنطقة',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: postalCodeController,
            label: 'الرمز البريدي',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: landmarkController,
            label: 'علامة دالة',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: altPhoneController,
            label: 'هاتف بديل',
            keyboardType: TextInputType.phone,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ],
      ),
    );
  }
}
