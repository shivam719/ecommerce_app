import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../../../core/constants/app_colors.dart';

/// SortFilterBottomSheet provides an interactive modal sheet for
/// sorting products and applying price range filters.
class SortFilterBottomSheet extends StatelessWidget {
  const SortFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Drag Handle & Title
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter & Sort',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.resetFilters();
                      Get.back();
                    },
                    child: const Text('Reset All'),
                  ),
                ],
              ),
              const Divider(),

              // Sort Option Section
              const SizedBox(height: 8),
              Text(
                'Sort By',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Obx(() {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _sortChip(controller, 'Relevance', ProductSortOption.relevance),
                    _sortChip(controller, 'Price: Low to High', ProductSortOption.priceLowToHigh),
                    _sortChip(controller, 'Price: High to Low', ProductSortOption.priceHighToLow),
                    _sortChip(controller, 'Rating: High to Low', ProductSortOption.ratingHighToLow),
                    _sortChip(controller, 'Discount', ProductSortOption.discountHighToLow),
                  ],
                );
              }),

              const SizedBox(height: 20),
              const Divider(),

              // Price Range Slider Section
              Text(
                'Price Range',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Obx(() {
                final range = controller.priceRange.value;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${range.start.round()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$${range.end.round()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    RangeSlider(
                      values: range,
                      min: 0,
                      max: 2000,
                      divisions: 40,
                      activeColor: AppColors.primary,
                      labels: RangeLabels(
                        '\$${range.start.round()}',
                        '\$${range.end.round()}',
                      ),
                      onChanged: (newRange) {
                        controller.priceRange.value = newRange;
                      },
                    ),
                  ],
                );
              }),

              const SizedBox(height: 20),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply Filter & Sort', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sortChip(HomeController controller, String label, ProductSortOption option) {
    final isSelected = controller.sortOption.value == option;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.setSortOption(option),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : null,
      ),
    );
  }
}
