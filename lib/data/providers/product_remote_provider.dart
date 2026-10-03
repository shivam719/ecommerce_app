import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_data.dart';

/// ProductRemoteProvider is responsible for making raw network requests
/// to the DummyJSON Products API endpoint.
class ProductRemoteProvider {
  static const String baseUrl = "https://dummyjson.com/products";

  /// Fetches products list with optional limit and skip for pagination
  Future<ProductData> fetchProducts({int limit = 100, int skip = 0}) async {
    final uri = Uri.parse("$baseUrl?limit=$limit&skip=$skip");
    
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw Exception("Network connection timeout. Please try again.");
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return ProductData.fromJson(jsonMap);
    } else {
      throw Exception("Failed to load products. Server returned status code ${response.statusCode}");
    }
  }

  /// Search products by keyword query
  Future<ProductData> searchProducts(String query) async {
    final uri = Uri.parse("$baseUrl/search?q=${Uri.encodeComponent(query)}");

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw Exception("Search request timed out.");
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return ProductData.fromJson(jsonMap);
    } else {
      throw Exception("Failed to search products.");
    }
  }
}
