import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final RxBool isAuthenticated = false.obs;
  final RxBool isLoading = false.obs;
  final Rxn<User> user = Rxn<User>();
  final RxString error = ''.obs;

  Future<bool> register({
    required String name,
    required String phone,
    String? email,
    required String password,
    required String passwordConfirmation,
  }) async {
    isLoading.value = true;
    error.value = '';

    try {
      final res = await ApiService.post(
        '/customer/register',
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        await ApiService.saveToken(data['token']);
        user.value = User.fromJson(data['customer']);
        isAuthenticated.value = true;
        return true;
      }
      error.value = 'Registration failed: ${res.body}';
      return false;
    } catch (e) {
      error.value = 'An error occurred: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loginByPhone(String phone) async {
    isLoading.value = true;
    error.value = '';

    try {
      final res = await ApiService.post(
        '/customer/login/phone',
        data: {'phone': phone},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        await ApiService.saveToken(data['token']);
        await fetchMe();
        isAuthenticated.value = true;
        return true;
      }

      error.value = 'Login failed: ${res.body}';
      return false;
    } catch (e) {
      error.value = 'An error occurred: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginByEmail({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    final res = await ApiService.post(
      '/customer/login/email',
      data: {'email': email, 'password': password},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      await ApiService.saveToken(data['token']);
      await fetchMe();
      isAuthenticated.value = true;
    } else {
      throw Exception(res.body);
    }

    isLoading.value = false;
  }

  Future<void> fetchMe() async {
    final res = await ApiService.get('/customer/me');

    if (res.statusCode == 200) {
      user.value = User.fromJson(jsonDecode(res.body));
      isAuthenticated.value = true;
    } else {
      await logout();
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? avatar,
  }) async {
    isLoading.value = true;

    final res = await ApiService.put(
      '/customer/profile',
      data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (password != null) 'password': password,
        if (avatar != null) 'avatar': avatar,
      },
    );

    if (res.statusCode == 200) {
      user.value = User.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }

    isLoading.value = false;
  }

  Future<void> logout() async {
    await ApiService.post('/customer/logout');
    await ApiService.clearToken();
    user.value = null;
    isAuthenticated.value = false;
  }

  Future<void> deleteAccount() async {
    isLoading.value = true;

    final res = await ApiService.delete('/customer/account');

    if (res.statusCode == 200) {
      await ApiService.clearToken();
      user.value = null;
      isAuthenticated.value = false;
    } else {
      throw Exception(res.body);
    }

    isLoading.value = false;
  }

  Future<void> tryAutoLogin() async {
    final token = await ApiService.getToken();
    print("Auto-login token: $token");
    if (token.isEmpty) return;
    await fetchMe();
  }
}
