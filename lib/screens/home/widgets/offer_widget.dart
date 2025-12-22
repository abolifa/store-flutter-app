import 'dart:async';

import 'package:app/helpers/helpers.dart';
import 'package:app/models/offer.dart';
import 'package:app/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferWidget extends StatelessWidget {
  final Offer offer;
  const OfferWidget({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    if (offer.image.isEmpty) {
      return const SizedBox.shrink();
    }

    final url = Helpers.getServerImage(offer.image);

    return GestureDetector(
      onTap: () => {
        if (offer.type == 'url' && offer.url != null && offer.url!.isNotEmpty)
          {Helpers.launchURL(offer.url!)}
        else
          {
            Get.toNamed(Routes.offerProducts, arguments: {'offerId': offer.id}),
          },
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, imageProvider) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return FutureBuilder<Size>(
                  future: _getImageSize(url),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return _buildPlaceholder();
                    }
                    final size = snapshot.data!;
                    final aspectRatio = size.width / size.height;

                    return AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) => _buildErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: CupertinoActivityIndicator()),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: Icon(Icons.error)),
    );
  }

  Future<Size> _getImageSize(String url) async {
    final completer = Completer<Size>();
    final image = Image.network(url);

    final listener = ImageStreamListener((ImageInfo info, bool _) {
      if (!completer.isCompleted) {
        completer.complete(
          Size(info.image.width.toDouble(), info.image.height.toDouble()),
        );
      }
    });
    final stream = image.image.resolve(const ImageConfiguration());
    stream.addListener(listener);
    completer.future.whenComplete(() {
      stream.removeListener(listener);
    });

    return completer.future;
  }
}
