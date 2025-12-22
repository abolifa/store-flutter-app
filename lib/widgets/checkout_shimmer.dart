import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutShimmer extends StatelessWidget {
  const CheckoutShimmer({super.key});

  Widget _line(double w, double h) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line(180, 45),
            const SizedBox(height: 20),
            _line(double.infinity, 20),
            const SizedBox(height: 10),
            _line(double.infinity, 20),
            const SizedBox(height: 10),
            _line(double.infinity, 20),
            const SizedBox(height: 20),
            _line(120, 25),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (_, __) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _line(40, 40),
                      const SizedBox(width: 10),
                      Expanded(child: _line(double.infinity, 15)),
                    ],
                  ),
                ),
              ),
            ),
            _line(double.infinity, 55),
          ],
        ),
      ),
    );
  }
}
