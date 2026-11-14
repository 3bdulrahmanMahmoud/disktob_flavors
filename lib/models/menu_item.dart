enum FoodCategory {
  burgers('البرجر', 'Burgers', '🍔'),
  pizza('البيتزا', 'Pizza', '🍕'),
  combos('الوجبات العائلية', 'Combos', '🍗'),
  sides('المقبلات والبطاطس', 'Sides & Fries', '🍟'),
  drinks('المشروبات', 'Drinks', '🥤'),
  desserts('الحلويات', 'Desserts', '🍦');

  final String nameAr;
  final String nameEn;
  final String icon;

  const FoodCategory(this.nameAr, this.nameEn, this.icon);
}

class ExtraOption {
  final String id;
  final String nameAr;
  final double price;

  const ExtraOption({
    required this.id,
    required this.nameAr,
    required this.price,
  });
}

class MenuItem {
  final String id;
  final String nameAr;
  final String nameEn;
  final String description;
  final double price;
  final FoodCategory category;
  final String imageUrl;
  final int calories;
  final bool isPopular;
  final List<ExtraOption> availableExtras;

  const MenuItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.calories,
    this.isPopular = false,
    this.availableExtras = const [],
  });
}
