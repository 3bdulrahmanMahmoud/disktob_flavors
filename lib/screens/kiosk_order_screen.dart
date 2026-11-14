import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../data/mock_data.dart';
import '../widgets/kiosk_header.dart';
import '../widgets/menu_card.dart';
import '../widgets/cart_panel.dart';
import '../widgets/checkout_dialog.dart';
import 'order_success_screen.dart';

class KioskOrderScreen extends StatefulWidget {
  final bool initialIsDineIn;
  final VoidCallback onCancelToWelcome;

  const KioskOrderScreen({
    super.key,
    required this.initialIsDineIn,
    required this.onCancelToWelcome,
  });

  @override
  State<KioskOrderScreen> createState() => _KioskOrderScreenState();
}

class _KioskOrderScreenState extends State<KioskOrderScreen> {
  late bool _isDineIn;
  FoodCategory _selectedCategory = FoodCategory.burgers;
  final List<CartItem> _cartItems = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Inactivity auto-reset timer (kiosk safety feature)
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    _isDineIn = widget.initialIsDineIn;
    _resetInactivityTimer();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    // 90 seconds of inactivity before returning to attract screen
    _inactivityTimer = Timer(const Duration(seconds: 120), () {
      if (mounted) {
        widget.onCancelToWelcome();
      }
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onUserInteraction() {
    _resetInactivityTimer();
  }

  void _addToCart(CartItem newItem) {
    _onUserInteraction();
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (ci) =>
            ci.item.id == newItem.item.id &&
            _areExtrasEqual(ci.selectedExtras, newItem.selectedExtras) &&
            ci.note == newItem.note,
      );

      if (existingIndex != -1) {
        _cartItems[existingIndex].quantity += newItem.quantity;
      } else {
        _cartItems.add(newItem);
      }
    });
  }

  bool _areExtrasEqual(List<ExtraOption> a, List<ExtraOption> b) {
    if (a.length != b.length) return false;
    final aIds = a.map((e) => e.id).toSet();
    final bIds = b.map((e) => e.id).toSet();
    return aIds.containsAll(bIds);
  }

  void _updateQuantity(String uniqueId, int newQty) {
    _onUserInteraction();
    setState(() {
      final index = _cartItems.indexWhere((ci) => ci.uniqueId == uniqueId);
      if (index != -1) {
        if (newQty <= 0) {
          _cartItems.removeAt(index);
        } else {
          _cartItems[index].quantity = newQty;
        }
      }
    });
  }

  void _removeItem(String uniqueId) {
    _onUserInteraction();
    setState(() {
      _cartItems.removeWhere((ci) => ci.uniqueId == uniqueId);
    });
  }

  void _clearCart() {
    _onUserInteraction();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد مسح السلة'),
        content: const Text('هل أنت متأكد من رغبتك في حذف جميع العناصر من الطلب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('تراجع'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => _cartItems.clear());
              Navigator.pop(ctx);
            },
            child: const Text('مسح الكل'),
          ),
        ],
      ),
    );
  }

  void _openCheckout() {
    _onUserInteraction();
    double subtotal = 0;
    for (final ci in _cartItems) {
      subtotal += ci.totalPrice;
    }
    final total = subtotal * 1.14;

    showDialog(
      context: context,
      builder: (ctx) => CheckoutDialog(
        totalAmount: total,
        isDineIn: _isDineIn,
        onPaymentSuccess: (method) {
          final orderNum = 100 + Random().nextInt(899);
          final itemsCopy = List<CartItem>.from(_cartItems);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSuccessScreen(
                orderNumber: orderNum,
                isDineIn: _isDineIn,
                paymentMethod: method,
                orderedItems: itemsCopy,
                grandTotal: total,
                onFinish: widget.onCancelToWelcome,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = MockData.menuItems.where((item) {
      final matchesCategory = item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.nameAr.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.nameEn.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Listener(
      onPointerDown: (_) => _onUserInteraction(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Column(
          children: [
            // Top Kiosk Header
            KioskHeader(
              isDineIn: _isDineIn,
              onToggleOrderType: () {
                setState(() => _isDineIn = !_isDineIn);
              },
              onCancelOrder: widget.onCancelToWelcome,
            ),

            // Main Body: Categories + Menu Items + Cart Panel
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth >= 900;

                  return Row(
                    children: [
                      // 1. Categories Sidebar (Navigation Rail)
                      Container(
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(left: BorderSide(color: Colors.grey.shade200)),
                        ),
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          children: FoodCategory.values.map((cat) {
                            final isSelected = cat == _selectedCategory;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: InkWell(
                                onTap: () {
                                  _onUserInteraction();
                                  setState(() => _selectedCategory = cat);
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFFF5722) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFFFF5722).withValues(alpha: 0.35),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        cat.icon,
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        cat.nameAr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? Colors.white : Colors.grey.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // 2. Middle: Menu Items Grid
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search & Category Banner
                              Row(
                                children: [
                                  Text(
                                    '${_selectedCategory.icon} ${_selectedCategory.nameAr}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${filteredItems.length} وجبة',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Quick Search Field
                                  SizedBox(
                                    width: 260,
                                    height: 42,
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (val) {
                                        setState(() => _searchQuery = val.trim());
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'ابحث عن وجبة...',
                                        hintStyle: const TextStyle(fontSize: 13),
                                        prefixIcon: const Icon(Icons.search, size: 20),
                                        suffixIcon: _searchQuery.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(Icons.clear, size: 18),
                                                onPressed: () {
                                                  _searchController.clear();
                                                  setState(() => _searchQuery = '');
                                                },
                                              )
                                            : null,
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Items Grid
                              Expanded(
                                child: filteredItems.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade400),
                                            const SizedBox(height: 12),
                                            const Text(
                                              'لم نجد أي وجبة مطابقة لبحثك',
                                              style: TextStyle(fontSize: 16, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GridView.builder(
                                        itemCount: filteredItems.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: isWideScreen ? 3 : 2,
                                          childAspectRatio: 0.78,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                        ),
                                        itemBuilder: (context, index) {
                                          return MenuCard(
                                            item: filteredItems[index],
                                            onAddToCart: _addToCart,
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 3. Right: Cart Panel (Always visible in Kiosk mode)
                      SizedBox(
                        width: isWideScreen ? 360 : 310,
                        child: CartPanel(
                          cartItems: _cartItems,
                          onUpdateQuantity: _updateQuantity,
                          onRemoveItem: _removeItem,
                          onClearCart: _clearCart,
                          onCheckout: _openCheckout,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
