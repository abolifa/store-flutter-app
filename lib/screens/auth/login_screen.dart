import 'package:app/controllers/auth_controller.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  final AuthController auth = Get.find<AuthController>();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final phone = _phoneController.text.trim();

    final success = await auth.loginByPhone(phone);
    if (success) {
      Get.back();
    } else {
      Get.closeAllSnackbars();
      Get.snackbar(
        'خطأ',
        auth.error.value,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'مرحباً بك، قم بتسجيل الدخول',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  spacing: 10,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: CustomFormField(
                                height: 60,
                                label: '',
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                noBorder: true,
                                isDense: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال رقم الهاتف';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              thickness: 0.3,
                              color: Colors.grey.shade500,
                              width: 20,
                            ),
                          ),
                          const Text(
                            '218+',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          ClipOval(
                            child: Image.asset(
                              'assets/images/ly.png',
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.toNamed('/register'),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.user300,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 10),
                    Text('إنشاء حساب جديد'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: CustomButton(
                    onPressed: _submit,
                    text: 'تسجيل الدخول',
                    isLoading: auth.isLoading.value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
