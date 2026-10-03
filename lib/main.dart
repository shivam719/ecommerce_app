import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'core/bindings/initial_binding.dart';
import 'core/constants/app_theme.dart';
import 'routes/app_pages.dart';

void main() {
  // Ensure Flutter engine bindings are initialized
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve Native Splash Screen while app initializes
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const EcommerceApp());

  // Remove Native Splash Screen once app widget tree is ready
  FlutterNativeSplash.remove();
}

/// EcommerceApp is the root widget configuring GetMaterialApp with:
/// - Pure GetX MVVM Route Mapping
/// - Global Dependencies Initial Binding
/// - Material 3 Light and Dark (Night) Themes
class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      
      // Global Bindings for Network & Theme Controllers
      initialBinding: InitialBinding(),

      // Route Configuration
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      // Theme Configuration for Light & Dark Mode Support
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      defaultTransition: Transition.cupertino,
    );
  }
}
