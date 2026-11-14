class AppStrings {
  static String tr(bool isAr, String ar, String en) => isAr ? ar : en;

  static String currency(bool isAr) => isAr ? 'ج.م' : 'EGP';

  static String appTitle(bool isAr) =>
      isAr ? 'برجر كينجدوم • كشك الخدمة الذاتية' : 'BURGER KINGDOM • Self-Ordering Kiosk';

  static String branchName(bool isAr) =>
      isAr ? 'فرع النيل - كشك رقم 03' : 'Nile Branch - Kiosk #03';

  static String dineIn(bool isAr) => isAr ? 'تناول بالمطعم' : 'Dine-In';
  static String takeaway(bool isAr) => isAr ? 'طلب سفري' : 'Takeaway';

  static String orderSummary(bool isAr) => isAr ? 'ملخص الفاتورة' : 'Order Summary';
  static String subtotal(bool isAr) => isAr ? 'المجموع الفرعي:' : 'Subtotal:';
  static String vat(bool isAr) => isAr ? 'ضريبة القيمة المضافة (14%):' : 'VAT (14%):';
  static String total(bool isAr) => isAr ? 'الإجمالي الكلي:' : 'Grand Total:';
  static String checkoutBtn(bool isAr) => isAr ? 'إتمام الطلب والدفع' : 'Proceed to Checkout';

  static String emptyCartTitle(bool isAr) => isAr ? 'سلة طلبك فارغة' : 'Your tray is empty';
  static String emptyCartSubtitle(bool isAr) =>
      isAr ? 'المس أي وجبة شهية من القائمة للبدء' : 'Select delicious items from the menu to start';

  static String searchHint(bool isAr) => isAr ? 'ابحث في القائمة...' : 'Search menu...';
  static String clear(bool isAr) => isAr ? 'مسح' : 'Clear';
  static String cancelOrder(bool isAr) => isAr ? 'إلغاء الطلب' : 'Cancel Order';

  static String customize(bool isAr) => isAr ? 'تخصيص' : 'Customize';
  static String addToOrder(bool isAr) => isAr ? 'إضافة إلى الطلب' : 'Add to Order';

  static String makeCombo(bool isAr) => isAr ? 'ترقية إلى وجبة كومبو' : 'Upgrade to Combo Meal';
  static String comboDesc(bool isAr) =>
      isAr ? 'تشمل بطاطس مقلية ذهبية مقرمشة + مشروب غازي مثلج' : 'Includes golden crispy fries + ice cold soft drink';

  static String chooseSize(bool isAr) => isAr ? 'اختر الحجم:' : 'Select Size:';
  static String removeIngredients(bool isAr) => isAr ? 'تفضيلات المكونات (حذف):' : 'Ingredient Preferences:';
  static String addExtras(bool isAr) => isAr ? 'إضافات مميزة:' : 'Special Add-ons:';
  static String chefNotes(bool isAr) => isAr ? 'ملاحظات خاصة للمطبخ' : 'Special Kitchen Instructions';

  static String areYouThere(bool isAr) => isAr ? 'هل ما زلت بحاجة للوقت؟' : 'Are you still there?';
  static String timeoutPrompt(bool isAr) => isAr
      ? 'ستتم العودة للشاشة الرئيسية لحماية بياناتك خلال'
      : 'The kiosk will reset to protect your privacy in';
  static String keepOrdering(bool isAr) => isAr ? 'نعم، استمر في الطلب' : 'Yes, continue ordering';
  static String resetNow(bool isAr) => isAr ? 'إلغاء والعودة للبداية' : 'Cancel and Reset';
}
