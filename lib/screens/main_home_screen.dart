import 'package:app/controllers/cart_controller.dart';
import 'package:app/screens/cart/cart_screen.dart';
import 'package:app/screens/categories/categories_screen.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/offers/offers_screen.dart';
import 'package:app/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainHomeScreen extends StatefulWidget {
  final int initialIndex;

  const MainHomeScreen({super.key, this.initialIndex = 0});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    HomeScreen(),
    CategoriesScreen(),
    OffersScreen(),
    ProfileScreen(),
    CartScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              iconSize: 26.0,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(LucideIcons.house300),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.grip300),
                  label: 'الأقسام',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.tag300),
                  label: 'العروض',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.user300),
                  label: 'حسابي',
                ),
                BottomNavigationBarItem(
                  icon: Obx(() {
                    final cart = Get.find<CartController>();
                    final count = cart.totalCount;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(LucideIcons.shoppingCart300),
                        if (count > 0)
                          Positioned(
                            right: -6,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                count > 9 ? '9+' : '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                  label: 'العربة',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
