import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/network_controller.dart';
import '../../../data/models/product_data.dart';
import '../../../data/repositories/product_repository.dart';

enum ProductSortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
  discountHighToLow,
}

/// HomeController manages reactive state for the Home screen:
/// - Product list fetching and caching
/// - Real-time keyword search filtering
/// - Category chip filtering
/// - Sorting (Price Low-High, Price High-Low, Rating, Discount)
/// - Price range filtering
/// - Pull-to-refresh & network reconnection auto-refetch
class HomeController extends GetxController {
  final IProductRepository _repository;
  final NetworkController networkController = Get.find<NetworkController>();

  HomeController({required IProductRepository repository}) : _repository = repository;

  // Reactive state management for UI loading/success/error states
  final Rx<RxStatus> status = RxStatus.loading().obs;

  // Raw product list fetched from API
  final RxList<Products> allProducts = <Products>[].obs;

  // Reactive Search Query & Category Filter State
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  // Advanced Sorting & Price Range Filter State
  final Rx<ProductSortOption> sortOption = ProductSortOption.relevance.obs;
  final Rx<RangeValues> priceRange = const RangeValues(0, 2000).obs;

  // TextEditingController for the search input field
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();

    // Listen to network changes: if user was offline and comes back online, refetch if empty
    ever(networkController.isConnected, (bool isOnline) {
      if (isOnline && allProducts.isEmpty) {
        fetchProducts();
      }
    });

    // Debounce search query changes
    debounce(searchQuery, (_) => update(), time: const Duration(milliseconds: 300));
  }

  /// Fetches products from API repository
  Future<void> fetchProducts() async {
    try {
      status.value = RxStatus.loading();
      final productData = await _repository.getProducts();

      if (productData.products != null && productData.products!.isNotEmpty) {
        allProducts.assignAll(productData.products!);
        status.value = RxStatus.success();
      } else {
        status.value = RxStatus.empty();
      }
    } catch (e) {
      status.value = RxStatus.error(e.toString());
    }
  }

  /// Extracts unique categories from fetched product list
  List<String> get categories {
    final set = <String>{'All'};
    for (var p in allProducts) {
      if (p.category != null && p.category!.isNotEmpty) {
        final cat = p.category![0].toUpperCase() + p.category!.substring(1);
        set.add(cat);
      }
    }
    return set.toList();
  }

  /// Dynamically computes filtered and sorted products
  List<Products> get filteredProducts {
    List<Products> list = allProducts.where((product) {
      // Category Filter
      if (selectedCategory.value != 'All') {
        if (product.category?.toLowerCase() != selectedCategory.value.toLowerCase()) {
          return false;
        }
      }

      // Search Query Filter
      if (searchQuery.value.trim().isNotEmpty) {
        final query = searchQuery.value.trim().toLowerCase();
        final title = product.title?.toLowerCase() ?? '';
        final brand = product.brand?.toLowerCase() ?? '';
        final desc = product.description?.toLowerCase() ?? '';
        if (!title.contains(query) && !brand.contains(query) && !desc.contains(query)) {
          return false;
        }
      }

      // Price Range Filter
      final price = product.price ?? 0.0;
      if (price < priceRange.value.start || price > priceRange.value.end) {
        return false;
      }

      return true;
    }).toList();

    // Sorting
    switch (sortOption.value) {
      case ProductSortOption.priceLowToHigh:
        list.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
        break;
      case ProductSortOption.priceHighToLow:
        list.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        break;
      case ProductSortOption.ratingHighToLow:
        list.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case ProductSortOption.discountHighToLow:
        list.sort((a, b) => (b.discountPercentage ?? 0).compareTo(a.discountPercentage ?? 0));
        break;
      case ProductSortOption.relevance:
        break;
    }

    return list;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void setSortOption(ProductSortOption option) {
    sortOption.value = option;
  }

  void resetFilters() {
    selectedCategory.value = 'All';
    searchController.clear();
    searchQuery.value = '';
    sortOption.value = ProductSortOption.relevance;
    priceRange.value = const RangeValues(0, 2000);
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
