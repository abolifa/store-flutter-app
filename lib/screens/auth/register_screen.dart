import 'package:app/controllers/auth_controller.dart';
import 'package:app/router.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthController auth = Get.find<AuthController>();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    final success = await auth.register(
      name: name,
      phone: phone,
      email: email.isEmpty ? null : email,
      password: password,
      passwordConfirmation: password,
    );
    if (success) {
      Get.closeAllSnackbars();
      Get.offAllNamed(Routes.home);
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
        child: SingleChildScrollView(
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
                const SizedBox(height: 50),
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
                    'مرحباً بك، قم بإنشاء حساب جديد',
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
                      CustomFormField(
                        height: 60,
                        label: 'الإسم',
                        controller: _nameController,
                        fillColor: Colors.white,
                      ),
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
                                  height: 40,
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
                              height: 52,
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
                      CustomFormField(
                        height: 60,
                        label: 'البريد الإلكتروني (اختياري)',
                        controller: _emailController,
                        fillColor: Colors.white,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomFormField(
                        height: 60,
                        label: 'كلمة المرور',
                        controller: _passwordController,
                        fillColor: Colors.white,
                        isDense: true,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال كلمة المرور';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed(Routes.login),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.user,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 10),
                    const Text('تسجيل دخول'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => CustomButton(
                  onPressed: _submit,
                  text: 'تسجيل',
                  isLoading: auth.isLoading.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
