import 'package:app/controllers/wallet_controller.dart';
import 'package:app/models/wallet_transaction.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletController ctrl = Get.put(WalletController());

    return Scaffold(
      appBar: CustomAppBar(title: 'المحفظة'),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: ctrl.refreshAll,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: ctrl.transactions.items.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                if (ctrl.isWalletLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade300,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الرصيد المتاح',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ctrl.balance.value.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final txIndex = index - 1;

              if (txIndex >= ctrl.transactions.items.length) {
                if (ctrl.transactions.hasMore) {
                  ctrl.transactions.loadMore();
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                }
                return const SizedBox(height: 16);
              }

              final WalletTransaction tx = ctrl.transactions.items[txIndex];

              final isCredit = tx.direction == 'credit';
              final color = isCredit ? Colors.green : Colors.red;

              String normalizeType(String type) {
                if (type.endsWith('_credit')) {
                  return type.replaceAll('_credit', '');
                }
                if (type.endsWith('_debit')) {
                  return type.replaceAll('_debit', '');
                }
                return type;
              }

              String getLabel() {
                final base = normalizeType(tx.type);
                switch (base) {
                  case 'admin_topup':
                    return 'إيداع';
                  case 'admin_adjustment':
                    return 'تعديل رصيد';
                  case 'order_payment':
                    return 'دفع طلب';
                  case 'order_refund':
                  case 'order_cancel_refund':
                    return 'استرداد قيمة طلب';
                  case 'wallet_transfer':
                    return isCredit ? 'تحويل وارد' : 'تحويل صادر';
                  case 'delivery_hold':
                    return 'حجز مبلغ للتوصيل';
                  case 'delivery_release':
                    return 'تحرير مبلغ التوصيل';
                  case 'delivery_penalty':
                    return 'خصم جزاء توصيل';
                  case 'promo_bonus':
                    return 'رصيد مكافأة';
                  case 'cashback':
                    return 'استرجاع نقدي';
                  case 'withdraw_request':
                    return 'طلب سحب رصيد';
                  case 'withdraw_reversal':
                    return 'إلغاء سحب رصيد';
                  case 'withdraw_fee':
                    return 'رسوم سحب';
                  case 'system_correction':
                    return 'تصحيح رصيد';
                  default:
                    return 'عملية مالية';
                }
              }

              final referenceVisible = normalizeType(tx.type) != 'admin_topup';
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: color.withValues(alpha: 0.12),
                        child: Icon(
                          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              referenceVisible
                                  ? '${getLabel()} - #${tx.referanceId}'
                                  : getLabel(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat.yMMMd(
                                'ar',
                              ).add_jm().format(tx.createdAt),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${isCredit ? '+' : '-'}${tx.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'الرصيد: ${tx.balanceAfter.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
