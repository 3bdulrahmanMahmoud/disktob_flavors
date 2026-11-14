import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../data/mock_data.dart';
import '../utils/app_strings.dart';
import '../widgets/kiosk_header.dart';
import '../widgets/promo_banner.dart';
import '../widgets/menu_card.dart';
import '../widgets/cart_panel.dart';
import '../widgets/checkout_dialog.dart';
import '../widgets/table_tracker_dialog.dart';
import '../widgets/inactivity_warning_dialog.dart';
import 'order_success_screen.dart';

class KioskOrderScreen extends StatefulWidget {
  final bool initialIsDineIn;
  final String? initialTableNumber;
  final bool initialIsArabic;
  final VoidCallback onCancelToWelcome;

  const KioskOrderScreen({
    super.key,
    required this.initialIsDineIn,
    this.initialTableNumber,
    required this.initialIsArabic,
    required this.onCancelToWelcome,
  });

  @override
  State<KioskOrderScreen> createState() => _KioskOrderScreenState();
}

class _KioskOrderScreenState extends State<KioskOrderScreen> {
  late bool _isDineIn;
  String? _tableNumber;
  late bool _isArabic;

  FoodCategory _selectedCategory = FoodCategory.burgers;
  final List<CartItem> _cartItems = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Inactivity management
  Timer? _inactivityTimer;
  bool _isWarningOpen = false;

  @override
  void initState() {
    super.initState();
    _isDineIn = widget.initialIsDineIn;
    _tableNumber = widget.initialTableNumber;
    _isArabic = widget.initialIsArabic;
    _resetInactivityTimer();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    // 75 seconds before popping warning modal
    _inactivityTimer = Timer(const Duration(seconds: 75), () {
      if (mounted && !_isWarningOpen) {
        _showInactivityWarning();
      }
    });
  }

  void _showInactivityWarning() {
    _isWarningOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => InactivityWarningDialog(
        isArabic: _isArabic,
        onContinue: () {
          _isWarningOpen = false;
          Navigator.pop(ctx);
          _resetInactivityTimer();
        },
        onTimeout: () {
          _isWarningOpen = false;
          Navigator.pop(ctx);
          widget.onCancelToWelcome();
        },
      ),
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onUserInteraction() {
    if (!_isWarningOpen) {
      _resetInactivityTimer();
    }
  }

  void _addToCart(CartItem newItem) {
    _onUserInteraction();
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (ci) =>
            ci.item.id == newItem.item.id &&
            ci.selectedSize == newItem.selectedSize &&
            ci.isCombo == newItem.isCombo &&
            _areExtrasEqual(ci.selectedExtras, newItem.selectedExtras) &&
            _areRemovalsEqual(ci.removedIngredients, newItem.removedIngredients) &&
            ci.specialNote == newItem.specialNote,
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

  bool _areRemovalsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    return a.toSet().containsAll(b.toSet());
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
        title: Text(_isArabic ? 'تأكيد مسح السلة' : 'Clear Tray Confirmation'),
        content: Text(
          _isArabic
              ? 'هل أنت متأكد من رغبتك في حذف جميع العناصر من الطلب؟'
              : 'Are you sure you want to remove all items from your order?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_isArabic ? 'تراجع' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => _cartItems.clear());
              Navigator.pop(ctx);
            },
            child: Text(_isArabic ? 'مسح الكل' : 'Clear All'),
          ),
        ],
      ),
    );
  }

  void _toggleOrderType() {
    _onUserInteraction();
    if (!_isDineIn) {
      // Switch from takeaway to dine-in: Ask for table tracker
      showDialog(
        context: context,
        builder: (ctx) => TableTrackerDialog(
          isArabic: _isArabic,
          onConfirm: (tbl) {
            Navigator.pop(ctx);
            setState(() {
              _isDineIn = true;
              _tableNumber = tbl;
            });
          },
          onSkip: () {
            Navigator.pop(ctx);
            setState(() {
              _isDineIn = true;
              _tableNumber = null;
            });
          },
        ),
      );
    } else {
      setState(() {
        _isDineIn = false;
        _tableNumber = null;
      });
    }
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
        isArabic: _isArabic,
        isDineIn: _isDineIn,
        tableNumber: _tableNumber,
        onPaymentSuccess: (method, authCode) {
          final orderNum = 100 + Random().nextInt(899);
          final itemsCopy = List<CartItem>.from(_cartItems);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSuccessScreen(
                orderNumber: orderNum,
                isArabic: _isArabic,
                isDineIn: _isDineIn,
                tableNumber: _tableNumber,
                paymentMethod: method,
                authCode: authCode,
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

    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Listener(
        onPointerDown: (_) => _onUserInteraction(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: Column(
            children: [
              // Top Enterprise Kiosk Header
              KioskHeader(
                isArabic: _isArabic,
                isDineIn: _isDineIn,
                tableNumber: _tableNumber,
                onToggleLanguage: () {
                  setState(() => _isArabic = !_isArabic);
                },
                onToggleOrderType: _toggleOrderType,
                onCancelOrder: widget.onCancelToWelcome,
              ),

              // Main Body: Categories + Menu Items + Cart Panel
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWideScreen = constraints.maxWidth >= 950;

                    return Row(
                      children: [
                        // 1. Categories Sidebar (Navigation Rail)
                        Container(
                          width: 145,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              left: _isArabic ? BorderSide(color: Colors.grey.shade200) : BorderSide.none,
                              right: _isArabic ? BorderSide.none : BorderSide(color: Colors.grey.shade200),
                            ),
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
                                        Text(cat.icon, style: const TextStyle(fontSize: 32)),
                                        const SizedBox(height: 6),
                                        Text(
                                          cat.name(_isArabic),
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

                        // 2. Middle: Menu Items Grid & Promo Ticker
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Special Offers Banner
                                PromoBanner(isArabic: _isArabic),

                                // Category Bar & Search
                                Row(
                                  children: [
                                    Text(
                                      '${_selectedCategory.icon} ${_selectedCategory.name(_isArabic)}',
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
                                        '${filteredItems.length} ${_isArabic ? "وجبة" : "items"}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    // Search Bar
                                    SizedBox(
                                      width: 260,
                                      height: 42,
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (val) {
                                          setState(() => _searchQuery = val.trim());
                                        },
                                        decoration: InputDecoration(
                                          hintText: AppStrings.searchHint(_isArabic),
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
                                              Text(
                                                _isArabic
                                                    ? 'لم نجد أي وجبة مطابقة لبحثك'
                                                    : 'No items match your search',
                                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        )
                                      : GridView.builder(
                                          itemCount: filteredItems.length,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: isWideScreen ? 3 : 2,
                                            childAspectRatio: 0.77,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 16,
                                          ),
                                          itemBuilder: (context, index) {
                                            return MenuCard(
                                              item: filteredItems[index],
                                              isArabic: _isArabic,
                                              onAddToCart: _addToCart,
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 3. Right: Sticky Cart Panel
                        SizedBox(
                          width: isWideScreen ? 360 : 310,
                          child: CartPanel(
                            cartItems: _cartItems,
                            isArabic: _isArabic,
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
      ),
    );
  }
}
