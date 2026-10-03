import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';

/// NetworkController is a reactive GetX controller that monitors live network connectivity.
/// It alerts the user when internet connection is lost or restored.
class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // RxBool to observe network status across screens reactively
  final RxBool isConnected = true.obs;
  
  // Track if initial check was performed
  bool isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  /// Initial connectivity check on startup
  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
      isInitialized = true;
    } catch (e) {
      debugPrint("Error checking initial connectivity: $e");
    }
  }

  /// Event handler for network status updates
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool hasConnection = results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);

    // If connectivity state changed after initialization, inform the user
    if (isInitialized && isConnected.value != hasConnection) {
      if (!hasConnection) {
        _showConnectivitySnackBar(
          title: "No Internet Connection",
          message: "Please check your Wi-Fi or mobile data network.",
          backgroundColor: AppColors.offlineBar,
          icon: Icons.wifi_off_rounded,
        );
      } else {
        _showConnectivitySnackBar(
          title: "Back Online",
          message: "Internet connection restored.",
          backgroundColor: AppColors.onlineBar,
          icon: Icons.wifi_rounded,
        );
      }
    }

    isConnected.value = hasConnection;
  }

  /// Displays a smooth custom GetX snackbar for connection changes
  void _showConnectivitySnackBar({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: Colors.white, size: 28),
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
