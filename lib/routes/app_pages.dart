import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/splash/controllers/splash_controller.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/home/views/home_view.dart';
import '../modules/product_detail/controllers/product_detail_controller.dart';
import '../modules/product_detail/views/product_detail_view.dart';
import '../data/repositories/product_repository.dart';

/// AppPages configures central GetPage routes using modern functional BindingsBuilder.
class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SplashController>(() => SplashController());
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<IProductRepository>(() => ProductRepository());
        Get.lazyPut<HomeController>(
          () => HomeController(repository: Get.find<IProductRepository>()),
        );
      }),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductDetailController>(() => ProductDetailController());
      }),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
