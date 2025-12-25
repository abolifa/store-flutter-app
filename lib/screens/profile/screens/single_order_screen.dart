import 'package:app/controllers/open_invoice.dart';
import 'package:app/controllers/orders_api_controller.dart';
import 'package:app/helpers/helpers.dart';
import 'package:app/screens/utilities/pdf_viewer.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/dev.dart';
import 'package:app/widgets/server_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SingleOrderScreen extends StatefulWidget {
  final int orderId;
  const SingleOrderScreen({super.key, required this.orderId});

  @override
  State<SingleOrderScreen> createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen> {
  final OrdersApiController orderController = Get.find<OrdersApiController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.fetchOrder(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ملخص الطلب'),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final order = orderController.order.value;
        if (order == null) {
          return const Center(child: Text('لم يتم العثور على الطلب.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              _cardWidget(
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'طلب ${order.id}#',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            DateFormat.yMMMd().add_jm().format(order.createdAt),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Dev(),
                    Row(
                      children: [
                        Text(
                          order.payment?.paymentMethod.name ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Helpers.getOrderStatusColor(order.status),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            Helpers.getOrderStatusLabel(order.status),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                'تفاصيل الطلب',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              if (order.items?.isNotEmpty == true)
                _cardWidget(
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.items!.length,
                    separatorBuilder: (context, index) => const Dev(),
                    itemBuilder: (context, index) {
                      final item = order.items![index];
                      return Row(
                        spacing: 10,
                        children: [
                          ServerImage(
                            url: Helpers.getServerImage(
                              item.productVariant?.image,
                            ),
                            width: 50,
                            height: 50,
                            borderRadius: BorderRadius.circular(8),
                            backgroundColor: Colors.transparent,
                            fit: BoxFit.contain,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${Helpers.formatPriceFixed(item.unitPrice - item.discount)} د',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'x${item.quantity}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              _cardWidget(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow(
                      label: 'المجموع',
                      value: Helpers.formatPriceFixed(order.subtotal),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      label: 'خصم',
                      value: Helpers.formatPriceFixed(order.discount),
                      direction: 'minus',
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      label: 'التوصيل',
                      value: Helpers.formatPriceFixed(order.deliveryFees),
                      direction: 'plus',
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      label: 'الضريبة',
                      value: Helpers.formatPriceFixed(order.tax),
                      direction: 'plus',
                    ),
                    const SizedBox(height: 8),
                    const Dev(),
                    _buildSummaryRow(
                      label: 'الإجمالي',
                      value: Helpers.formatPriceFixed(order.total),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              Text(
                'العنوان',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              _cardWidget(
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey.shade600),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${order.address?.street ?? ''}, ${order.address?.landmark ?? ''}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: orderController.order.value?.status == 'delivered'
          ? Padding(
              padding: EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 5),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'تقييم الخدمة',
                      onPressed: () {},
                      icon: Icon(LucideIcons.star300, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      text: 'عرض الفاتورة',
                      icon: Icon(LucideIcons.receipt300, color: Colors.white),
                      onPressed: () async {
                        try {
                          Get.dialog(
                            const Center(child: CupertinoActivityIndicator()),
                            barrierDismissible: false,
                          );
                          final pdfBytes = await fetchInvoicePdf(
                            widget.orderId,
                          );
                          if (Get.isDialogOpen ?? false) {
                            Get.back();
                          }
                          Get.to(
                            () => PdfViewer(
                              pdfBytes: pdfBytes,
                              orderId: widget.orderId,
                            ),
                          );
                        } catch (e) {
                          if (Get.isDialogOpen ?? false) {
                            Get.back();
                          }
                          Get.snackbar('خطأ', 'تعذر تحميل الفاتورة');
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isTotal = false,
    String? direction,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
        const Spacer(),
        Text(
          direction == null ? '' : (direction == 'plus' ? '(+)' : '(-)'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'د',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _cardWidget(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
