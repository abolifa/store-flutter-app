import 'package:app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductRatingSection extends StatelessWidget {
  final Product product;
  const ProductRatingSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final reviews = product.approvedReviews ?? [];
    if (reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = reviews.length;
    final avg = (product.approvedReviewsAvgRating ?? 0).clamp(0, 5).toDouble();
    final isNarrow = MediaQuery.of(context).size.width < 420;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التقييمات والمراجعات',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 12),
          isNarrow
              ? Column(
                  spacing: 16,
                  children: [
                    _Summary(avg: avg, total: total),
                    _Breakdown(reviews: reviews, total: total),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: _Summary(avg: avg, total: total),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _Breakdown(reviews: reviews, total: total),
                    ),
                  ],
                ),
          const SizedBox(height: 10),
          Divider(thickness: 0.4, color: Colors.grey.shade300),
          Text(
            'يوجد $total تقييمات علي هذا المنتج',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          Divider(thickness: 0.4, color: Colors.grey.shade300),
          ...reviews.map((review) {
            final rating = (review.rating).clamp(0, 5);
            final createdAt = review.createdAt;
            final customer = review.customer;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 6,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: NetworkImage(
                          customer?.avatar?.isNotEmpty == true
                              ? customer!.avatar!
                              : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(customer?.name ?? 'مستخدم')}&background=0D8ABC&color=fff&size=64',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          customer?.name ?? 'مستخدم',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                      Text(
                        timeago.format(createdAt, locale: 'ar'),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(5, (index) {
                      if (rating >= index + 1) {
                        return const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        );
                      } else if (rating > index && rating < index + 1) {
                        return const Icon(
                          Icons.star_half,
                          size: 16,
                          color: Colors.amber,
                        );
                      }
                      return Icon(
                        Icons.star_border,
                        size: 16,
                        color: Colors.grey.shade400,
                      );
                    }),
                  ),
                  if ((review.comment ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      review.comment!.trim(),
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final double avg;
  final int total;
  const _Summary({required this.avg, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          avg.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(5, (index) {
            if (avg >= index + 1) {
              return const Icon(Icons.star, size: 20, color: Colors.amber);
            } else if (avg > index && avg < index + 1) {
              return const Icon(Icons.star_half, size: 20, color: Colors.amber);
            }
            return Icon(
              Icons.star_border,
              size: 20,
              color: Colors.grey.shade400,
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          '$total تقييم',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _Breakdown extends StatelessWidget {
  final List reviews;
  final int total;
  const _Breakdown({required this.reviews, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      children: List.generate(5, (i) {
        final star = 5 - i;
        final count = reviews.where((r) => (r.rating ?? 0) == star).length;
        final value = total > 0 ? count / total : 0.0;

        return Row(
          children: [
            SizedBox(
              width: 52,
              child: Text(
                '$star نجوم',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300.withValues(alpha: 0.5),
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 24,
              child: Text(
                '$count',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          ],
        );
      }),
    );
  }
}
