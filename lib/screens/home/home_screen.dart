import 'package:app/controllers/home_controller.dart';
import 'package:app/screens/home/widgets/brands_widget.dart';
import 'package:app/screens/home/widgets/category_bubble.dart';
import 'package:app/screens/home/widgets/home_bar.dart';
import 'package:app/screens/home/widgets/main_slider.dart';
import 'package:app/screens/home/widgets/offer_widget.dart';
import 'package:app/screens/home/widgets/section_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  Future<void> _onRefresh() async {
    await controller.fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          final isLoading = controller.isLoading.value;
          final error = controller.error.value;
          final data = controller.homeData.value;
          if (isLoading && data == null) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (error.isNotEmpty && data == null) {
            return Center(
              child: Text(error, style: const TextStyle(color: Colors.red)),
            );
          }
          if (data == null) {
            return const Center(child: Text('لا توجد بيانات متاحة'));
          }

          final sliders = data.sliders ?? [];
          final categories = data.categories ?? [];
          final brands = data.brands ?? [];
          final offers = data.offers ?? [];
          final sections = data.sections ?? [];

          final topOffers = offers.where((o) => o.position == 'top').toList();
          final belowSliderOffers = offers
              .where((o) => o.position == 'below_slider')
              .toList();
          final belowCategoriesOffers = offers
              .where((o) => o.position == 'below_categories')
              .toList();
          final belowBrandsOffers = offers
              .where((o) => o.position == 'below_brands')
              .toList();
          final belowSectionOffers = offers
              .where((o) => o.position == 'below_section')
              .toList();

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (topOffers.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      children: topOffers
                          .map((offer) => OfferWidget(offer: offer))
                          .toList(),
                    ),
                  ),

                if (sliders.isNotEmpty)
                  SliverToBoxAdapter(child: MainSlider(sliders: sliders)),

                if (belowSliderOffers.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      children: belowSliderOffers
                          .map((offer) => OfferWidget(offer: offer))
                          .toList(),
                    ),
                  ),

                if (categories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: CategoryBubble(categories: categories),
                  ),

                if (belowCategoriesOffers.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      children: belowCategoriesOffers
                          .map((offer) => OfferWidget(offer: offer))
                          .toList(),
                    ),
                  ),

                if (brands.isNotEmpty)
                  SliverToBoxAdapter(child: BrandsWidget(brands: brands)),

                if (belowBrandsOffers.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      children: belowBrandsOffers
                          .map((offer) => OfferWidget(offer: offer))
                          .toList(),
                    ),
                  ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final section = sections[index];
                    final sectionOffers = belowSectionOffers
                        .where((o) => o.sectionId == section.id)
                        .toList();

                    return Column(
                      children: [
                        if (section.products != null &&
                            section.products!.isNotEmpty)
                          SectionWidget(section: section),
                        ...sectionOffers.map(
                          (offer) => OfferWidget(offer: offer),
                        ),
                      ],
                    );
                  }, childCount: sections.length),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
