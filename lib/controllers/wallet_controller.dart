import 'dart:convert';

import 'package:app/controllers/paginated_controller.dart';
import 'package:app/models/wallet_transaction.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final RxBool isWalletLoading = false.obs;
  final RxnString currency = RxnString();
  final RxDouble balance = 0.0.obs;
  final RxnString walletError = RxnString();

  late final PaginatedController<WalletTransaction> transactions;

  @override
  void onInit() {
    super.onInit();
    transactions = PaginatedController<WalletTransaction>(
      endpoint: '/wallet/transactions',
      fromJson: (json) => WalletTransaction.fromJson(json),
      initialParams: {'sort': 'desc'},
    );
    fetchWallet();
    transactions.fetchPage(page: 1);
  }

  Future<void> fetchWallet() async {
    if (isWalletLoading.value) return;
    isWalletLoading.value = true;
    walletError.value = null;
    try {
      final res = await ApiService.get('/wallet/balance');
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        currency.value = data['currency'];
        balance.value = double.parse(data['balance'].toString());
      } else {
        walletError.value = data['message'] ?? 'Failed to load wallet';
      }
    } catch (e) {
      walletError.value = e.toString();
    } finally {
      isWalletLoading.value = false;
    }
  }

  Future<void> refreshAll() async {
    await Future.wait([fetchWallet(), transactions.refreshPage()]);
  }
}
