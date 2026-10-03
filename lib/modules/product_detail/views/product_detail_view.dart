import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';
import '../../../data/models/product_data.dart';
import '../../../core/constants/app_colors.dart';

/// ProductDetailView provides an adaptive, responsive product details screen
/// supporting Single Column (Portrait) and Two-Pane Split View (Landscape / Tablet).
class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final product = controller.product;
    final images = product.images ?? [product.thumbnail ?? ''];
    final double price = product.price ?? 0.0;
    final double discount = product.discountPercentage ?? 0.0;
    final double originalPrice = discount > 0 ? price / (1 - (discount / 100)) : price;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;

          if (isWide) {
            // --- TWO-PANE TABLET / LANDSCAPE LAYOUT ---
            return SafeArea(
              child: Row(
                children: [
                  // Left Pane: Image Gallery
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Get.back(),
                          ),
                        ),
                        Expanded(
                          child: _buildImageGallery(isDark, images, product.id!),
                        ),
                      ],
                    ),
                  ),

                  // Right Pane: Product Details
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBrandAndStockRow(product, isDark),
                          const SizedBox(height: 12),
                          Text(product.title ?? '', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          _buildPriceAndRatingRow(price, discount, originalPrice, product.rating ?? 0.0),
                          const Divider(height: 32),
                          _buildDescriptionSection(theme, product, isDark),
                          const Divider(height: 32),
                          _buildSpecsSection(theme, product, isDark),
                          const SizedBox(height: 24),
                          _buildReviewsSection(theme, product, isDark),
                          const SizedBox(height: 32),
                          _buildAddToCartBar(context, price, isDark),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // --- STANDARD PORTRAIT LAYOUT ---
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 340,
                pinned: true,
                actions: [
                  Obx(() {
                    return IconButton(
                      icon: Icon(
                        controller.isFavorite.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: controller.isFavorite.value ? Colors.red : (isDark ? Colors.white : Colors.black),
                      ),
                      onPressed: controller.toggleFavorite,
                    );
                  }),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImageGallery(isDark, images, product.id!),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBrandAndStockRow(product, isDark),
                      const SizedBox(height: 12),
                      Text(product.title ?? '', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildPriceAndRatingRow(price, discount, originalPrice, product.rating ?? 0.0),
                      const Divider(height: 32),
                      _buildDescriptionSection(theme, product, isDark),
                      const Divider(height: 32),
                      _buildSpecsSection(theme, product, isDark),
                      const SizedBox(height: 24),
                      _buildReviewsSection(theme, product, isDark),
                      const SizedBox(height: 90), // Bottom Bar Spacing
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // Bottom Persistent Action Bar for Portrait
      bottomSheet: MediaQuery.of(context).size.width > 700
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: _buildAddToCartBar(context, price, isDark),
              ),
            ),
    );
  }

  Widget _buildImageGallery(bool isDark, List<String> images, int productId) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Obx(() {
          final currentUrl = images[controller.selectedImageIndex.value];
          return Hero(
            tag: 'product_image_$productId',
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: isDark ? Colors.black26 : Colors.grey.shade100,
              child: CachedNetworkImage(
                imageUrl: currentUrl,
                fit: BoxFit.contain,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image_rounded, size: 48),
              ),
            ),
          );
        }),

        if (images.length > 1)
          Positioned(
            bottom: 12,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(images.length, (index) {
                  return Obx(() {
                    final isSelected = controller.selectedImageIndex.value == index;
                    return GestureDetector(
                      onTap: () => controller.setImageIndex(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            imageUrl: images[index],
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  });
                }),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBrandAndStockRow(Products product, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            (product.brand ?? 'Generic').toUpperCase(),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            (product.category ?? 'General').toUpperCase(),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
          ),
        ),
        const Spacer(),
        Icon(
          (product.stock ?? 0) > 0 ? Icons.check_circle_rounded : Icons.cancel_rounded,
          size: 16,
          color: (product.stock ?? 0) > 0 ? AppColors.success : AppColors.error,
        ),
        const SizedBox(width: 4),
        Text(
          product.availabilityStatus ?? ((product.stock ?? 0) > 0 ? 'In Stock' : 'Out of Stock'),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: (product.stock ?? 0) > 0 ? AppColors.success : AppColors.error),
        ),
      ],
    );
  }

  Widget _buildPriceAndRatingRow(double price, double discount, double originalPrice, double rating) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.secondary, size: 16),
              const SizedBox(width: 4),
              Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        FittedBox(
          child: Row(
            children: [
              Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.success)),
              if (discount > 0) ...[
                const SizedBox(width: 8),
                Text('\$${originalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, color: Colors.grey.shade500, decoration: TextDecoration.lineThrough)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(ThemeData theme, Products product, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          product.description ?? 'No description available.',
          style: TextStyle(fontSize: 14, height: 1.5, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildSpecsSection(ThemeData theme, Products product, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Specifications', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _specRow('SKU', product.sku ?? 'N/A'),
              _specRow('Weight', '${product.weight ?? 0}g'),
              _specRow('Warranty', product.warrantyInformation ?? 'Standard Warranty'),
              _specRow('Shipping', product.shippingInformation ?? 'Standard Shipping'),
              _specRow('Return Policy', product.returnPolicy ?? '30 Days Return'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(ThemeData theme, Products product, bool isDark) {
    if (product.reviews == null || product.reviews!.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Reviews (${product.reviews!.length})', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...product.reviews!.map((rev) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(rev.reviewerName ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Row(
                        children: List.generate(5, (idx) => Icon(idx < (rev.rating ?? 0) ? Icons.star_rounded : Icons.star_outline_rounded, size: 13, color: AppColors.secondary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(rev.comment ?? '', style: const TextStyle(fontSize: 12)),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildAddToCartBar(BuildContext context, double price, bool isDark) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.remove_rounded, size: 18), onPressed: controller.decrementQuantity),
              Obx(() => Text('${controller.quantity.value}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
              IconButton(icon: const Icon(Icons.add_rounded, size: 18), onPressed: controller.incrementQuantity),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Obx(() {
              final total = price * controller.quantity.value;
              return Text('Add to Cart (\$${total.toStringAsFixed(2)})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
            }),
          ),
        ),
      ],
    );
  }

  Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}
