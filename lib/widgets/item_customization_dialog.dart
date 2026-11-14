import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../utils/app_strings.dart';

class ItemCustomizationDialog extends StatefulWidget {
  final MenuItem item;
  final bool isArabic;
  final Function(CartItem) onAddToCart;

  const ItemCustomizationDialog({
    super.key,
    required this.item,
    required this.isArabic,
    required this.onAddToCart,
  });

  @override
  State<ItemCustomizationDialog> createState() => _ItemCustomizationDialogState();
}

class _ItemCustomizationDialogState extends State<ItemCustomizationDialog> {
  late MealSize _selectedSize;
  bool _isCombo = false;
  final List<String> _removedIngredients = [];
  final List<ExtraOption> _selectedExtras = [];
  int _quantity = 1;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.item.availableSizes.first;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    double unitPrice = widget.item.price + _selectedSize.extraPrice;
    if (_isCombo) {
      unitPrice += widget.item.comboPrice;
    }
    for (final extra in _selectedExtras) {
      unitPrice += extra.price;
    }
    return unitPrice * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.isArabic;
    final curr = AppStrings.currency(isAr);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 760),
        child: Column(
          children: [
            // Top Image Banner & Badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: AspectRatio(
                    aspectRatio: 16 / 7.5,
                    child: Image.network(
                      widget.item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.amber.shade100,
                        child: Center(
                          child: Text(widget.item.category.icon, style: const TextStyle(fontSize: 64)),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha: 0.65),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '🔥 ${widget.item.calories} ${isAr ? "سعرة حرارية" : "kcal"}',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            // Scrollable Customization Options
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Item Name & Base Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.name(isAr),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            Text(
                              isAr ? widget.item.nameEn : widget.item.nameAr,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5722),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.item.price.toStringAsFixed(0)} $curr',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.item.description(isAr),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                  ),
                  const Divider(height: 32),

                  // 1. Size Selection
                  Text(
                    AppStrings.chooseSize(isAr),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: widget.item.availableSizes.map((size) {
                      final isSelected = size == _selectedSize;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () => setState(() => _selectedSize = size),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFFFF3E0) : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFFFF5722) : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    size.name(isAr),
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      color: isSelected ? const Color(0xFFE65100) : Colors.grey.shade800,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    size.extraPrice == 0
                                        ? (isAr ? 'السعر الأساسي' : 'Base')
                                        : '+${size.extraPrice.toStringAsFixed(0)} $curr',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? const Color(0xFFE65100) : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // 2. Combo Upgrade Card
                  if (widget.item.canBeCombo) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber.shade50, Colors.orange.shade50],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isCombo ? const Color(0xFFFF9800) : Colors.orange.shade200,
                          width: _isCombo ? 2 : 1,
                        ),
                      ),
                      child: SwitchListTile(
                        activeThumbColor: const Color(0xFFFF5722),
                        value: _isCombo,
                        onChanged: (val) => setState(() => _isCombo = val),
                        title: Row(
                          children: [
                            const Text('🍟🥤 ', style: TextStyle(fontSize: 18)),
                            Text(
                              AppStrings.makeCombo(isAr),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const Spacer(),
                            Text(
                              '+${widget.item.comboPrice.toStringAsFixed(0)} $curr',
                              style: const TextStyle(
                                color: Color(0xFFE65100),
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            AppStrings.comboDesc(isAr),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 3. Removable Ingredients
                  Text(
                    AppStrings.removeIngredients(isAr),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (isAr
                            ? widget.item.removableIngredientsAr
                            : widget.item.removableIngredientsEn)
                        .map((ing) {
                      final isRemoved = _removedIngredients.contains(ing);
                      return FilterChip(
                        selected: isRemoved,
                        selectedColor: Colors.red.shade100,
                        backgroundColor: Colors.grey.shade100,
                        checkmarkColor: Colors.red.shade800,
                        label: Text(
                          ing,
                          style: TextStyle(
                            fontSize: 13,
                            color: isRemoved ? Colors.red.shade900 : Colors.grey.shade800,
                            fontWeight: isRemoved ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _removedIngredients.add(ing);
                            } else {
                              _removedIngredients.remove(ing);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const Divider(height: 32),

                  // 4. Extras Selection
                  if (widget.item.availableExtras.isNotEmpty) ...[
                    Text(
                      AppStrings.addExtras(isAr),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...widget.item.availableExtras.map((extra) {
                      final isSelected = _selectedExtras.contains(extra);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFF3E0) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFF5722) : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: CheckboxListTile(
                          activeColor: const Color(0xFFFF5722),
                          value: isSelected,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedExtras.add(extra);
                              } else {
                                _selectedExtras.remove(extra);
                              }
                            });
                          },
                          title: Text(
                            extra.name(isAr),
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          secondary: Text(
                            '+${extra.price.toStringAsFixed(0)} $curr',
                            style: const TextStyle(
                              color: Color(0xFFE65100),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }),
                    const Divider(height: 32),
                  ],

                  // 5. Special Notes
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: AppStrings.chefNotes(isAr),
                      hintText: isAr ? 'مثال: بدون كاتشب، زيادة مناديل...' : 'e.g. Extra napkins, no sauce...',
                      prefixIcon: const Icon(Icons.edit_note_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),

            // Sticky Bottom Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  // Quantity adjusters
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Add to Order Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5722),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                      onPressed: () {
                        final cartItem = CartItem(
                          uniqueId: DateTime.now().microsecondsSinceEpoch.toString(),
                          item: widget.item,
                          selectedSize: _selectedSize,
                          isCombo: _isCombo,
                          removedIngredients: List.from(_removedIngredients),
                          selectedExtras: List.from(_selectedExtras),
                          quantity: _quantity,
                          specialNote: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                        );
                        widget.onAddToCart(cartItem);
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_shopping_cart_rounded, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            '${AppStrings.addToOrder(isAr)} (${_totalPrice.toStringAsFixed(0)} $curr)',
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
      ),
    );
  }
}
