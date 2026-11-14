import 'menu_item.dart';

class CartItem {
  final String uniqueId;
  final MenuItem item;
  final List<ExtraOption> selectedExtras;
  int quantity;
  final String? note;

  CartItem({
    required this.uniqueId,
    required this.item,
    required this.selectedExtras,
    this.quantity = 1,
    this.note,
  });

  double get unitPrice {
    double total = item.price;
    for (final extra in selectedExtras) {
      total += extra.price;
    }
    return total;
  }

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    int? quantity,
    List<ExtraOption>? selectedExtras,
    String? note,
  }) {
    return CartItem(
      uniqueId: uniqueId,
      item: item,
      selectedExtras: selectedExtras ?? this.selectedExtras,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
