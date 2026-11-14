import '../models/menu_item.dart';

class PromoDeal {
  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final String code;
  final String bannerBadge;

  const PromoDeal({
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.code,
    required this.bannerBadge,
  });

  String title(bool isAr) => isAr ? titleAr : titleEn;
  String subtitle(bool isAr) => isAr ? subtitleAr : subtitleEn;
}

class MockData {
  static const List<PromoDeal> promoDeals = [
    PromoDeal(
      titleAr: 'عرض التوفير الأسبوعي: خصم 20% على ساندوتشات الدبل بيف',
      titleEn: 'Weekly Saver: 20% OFF all Double Beef Burgers',
      subtitleAr: 'استخدم كود SAVE20 عند الدفع الإلكتروني',
      subtitleEn: 'Use code SAVE20 at card terminal checkout',
      code: 'SAVE20',
      bannerBadge: '🔥 عرض اليوم',
    ),
    PromoDeal(
      titleAr: 'وجبة العائلة الكبرى: 4 برجر + بطاطس حجم عائلي + 4 مشروبات',
      titleEn: 'Family Feast: 4 Burgers + Jumbo Fries + 4 Drinks',
      subtitleAr: 'فقط 399 ج.م بدلاً من 480 ج.م',
      subtitleEn: 'Only 399 EGP instead of 480 EGP',
      code: 'FEAST',
      bannerBadge: '⭐ الأكثر مبيعاً',
    ),
    PromoDeal(
      titleAr: 'اشترِ أي وجبة كومبو واحصل على آيس كريم صنداي بنصف السعر',
      titleEn: 'Buy any Combo Meal & Get Caramel Sundae at 50% OFF',
      subtitleAr: 'حلي بعد وجبتك مع أفضل صوص كراميل مملح',
      subtitleEn: 'Sweeten your meal with rich salted caramel sundae',
      code: 'SWEET50',
      bannerBadge: '🍦 تحلية خاصة',
    ),
  ];

  static const List<ExtraOption> burgerExtras = [
    ExtraOption(id: 'ex_cheese', nameAr: 'شريحة جبن شيدر ذائبة', nameEn: 'Melted Cheddar Slice', price: 15.0),
    ExtraOption(id: 'ex_bacon', nameAr: 'شرائح بيكون بقري مقرمش', nameEn: 'Crispy Beef Bacon', price: 25.0),
    ExtraOption(id: 'ex_jalapeno', nameAr: 'هالبينو مكسيكي حار', nameEn: 'Spicy Mexican Jalapeño', price: 12.0),
    ExtraOption(id: 'ex_truffle', nameAr: 'صوص مايونيز الكمأة (ترافل)', nameEn: 'Truffle Mayo Dip', price: 20.0),
    ExtraOption(id: 'ex_onion_rings', nameAr: 'إضافة 2 حلقة بصل مقرمشة', nameEn: 'Add 2 Crispy Onion Rings', price: 18.0),
  ];

  static const List<ExtraOption> pizzaExtras = [
    ExtraOption(id: 'ex_mozzarella', nameAr: 'جبنة موزاريلا إيطالية إضافية', nameEn: 'Extra Italian Mozzarella', price: 25.0),
    ExtraOption(id: 'ex_stuffed_crust', nameAr: 'أطراف محشوة بجبنة الشيدر', nameEn: 'Cheddar Stuffed Crust', price: 35.0),
    ExtraOption(id: 'ex_mushroom', nameAr: 'مشروم بورتوبيلو طازج', nameEn: 'Fresh Portobello Mushrooms', price: 20.0),
  ];

  static const List<MenuItem> menuItems = [
    // Burgers
    MenuItem(
      id: 'b1',
      nameAr: 'سموكي باربيكيو بيكون برجر',
      nameEn: 'Smoky BBQ Bacon Burger',
      descriptionAr: 'شريحة لحم بلاك أنجوس مشوية على اللهب، شرائح بيكون مقرمشة، بصل مكرمل وصوص باربيكيو غني بالدخان.',
      descriptionEn: 'Flame-grilled 100% Angus beef patty, crispy beef bacon, caramelized onions, and signature smoked BBQ glaze.',
      price: 135.0,
      category: FoodCategory.burgers,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80',
      calories: 780,
      isPopular: true,
      isChefSpecial: true,
      availableExtras: burgerExtras,
    ),
    MenuItem(
      id: 'b2',
      nameAr: 'ترافل آند سويس برجر فاخر',
      nameEn: 'Truffle & Swiss Gourmet',
      descriptionAr: 'لحم أنجوس فاخر مغطى بفطر السوتيه الطازج، جبنة سويسرية ذائبة، ومايونيز زيت الكمأة الإيطالي.',
      descriptionEn: 'Gourmet Angus beef with sautéed mushrooms, melted Swiss cheese, and infused Italian truffle mayonnaise.',
      price: 155.0,
      category: FoodCategory.burgers,
      imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=600&auto=format&fit=crop&q=80',
      calories: 820,
      isChefSpecial: true,
      availableExtras: burgerExtras,
    ),
    MenuItem(
      id: 'b3',
      nameAr: 'أولد سكول تشيز برجر كلاسيك',
      nameEn: 'Old School Cheeseburger',
      descriptionAr: 'شريحة أنجوس، شريحتي جبن شيدر أصفر وأبيض، خس كريسبي، شرائح طماطم وصوص الخردل السري.',
      descriptionEn: 'Double aged cheddar cheese over prime beef, crispy iceberg lettuce, ripe tomatoes, and secret mustard relish.',
      price: 110.0,
      category: FoodCategory.burgers,
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80',
      calories: 650,
      isPopular: true,
      availableExtras: burgerExtras,
    ),

    // Chicken
    MenuItem(
      id: 'ch1',
      nameAr: 'كرسبي تشيكن فيليه ديلوكس',
      nameEn: 'Deluxe Crispy Chicken Fillet',
      descriptionAr: 'صدر دجاج مقرمش ذهبي متبل بـ 11 بهاراً، سلطة كول سلو طازجة، جبنة شيدر وصوص المايونيز المدخن.',
      descriptionEn: 'Golden crispy chicken breast hand-breaded in 11 herbs & spices, fresh coleslaw, cheddar, and smoked mayo.',
      price: 120.0,
      category: FoodCategory.chicken,
      imageUrl: 'https://images.unsplash.com/photo-1625813506062-0aeb1d7a094b?w=600&auto=format&fit=crop&q=80',
      calories: 690,
      isPopular: true,
      availableExtras: burgerExtras,
    ),
    MenuItem(
      id: 'ch2',
      nameAr: 'فاير بوكس تشيكن حار نار 🌶️',
      nameEn: 'Firebox Spicy Chicken',
      descriptionAr: 'دجاج مقرمش مغطس بصلصة الناشفيل الحارة، شرائح هالبينو، مخلل وصوص الرانش المهدئ.',
      descriptionEn: 'Nashville hot glazed crispy chicken fillet, jalapeños, spicy pickle chips, and cooling homemade buttermilk ranch.',
      price: 125.0,
      category: FoodCategory.chicken,
      imageUrl: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=600&auto=format&fit=crop&q=80',
      calories: 740,
      availableExtras: burgerExtras,
    ),
    MenuItem(
      id: 'ch3',
      nameAr: 'باكت كرسبي تندر (8 قطع)',
      nameEn: 'Crispy Chicken Tenders (8 pcs)',
      descriptionAr: '8 قطع من ستربس الدجاج الطازج المقرمش مع 3 صوصات من اختيارك وخبز بريوش دافئ.',
      descriptionEn: '8 pieces of golden tenders with trio dipping sauces (Honey Mustard, BBQ, Ranch) and warm brioche buns.',
      price: 160.0,
      category: FoodCategory.chicken,
      imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=600&auto=format&fit=crop&q=80',
      calories: 890,
      isPopular: true,
      canBeCombo: false,
    ),

    // Pizza
    MenuItem(
      id: 'p1',
      nameAr: 'بيتزا بيبروني نابوليتانا ديلوكس',
      nameEn: 'Neapolitan Pepperoni Deluxe',
      descriptionAr: 'عجينة مخمرة 48 ساعة، صلصة طماطم إيطالية مطبوخة، جبنة موزاريلا غنية وشرائح بيبروني بقري مميز.',
      descriptionEn: '48-hr slow fermented dough, San Marzano tomato sauce, fresh mozzarella fior di latte, and beef pepperoni cups.',
      price: 140.0,
      category: FoodCategory.pizza,
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=600&auto=format&fit=crop&q=80',
      calories: 980,
      isPopular: true,
      availableExtras: pizzaExtras,
      canBeCombo: false,
    ),
    MenuItem(
      id: 'p2',
      nameAr: 'بيتزا باربيكيو تشيكن رانش',
      nameEn: 'BBQ Chicken Ranch Pizza',
      descriptionAr: 'قطع دجاج مشوية، صوص الباربيكيو المدخن، صوص الرانش الغني، بصل أحمر وريحان طازج.',
      descriptionEn: 'Smoked pulled chicken breast, tangy barbecue drizzle, garlic ranch base, red onions, and fresh basil.',
      price: 145.0,
      category: FoodCategory.pizza,
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop&q=80',
      calories: 920,
      availableExtras: pizzaExtras,
      canBeCombo: false,
    ),
    MenuItem(
      id: 'p3',
      nameAr: 'بيتزا كواترو فورماجي (الأجبان الأربعة)',
      nameEn: 'Quattro Formaggi Pizza',
      descriptionAr: 'مزيج فاخر من الموزاريلا، الجورجونزولا الإيطالية، جبنة البارميزان المعتقة، والشيدر الإنجليزي.',
      descriptionEn: 'Four cheese blend: Italian Fior di Latte, sharp Gorgonzola, aged Parmigiano Reggiano, and mature cheddar.',
      price: 135.0,
      category: FoodCategory.pizza,
      imageUrl: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=600&auto=format&fit=crop&q=80',
      calories: 880,
      availableExtras: pizzaExtras,
      canBeCombo: false,
    ),

    // Sides & Fries
    MenuItem(
      id: 's1',
      nameAr: 'لودد تشيز فرايز بالبيكون والهالبينو',
      nameEn: 'Loaded Cheesy Volcano Fries',
      descriptionAr: 'بطاطس متبلة مغطاة بطوفان من جبنة الشيدر الساخنة، شرائح بيكون مقرمش، وهالبينو مفروم.',
      descriptionEn: 'Crispy skin-on fries drowned in warm cheddar queso, crumbled beef bacon bits, and sliced pickled jalapeños.',
      price: 68.0,
      category: FoodCategory.sides,
      imageUrl: 'https://images.unsplash.com/photo-1585109649139-366815a0d713?w=600&auto=format&fit=crop&q=80',
      calories: 590,
      isPopular: true,
      canBeCombo: false,
    ),
    MenuItem(
      id: 's2',
      nameAr: 'أصابع موزاريلا مقرمشة مع مارينارا',
      nameEn: 'Artisan Mozzarella Sticks (5 pcs)',
      descriptionAr: 'أصابع جبنة موزاريلا طبيعية مغلفة بفتات الخبز الإيطالي المقرمش مع صلصة الطماطم بالأعشاب.',
      descriptionEn: '5 melted mozzarella batons coated in herb-seasoned breadcrumbs, served with warm marinara dipping sauce.',
      price: 58.0,
      category: FoodCategory.sides,
      imageUrl: 'https://images.unsplash.com/photo-1531749668029-2db88e4276c7?w=600&auto=format&fit=crop&q=80',
      calories: 420,
      canBeCombo: false,
    ),
    MenuItem(
      id: 's3',
      nameAr: 'بطاطس ويدجز متبلة بالأعشاب',
      nameEn: 'Seasoned Potato Wedges',
      descriptionAr: 'قطع بطاطس سميكة مخبوزة ومقلية مع البابريكا والأوريجانو والملح البحري.',
      descriptionEn: 'Thick-cut russet potato wedges tossed in smoked paprika, garlic herbs, and sea salt.',
      price: 42.0,
      category: FoodCategory.sides,
      imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=600&auto=format&fit=crop&q=80',
      calories: 360,
      canBeCombo: false,
    ),

    // Drinks
    MenuItem(
      id: 'd1',
      nameAr: 'شيك الفراولة الطبيعي بالكريمة',
      nameEn: 'Craft Strawberry Milkshake',
      descriptionAr: 'ميلك شيك محضر من حليب طبيعي، آيس كريم فانيليا، صوص الفراولة الطازجة، مغطى بالكريمة المخفوقة.',
      descriptionEn: 'Hand-spun vanilla gelato shake infused with fresh strawberry puree, crowned with chantilly whipped cream.',
      price: 52.0,
      category: FoodCategory.drinks,
      imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80',
      calories: 410,
      isPopular: true,
      canBeCombo: false,
    ),
    MenuItem(
      id: 'd2',
      nameAr: 'عصير ليموناضة بالنعناع المثلج',
      nameEn: 'Iced Mint Lemonade Frost',
      descriptionAr: 'عصير ليمون طازج معصور مع أوراق النعناع الأخضر والثلج المجروش المنعش.',
      descriptionEn: 'Freshly squeezed citrus lemonade blended with crisp garden mint leaves and crushed mountain ice.',
      price: 42.0,
      category: FoodCategory.drinks,
      imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&auto=format&fit=crop&q=80',
      calories: 120,
      canBeCombo: false,
    ),
    MenuItem(
      id: 'd3',
      nameAr: 'كوكاكولا زيرو / كلاسيك مثلجة',
      nameEn: 'Fountain Soda (Coke / Sprite / Fanta)',
      descriptionAr: 'مشروب غازي مثلج بحجم كبير مع مكعبات الثلج وشريحة ليمون.',
      descriptionEn: 'Free-refillable fountain soda served over crystal clear ice cubes with a fresh lemon twist.',
      price: 28.0,
      category: FoodCategory.drinks,
      imageUrl: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=600&auto=format&fit=crop&q=80',
      calories: 140,
      canBeCombo: false,
    ),

    // Desserts
    MenuItem(
      id: 'ds1',
      nameAr: 'مولتن لافا كيك بلجيكية ساخنة',
      nameEn: 'Belgian Molten Chocolate Lava',
      descriptionAr: 'كعكة شوكولاتة بلجيكية فاخرة مع قلب سائل يتدفق، تقدم مع بولة آيس كريم فانيليا بوربون.',
      descriptionEn: 'Warm dark Belgian chocolate sponge with a molten fudge core, served alongside Bourbon vanilla bean gelato.',
      price: 68.0,
      category: FoodCategory.desserts,
      imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=600&auto=format&fit=crop&q=80',
      calories: 590,
      isPopular: true,
      canBeCombo: false,
    ),
    MenuItem(
      id: 'ds2',
      nameAr: 'صنداي آيس كريم كراميل وبقان محمص',
      nameEn: 'Salted Caramel Pecan Sundae',
      descriptionAr: 'آيس كريم فانيليا كريمي غني بصوص الكراميل المملح، حبات البقان المحمصة، ورقائق الشوكولاتة.',
      descriptionEn: 'Silky vanilla soft serve drizzled with warm sea-salted caramel sauce and roasted butter pecans.',
      price: 48.0,
      category: FoodCategory.desserts,
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80',
      calories: 430,
      canBeCombo: false,
    ),
  ];
}
