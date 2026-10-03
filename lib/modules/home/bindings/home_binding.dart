import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/repositories/product_repository.dart';

/// HomeBinding injects ProductRepository and HomeController into the GetX dependency tree.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IProductRepository>(() => ProductRepository());
    Get.lazyPut<HomeController>(
      () => HomeController(repository: Get.find<IProductRepository>()),
    );
  }
}
