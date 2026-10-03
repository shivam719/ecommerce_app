import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/network_controller.dart';
import '../../../../core/constants/app_colors.dart';

/// OfflineBanner displays an animated red top warning banner
/// whenever internet connectivity is disconnected.
class OfflineBanner extends GetView<NetworkController> {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isConnected.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        color: AppColors.offlineBar,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'No Internet Connection. Showing cached content.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    });
  }
}
