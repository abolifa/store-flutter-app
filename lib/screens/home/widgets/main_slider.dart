import 'package:app/helpers/helpers.dart';
import 'package:app/models/slider.dart';
import 'package:app/widgets/server_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MainSlider extends StatelessWidget {
  final List<SliderModel> sliders;
  const MainSlider({super.key, required this.sliders});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: false,
          viewportFraction: 1,
          height: 200,
          aspectRatio: 16 / 9,
          initialPage: 0,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
          enableInfiniteScroll: true,
        ),
        items: sliders.map((slider) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ServerImage(
                  url: Helpers.getServerImage(slider.image),
                  borderRadius: BorderRadius.circular(10),
                  fit: BoxFit.cover,
                  backgroundColor: Colors.grey.shade200,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
