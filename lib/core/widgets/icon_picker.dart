import 'package:flutter/material.dart';

const _kIcons = [
  ('restaurant', Icons.restaurant_rounded),
  ('payments', Icons.payments_rounded),
  ('credit_card', Icons.credit_card_rounded),
  ('bank', Icons.account_balance_rounded),
  ('wallet', Icons.account_balance_wallet_rounded),
  ('shopping_cart', Icons.shopping_cart_rounded),
  ('home', Icons.home_rounded),
  ('directions_car', Icons.directions_car_rounded),
  ('local_hospital', Icons.local_hospital_rounded),
  ('school', Icons.school_rounded),
  ('sports', Icons.sports_rounded),
  ('movie', Icons.movie_rounded),
  ('flight', Icons.flight_rounded),
  ('fitness_center', Icons.fitness_center_rounded),
  ('subscriptions', Icons.subscriptions_rounded),
  ('wifi', Icons.wifi_rounded),
  ('phone', Icons.phone_rounded),
  ('pets', Icons.pets_rounded),
  ('savings', Icons.savings_rounded),
  ('trending_up', Icons.trending_up_rounded),
  ('tag', Icons.label_rounded),
  ('more_horiz', Icons.more_horiz_rounded),
];

class IconPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const IconPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static IconData iconDataFor(String name) {
    return _kIcons.firstWhere(
      (e) => e.$1 == name,
      orElse: () => ('tag', Icons.label_rounded),
    ).$2;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _kIcons.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (name, iconData) = _kIcons[i];
          final isSelected = selected == name;
          return GestureDetector(
            onTap: () => onChanged(name),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(iconData,
                  size: 24,
                  color: isSelected ? primary : Theme.of(context).colorScheme.onSurface),
            ),
          );
        },
      ),
    );
  }
}
