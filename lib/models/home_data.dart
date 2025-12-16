import 'package:app/models/brand.dart';
import 'package:app/models/category.dart';
import 'package:app/models/offer.dart';
import 'package:app/models/section.dart';
import 'package:app/models/slider.dart';

class HomeData {
  final List<Category>? categories;
  final List<Brand>? brands;
  final List<SliderModel>? sliders;
  final List<Offer>? offers;
  final List<Section>? sections;

  HomeData({
    this.categories,
    this.brands,
    this.sliders,
    this.offers,
    this.sections,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    var categoriesJson = json['categories'] as List<dynamic>?;
    var brandsJson = json['brands'] as List<dynamic>?;
    var slidersJson = json['sliders'] as List<dynamic>?;
    var offersJson = json['offers'] as List<dynamic>?;
    var sectionsJson = json['sections'] as List<dynamic>?;

    List<Category>? categoriesList = categoriesJson
        ?.map((item) => Category.fromJson(item))
        .toList();
    List<Brand>? brandsList = brandsJson
        ?.map((item) => Brand.fromJson(item))
        .toList();
    List<SliderModel>? slidersList = slidersJson
        ?.map((item) => SliderModel.fromJson(item))
        .toList();
    List<Offer>? offersList = offersJson
        ?.map((item) => Offer.fromJson(item))
        .toList();
    List<Section>? sectionsList = sectionsJson
        ?.map((item) => Section.fromJson(item))
        .toList();

    return HomeData(
      categories: categoriesList,
      brands: brandsList,
      sliders: slidersList,
      offers: offersList,
      sections: sectionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories?.map((category) => category.toJson()).toList(),
      'brands': brands?.map((brand) => brand.toJson()).toList(),
      'sliders': sliders?.map((slider) => slider.toJson()).toList(),
      'offers': offers?.map((offer) => offer.toJson()).toList(),
      'sections': sections?.map((section) => section.toJson()).toList(),
    };
  }
}
