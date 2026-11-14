enum FoodCategory {
  burgers('البرجر', 'Burgers', '🍔'),
  chicken('دجاج كرسبي', 'Crispy Chicken', '🍗'),
  pizza('البيتزا الإيطالية', 'Gourmet Pizza', '🍕'),
  sides('المقبلات والبطاطس', 'Sides & Fries', '🍟'),
  drinks('المشروبات والميلك شيك', 'Drinks & Shakes', '🥤'),
  desserts('الحلويات والآيس كريم', 'Desserts', '🍦');

  final String nameAr;
  final String nameEn;
  final String icon;

  const FoodCategory(this.nameAr, this.nameEn, this.icon);

  String name(bool isAr) => isAr ? nameAr : nameEn;
}

class MealSize {
  final String nameAr;
  final String nameEn;
  final double extraPrice;

  const MealSize({
    required this.nameAr,
    required this.nameEn,
    this.extraPrice = 0.0,
  });

  String name(bool isAr) => isAr ? nameAr : nameEn;
}

class ExtraOption {
  final String id;
  final String nameAr;
  final String nameEn;
  final double price;

  const ExtraOption({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
  });

  String name(bool isAr) => isAr ? nameAr : nameEn;
}

class MenuItem {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final FoodCategory category;
  final String imageUrl;
  final int calories;
  final bool isPopular;
  final bool isChefSpecial;
  final List<MealSize> availableSizes;
  final List<String> removableIngredientsAr;
  final List<String> removableIngredientsEn;
  final List<ExtraOption> availableExtras;
  final bool canBeCombo;
  final double comboPrice;

  const MenuItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.calories,
    this.isPopular = false,
    this.isChefSpecial = false,
    this.availableSizes = const [
      MealSize(nameAr: 'حجم عادي', nameEn: 'Regular', extraPrice: 0.0),
      MealSize(nameAr: 'حجم كبير (L)', nameEn: 'Large (L)', extraPrice: 25.0),
      MealSize(nameAr: 'سوبر لارج (XL)', nameEn: 'Super (XL)', extraPrice: 45.0),
    ],
    this.removableIngredientsAr = const ['بدون بصل', 'بدون مخلل', 'بدون طماطم', 'بدون مايونيز'],
    this.removableIngredientsEn = const ['No Onions', 'No Pickles', 'No Tomatoes', 'No Mayo'],
    this.availableExtras = const [],
    this.canBeCombo = true,
    this.comboPrice = 40.0,
  });

  String name(bool isAr) => isAr ? nameAr : nameEn;
  String description(bool isAr) => isAr ? descriptionAr : descriptionEn;
}
