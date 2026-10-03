import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_data.dart';
import '../constants/app_colors.dart';

/// CartItem represents an item entry stored inside the user's shopping cart.
class CartItem {
  final Products product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => (product.price ?? 0.0) * quantity;
}

/// CartController manages global reactive state for shopping cart operations:
/// - Reactive item list & real-time badge count
/// - Adding/removing items
/// - Quantity updates
/// - Total price calculation
class CartController extends GetxController {
  // Reactive list of CartItem objects
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  /// Returns total number of individual items in the cart
  int get totalItemCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Calculates total price of all items in cart
  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Adds product to cart or increments quantity if already present
  void addToCart(Products product, {int quantity = 1}) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      cartItems[index].quantity += quantity;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product, quantity: quantity));
    }

    _showCartSnackBar(
      title: "Added to Cart",
      message: "${product.title} added to your cart.",
      icon: Icons.shopping_bag_rounded,
    );
  }

  /// Updates quantity for a specific product ID
  void updateQuantity(int productId, int delta) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      final newQty = cartItems[index].quantity + delta;
      if (newQty > 0) {
        cartItems[index].quantity = newQty;
        cartItems.refresh();
      } else {
        removeFromCart(productId);
      }
    }
  }

  /// Removes an item completely from cart
  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
    _showCartSnackBar(
      title: "Item Removed",
      message: "Product removed from cart.",
      icon: Icons.delete_outline_rounded,
      backgroundColor: Colors.grey.shade800,
    );
  }

  /// Clears all cart items
  void clearCart() {
    cartItems.clear();
  }

  /// Helper snackbar feedback
  void _showCartSnackBar({
    required String title,
    required String message,
    required IconData icon,
    Color backgroundColor = AppColors.success,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: Colors.white, size: 24),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
    );
  }
}
