import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/cart_controller.dart';
import '../../../../core/constants/app_colors.dart';

/// CartBottomSheet displays an interactive shopping cart drawer
/// listing items, quantity selectors, price totals, and checkout button.
class CartBottomSheet extends GetView<CartController> {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle & Title Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_cart_rounded, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Your Cart',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Obx(() {
                  if (controller.cartItems.isEmpty) return const SizedBox.shrink();
                  return TextButton(
                    onPressed: () => controller.clearCart(),
                    child: const Text('Clear All', style: TextStyle(color: AppColors.error)),
                  );
                }),
              ],
            ),
            const Divider(),

            // Cart Items List / Empty State
            Expanded(
              child: Obx(() {
                if (controller.cartItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.remove_shopping_cart_outlined,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text(
                          'Your cart is empty',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Explore products and add items to your cart.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: controller.cartItems.length,
                  separatorBuilder: (_, __) => const Divider(height: 16),
                  itemBuilder: (context, index) {
                    final item = controller.cartItems[index];
                    final product = item.product;

                    return Row(
                      children: [
                        // Thumbnail Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: isDark ? Colors.black26 : Colors.grey.shade100,
                            child: CachedNetworkImage(
                              imageUrl: product.thumbnail ?? product.images?.firstOrNull ?? '',
                              fit: BoxFit.contain,
                              placeholder: (_, __) => const Center(
                                child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                              ),
                              errorWidget: (_, __, ___) => const Icon(Icons.broken_image_rounded, size: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title & Price Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${(product.price ?? 0.0).toStringAsFixed(2)} x ${item.quantity}',
                                style: TextStyle(
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Quantity Counter Buttons
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_rounded, size: 16),
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                padding: EdgeInsets.zero,
                                onPressed: () => controller.updateQuantity(product.id!, -1),
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_rounded, size: 16),
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                padding: EdgeInsets.zero,
                                onPressed: () => controller.updateQuantity(product.id!, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                          onPressed: () => controller.removeFromCart(product.id!),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            // Checkout Summary & Button
            Obx(() {
              if (controller.cartItems.isEmpty) return const SizedBox.shrink();

              return Column(
                children: [
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        '\$${controller.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                          'Order Placed Successfully!',
                          'Thank you for your purchase of \$${controller.totalPrice.toStringAsFixed(2)}',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: AppColors.success,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 4),
                        );
                        controller.clearCart();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: const Text('Proceed to Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
