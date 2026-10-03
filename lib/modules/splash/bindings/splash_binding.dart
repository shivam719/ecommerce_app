import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

/// SplashBinding injects the SplashController when navigating to Routes.SPLASH.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
