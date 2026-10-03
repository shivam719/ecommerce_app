import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';

/// ProductDetailBinding injects ProductDetailController when navigating to Routes.PRODUCT_DETAIL.
class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailController>(() => ProductDetailController());
  }
}
