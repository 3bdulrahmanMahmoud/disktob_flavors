import 'menu_item.dart';

class CartItem {
  final String uniqueId;
  final MenuItem item;
  final MealSize selectedSize;
  final bool isCombo;
  final List<String> removedIngredients;
  final List<ExtraOption> selectedExtras;
  int quantity;
  final String? specialNote;

  CartItem({
    required this.uniqueId,
    required this.item,
    required this.selectedSize,
    this.isCombo = false,
    this.removedIngredients = const [],
    this.selectedExtras = const [],
    this.quantity = 1,
    this.specialNote,
  });

  double get unitPrice {
    double total = item.price + selectedSize.extraPrice;
    if (isCombo) {
      total += item.comboPrice;
    }
    for (final extra in selectedExtras) {
      total += extra.price;
    }
    return total;
  }

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    MealSize? selectedSize,
    bool? isCombo,
    List<String>? removedIngredients,
    List<ExtraOption>? selectedExtras,
    int? quantity,
    String? specialNote,
  }) {
    return CartItem(
      uniqueId: uniqueId,
      item: item,
      selectedSize: selectedSize ?? this.selectedSize,
      isCombo: isCombo ?? this.isCombo,
      removedIngredients: removedIngredients ?? this.removedIngredients,
      selectedExtras: selectedExtras ?? this.selectedExtras,
      quantity: quantity ?? this.quantity,
      specialNote: specialNote ?? this.specialNote,
    );
  }
}
