import 'package:app/controllers/wallet_controller.dart';
import 'package:app/models/wallet_transaction.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BalanceCard(balance: ctrl.balance.value),
                Text(
                  'سجل المعاملات',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: ctrl.transactions.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final tx = ctrl.transactions.items[index];
                      final isCredit = tx.direction == 'credit';
                      return _TransactionItem(tx: tx, isCredit: isCredit);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;

  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'الرصيد المتاح',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                balance.toStringAsFixed(2),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'د.ل',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              CustomButton(
                height: 40,
                width: 100,
                borderRadius: 50,
                onPressed: () {},
                text: 'شحن',
                icon: Icon(
                  LucideIcons.creditCard300,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              CustomButton(
                height: 40,
                width: 100,
                borderRadius: 50,
                onPressed: () {},
                text: 'تحويل',
                icon: Icon(
                  LucideIcons.arrowRightLeft300,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              CustomButton(
                height: 40,
                width: 100,
                borderRadius: 50,
                onPressed: () {},
                text: 'سحب',
                icon: Icon(
                  LucideIcons.dollarSign300,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final WalletTransaction tx;
  final bool isCredit;

  const _TransactionItem({required this.tx, required this.isCredit});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('yyyy/MM/dd – hh:mm a').format(tx.createdAt);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(2),
            child: Icon(
              isCredit ? LucideIcons.plus : LucideIcons.minus,
              color: isCredit ? Colors.green : Colors.red,
              size: 30,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Text(
                      getLabel(tx, isCredit),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Icon(
                      LucideIcons.moveLeft300,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    Text(
                      tx.idempotencyKey ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      tx.amount.abs().toStringAsFixed(2),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('د.ل', style: TextStyle(fontSize: 13)),
                    const Spacer(),
                    Container(
                      width: 80,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isCredit ? Colors.green : Colors.redAccent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        getType(tx),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String normalizeType(String type) {
  if (type.endsWith('_credit')) {
    return type.replaceAll('_credit', '');
  }
  if (type.endsWith('_debit')) {
    return type.replaceAll('_debit', '');
  }
  return type;
}

String getLabel(WalletTransaction tx, bool isCredit) {
  final base = normalizeType(tx.type);

  switch (base) {
    case 'admin_topup':
      return 'إضافة رصيد';
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

String getType(WalletTransaction tx) {
  switch (tx.direction) {
    case 'credit':
      return 'إيداع';
    case 'debit':
      return 'سحب';
    default:
      return 'عملية مالية';
  }
}
