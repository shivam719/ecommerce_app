import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_data.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/constants/app_colors.dart';

/// ProductDetailController manages state for the Product Detail Screen:
/// - Image gallery slider selection
/// - Item quantity
/// - Wishlist toggle
/// - Delegation of Add to Cart actions to global CartController
class ProductDetailController extends GetxController {
  late final Products product;
  final CartController cartController = Get.find<CartController>();

  // Rx state variables
  final RxInt selectedImageIndex = 0.obs;
  final RxInt quantity = 1.obs;
  final RxBool isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Products) {
      product = Get.arguments as Products;
    } else {
      Get.back();
    }
  }

  void setImageIndex(int index) {
    selectedImageIndex.value = index;
  }

  void incrementQuantity() {
    if (quantity.value < (product.stock ?? 99)) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    Get.snackbar(
      isFavorite.value ? 'Added to Wishlist' : 'Removed from Wishlist',
      product.title ?? 'Product',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isFavorite.value ? AppColors.primary : Colors.grey.shade800,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
    );
  }

  /// Adds item to global CartController
  void addToCart() {
    cartController.addToCart(product, quantity: quantity.value);
  }
}
