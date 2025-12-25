import 'package:app/controllers/orders_api_controller.dart';
import 'package:app/screens/profile/widgets/order_container.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/empty_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrdersApiController ctrl = Get.put(
    OrdersApiController(),
    permanent: false,
  );

  @override
  void initState() {
    super.initState();
    ctrl.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'طلباتي', isBackButton: true),
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.orders.isEmpty) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (ctrl.orders.isEmpty) {
          return RefreshIndicator(
            onRefresh: ctrl.refresh,
            child: EmptyScreen(
              title: 'لا توجد طلبات',
              subtitle: 'لم تقم بأي طلبات بعد.',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: ctrl.refresh,
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: ctrl.orders.length + 1,
            itemBuilder: (context, index) {
              if (index == ctrl.orders.length) {
                if (!ctrl.hasMore) {
                  return const SizedBox(height: 10);
                }
                ctrl.loadMore();
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final order = ctrl.orders[index];
              return OrderContainer(order: order);
            },
          ),
        );
      }),
    );
  }
}
