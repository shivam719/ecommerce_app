import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'widgets/product_card.dart';
import 'widgets/category_chip.dart';
import 'widgets/offline_banner.dart';
import 'widgets/product_shimmer.dart';
import 'widgets/sort_filter_bottom_sheet.dart';
import 'widgets/cart_bottom_sheet.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/constants/app_colors.dart';

/// HomeView provides a responsive, multi-device shopping layout
/// supporting Phone Portrait, Phone Landscape, and Tablet views with
/// Cart Badge counter, Filter/Sort modals, and Shimmer Grid Loading.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final CartController cartController = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.primaryLight.withValues(alpha: 0.2) : Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.shopping_bag_rounded,
                color: isDark ? AppColors.primaryLight : Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'E-Commerce App',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          // Shopping Cart Button with Real-time Badge Count
          Obx(() {
            final count = cartController.totalItemCount;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, size: 24),
                  tooltip: 'View Shopping Cart',
                  onPressed: () {
                    Get.bottomSheet(
                      const CartBottomSheet(),
                      isScrollControlled: true,
                    );
                  },
                ),
                if (count > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),

          // Dark / Light Mode Toggle Button
          Obx(() {
            return IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Icon(
                  themeController.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  key: ValueKey(themeController.isDarkMode),
                  color: themeController.isDarkMode ? Colors.amber : Colors.white,
                ),
              ),
              tooltip: themeController.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              onPressed: () => themeController.toggleTheme(),
            );
          }),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Top Offline Warning Banner
          const OfflineBanner(),

          // Search & Filter Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search products, brands...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: Obx(() {
                        if (controller.searchQuery.value.isNotEmpty) {
                          return IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: controller.clearSearch,
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Sort & Filter BottomSheet Button
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                    tooltip: 'Sort & Filter',
                    onPressed: () {
                      Get.bottomSheet(
                        const SortFilterBottomSheet(),
                        isScrollControlled: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Horizontal Category Filter Chips
          Obx(() {
            final categories = controller.categories;
            if (categories.length <= 1) return const SizedBox.shrink();

            return Container(
              height: 44,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Obx(() {
                    return CategoryChip(
                      label: cat,
                      isSelected: controller.selectedCategory.value == cat,
                      onTap: () => controller.selectCategory(cat),
                    );
                  });
                },
              ),
            );
          }),

          // Responsive Grid View with Adaptive Columns
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive Column Calculation
                final double width = constraints.maxWidth;
                final int crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);
                final double childAspectRatio = width > 900 ? 0.72 : (width > 600 ? 0.68 : 0.62);

                return Obx(() {
                  final status = controller.status.value;

                  // Skeleton Shimmer Loading State
                  if (status.isLoading) {
                    return ProductGridShimmer(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                    );
                  }

                  // Error State
                  if (status.isError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              'Unable to Load Products',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              status.errorMessage ?? 'Please check your internet connection.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: controller.fetchProducts,
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final products = controller.filteredProducts;

                  // Empty State
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'No products match your criteria',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try resetting filters or changing search keywords.',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: controller.resetFilters,
                            child: const Text('Reset All Filters'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Pull-to-Refresh GridView
                  return RefreshIndicator(
                    onRefresh: controller.fetchProducts,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: products[index]);
                      },
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
