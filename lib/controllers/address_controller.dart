import 'dart:convert';

import 'package:app/models/address.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  final RxList<Address> addresses = <Address>[].obs;
  final Rxn<Address> selectedAddress = Rxn<Address>();
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Address? get defaultAddress =>
      addresses.firstWhereOrNull((a) => a.isDefault == true);

  void _initSelectedAddress() {
    if (selectedAddress.value != null) return;

    if (defaultAddress != null) {
      selectedAddress.value = defaultAddress;
    } else if (addresses.isNotEmpty) {
      selectedAddress.value = addresses.first;
    }
  }

  Future<void> fetchAddresses() async {
    if (isLoading.value) return;
    isLoading.value = true;
    error.value = null;

    try {
      final res = await ApiService.get('/addresses');
      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data is List) {
        addresses.assignAll(data.map((e) => Address.fromJson(e)).toList());
        _initSelectedAddress();
      } else {
        addresses.clear();
        error.value = data['message'] ?? 'error_occurred';
      }
    } catch (e) {
      addresses.clear();
      error.value = 'network_error $e';
    } finally {
      isLoading.value = false;
    }
  }

  void selectAddress(Address address) {
    selectedAddress.value = address;
  }

  Future<Address?> fetchAddressById(int id) async {
    if (id <= 0) return null;

    isLoading.value = true;
    error.value = null;

    try {
      final res = await ApiService.get('/addresses/$id');
      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data is Map<String, dynamic>) {
        final address = Address.fromJson(data);

        final index = addresses.indexWhere((a) => a.id == address.id);
        if (index >= 0) {
          addresses[index] = address;
          addresses.refresh();
        } else {
          addresses.add(address);
        }

        return address;
      } else {
        error.value = data['message'] ?? 'address_not_found';
      }
    } catch (_) {
      error.value = 'network_error';
    } finally {
      isLoading.value = false;
    }

    return null;
  }

  Future<bool> addAddress(Map<String, dynamic> payload) async {
    isLoading.value = true;
    error.value = null;

    try {
      final res = await ApiService.post('/addresses', data: payload);
      final data = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        await fetchAddresses();
        return true;
      } else {
        error.value = data['message'] ?? 'create_failed';
      }
    } catch (_) {
      error.value = 'network_error';
    } finally {
      isLoading.value = false;
    }

    return false;
  }

  Future<bool> updateAddress(int id, Map<String, dynamic> payload) async {
    if (id <= 0) return false;

    isLoading.value = true;
    error.value = null;

    try {
      final res = await ApiService.put('/addresses/$id', data: payload);
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        await fetchAddresses();
        return true;
      } else {
        error.value = data['message'] ?? 'update_failed';
      }
    } catch (_) {
      error.value = 'network_error';
    } finally {
      isLoading.value = false;
    }

    return false;
  }

  Future<bool> deleteAddress(int id) async {
    if (id <= 0) return false;
    isLoading.value = true;
    error.value = null;
    try {
      final res = await ApiService.delete('/addresses/$id');
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final wasSelected = selectedAddress.value?.id == id;
        addresses.removeWhere((a) => a.id == id);
        if (wasSelected) {
          selectedAddress.value = null;
          _initSelectedAddress();
        }
        return true;
      } else {
        error.value = data['message'] ?? 'delete_failed';
      }
    } catch (_) {
      error.value = 'network_error';
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> makeDefault(int id) async {
    if (id <= 0) return false;
    isLoading.value = true;
    error.value = null;
    try {
      final res = await ApiService.post('/addresses/$id/make-default');
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        addresses.assignAll(
          addresses.map((a) => a.copyWith(isDefault: a.id == id)),
        );
        selectedAddress.value = addresses.firstWhereOrNull((a) => a.id == id);
        return true;
      } else {
        error.value = data['message'] ?? 'error_occurred';
      }
    } catch (_) {
      error.value = 'network_error';
    } finally {
      isLoading.value = false;
    }
    return false;
  }
}
