import 'package:app/screens/cart/cart_screen.dart';
import 'package:app/screens/categories/categories_screen.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/offers/offers_screen.dart';
import 'package:app/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainHomeScreen extends StatefulWidget {
  final int initialIndex;

  const MainHomeScreen({super.key, this.initialIndex = 0});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  late int currentIndex;

  final pages = const [
    HomeScreen(),
    CategoriesScreen(),
    OffersScreen(),
    ProfileScreen(),
    CartScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex.clamp(0, pages.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.house300),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.grip300),
            label: 'الفئات',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.flame300),
            label: 'العروض',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user300),
            label: 'حسابي',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.shoppingCart300),
            label: 'العربة',
          ),
        ],
      ),
    );
  }
}
