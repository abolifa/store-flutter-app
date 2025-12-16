import 'package:flutter/material.dart';

class PerkIcons {
  static IconData perkIcon(String? key) {
    switch (key) {
      case 'star':
        return Icons.star_rounded;

      case 'shopping_bag':
        return Icons.shopping_bag_rounded;

      case 'cart':
        return Icons.shopping_cart_rounded;

      case 'delivery':
      case 'truck':
        return Icons.local_shipping_rounded;

      case 'flash':
      case 'zap':
        return Icons.flash_on_rounded;

      case 'shield':
        return Icons.shield_outlined;

      case 'shield_check':
        return Icons.verified_user_rounded;

      case 'check_circle':
        return Icons.check_circle_rounded;

      case 'heart':
        return Icons.favorite_rounded;

      case 'gift':
        return Icons.card_giftcard_rounded;

      case 'tag':
        return Icons.local_offer_rounded;

      case 'percent':
        return Icons.percent_rounded;

      case 'clock':
        return Icons.schedule_rounded;

      case 'package':
        return Icons.inventory_2_rounded;

      case 'box':
        return Icons.all_inbox_rounded;

      case 'repeat':
        return Icons.repeat_rounded;

      case 'refresh':
        return Icons.refresh_rounded;

      case 'award':
        return Icons.emoji_events_rounded;

      case 'sparkles':
        return Icons.auto_awesome_rounded;

      case 'trending':
        return Icons.trending_up_rounded;

      case 'lock':
        return Icons.lock_rounded;

      default:
        return Icons.local_offer_rounded;
    }
  }
}
