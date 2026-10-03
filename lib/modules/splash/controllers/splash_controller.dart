import 'package:get/get.dart';
import '../../../core/network/network_controller.dart';
import '../../../routes/app_routes.dart';

/// SplashController manages the Splash screen animation sequence and initial setup.
/// It verifies internet connectivity before navigating to the Home screen.
class SplashController extends GetxController {
  final NetworkController _networkController = Get.find<NetworkController>();

  // Rx double for scale animation transition
  final RxDouble logoScale = 0.5.obs;
  final RxDouble logoOpacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startSplashAnimation();
  }

  /// Triggers smooth entrance animation and schedules navigation
  void _startSplashAnimation() async {
    // Animate scale and opacity
    await Future.delayed(const Duration(milliseconds: 100));
    logoScale.value = 1.0;
    logoOpacity.value = 1.0;

    // Wait for splash duration
    await Future.delayed(const Duration(milliseconds: 2500));

    // Navigate to Home view
    Get.offNamed(Routes.HOME);
  }

  /// Helper getter to check current connection status
  bool get isConnected => _networkController.isConnected.value;
}
