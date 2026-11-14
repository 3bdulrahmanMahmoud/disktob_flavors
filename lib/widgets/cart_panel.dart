import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../utils/app_strings.dart';

class CartPanel extends StatelessWidget {
  final List<CartItem> cartItems;
  final bool isArabic;
  final Function(String uniqueId, int newQty) onUpdateQuantity;
  final Function(String uniqueId) onRemoveItem;
  final VoidCallback onClearCart;
  final VoidCallback onCheckout;

  const CartPanel({
    super.key,
    required this.cartItems,
    required this.isArabic,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
    required this.onClearCart,
    required this.onCheckout,
  });

  double get subtotal {
    double sum = 0;
    for (final item in cartItems) {
      sum += item.totalPrice;
    }
    return sum;
  }

  double get vat => subtotal * 0.14;
  double get grandTotal => subtotal + vat;

  @override
  Widget build(BuildContext context) {
    final curr = AppStrings.currency(isArabic);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_rounded, color: Color(0xFFFF5722), size: 24),
                const SizedBox(width: 8),
                Text(
                  '${AppStrings.orderSummary(isArabic)} (${cartItems.length})',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const Spacer(),
                if (cartItems.isNotEmpty)
                  TextButton.icon(
                    onPressed: onClearCart,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text(
                      AppStrings.clear(isArabic),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),

          // Items List or Empty State
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_basket_outlined,
                              size: 64,
                              color: Colors.orange.shade300,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.emptyCartTitle(isArabic),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.emptyCartSubtitle(isArabic),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mini Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 54,
                              height: 54,
                              child: Image.network(
                                item.item.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.orange.shade100,
                                  child: Center(
                                    child: Text(item.item.category.icon, style: const TextStyle(fontSize: 22)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.item.name(isArabic),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF1E1E1E),
                                  ),
                                ),
                                // Size & Combo tags
                                Row(
                                  children: [
                                    if (item.selectedSize.extraPrice > 0)
                                      Container(
                                        margin: const EdgeInsets.only(top: 2, right: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          item.selectedSize.name(isArabic),
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    if (item.isCombo)
                                      Container(
                                        margin: const EdgeInsets.only(top: 2),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          isArabic ? '🍟 كومبو' : '🍟 Combo',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange.shade900,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (item.removedIngredients.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      item.removedIngredients.join('، '),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.red.shade700,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                if (item.selectedExtras.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      item.selectedExtras.map((e) => '+ ${e.name(isArabic)}').join(', '),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                if (item.specialNote != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      '${isArabic ? "ملاحظة" : "Note"}: ${item.specialNote}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                        color: Color(0xFFD84315),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 6),
                                Text(
                                  '${item.totalPrice.toStringAsFixed(0)} $curr',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: Color(0xFFE65100),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Quantity Stepper
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  iconSize: 18,
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                  icon: Icon(
                                    item.quantity == 1 ? Icons.delete_outline : Icons.remove,
                                    color: item.quantity == 1 ? Colors.red : Colors.grey.shade800,
                                  ),
                                  onPressed: () {
                                    if (item.quantity == 1) {
                                      onRemoveItem(item.uniqueId);
                                    } else {
                                      onUpdateQuantity(item.uniqueId, item.quantity - 1);
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ),
                                IconButton(
                                  iconSize: 18,
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                  icon: const Icon(Icons.add),
                                  onPressed: () => onUpdateQuantity(item.uniqueId, item.quantity + 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),

          // Total & Checkout Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.subtotal(isArabic), style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    Text('${subtotal.toStringAsFixed(0)} $curr', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.vat(isArabic), style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    Text('${vat.toStringAsFixed(1)} $curr', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.total(isArabic),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    Text(
                      '${grandTotal.toStringAsFixed(0)} $curr',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF5722),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cartItems.isEmpty ? Colors.grey.shade400 : const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: cartItems.isEmpty ? 0 : 3,
                    ),
                    onPressed: cartItems.isEmpty ? null : onCheckout,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.payment_rounded, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.checkoutBtn(isArabic),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
