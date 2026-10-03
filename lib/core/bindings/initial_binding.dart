import 'package:get/get.dart';
import '../network/network_controller.dart';
import '../theme/theme_controller.dart';
import '../controllers/cart_controller.dart';

/// InitialBinding registers all global services and controllers when the app launches.
/// Uses GetX permanent controllers so they remain active across all route changes.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // NetworkController tracks WiFi & mobile internet status
    Get.put<NetworkController>(NetworkController(), permanent: true);

    // ThemeController manages Light/Dark theme switching
    Get.put<ThemeController>(ThemeController(), permanent: true);

    // CartController manages shopping cart items and badge counts
    Get.put<CartController>(CartController(), permanent: true);
  }
}
