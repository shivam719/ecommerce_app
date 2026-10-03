import '../models/product_data.dart';
import '../providers/product_remote_provider.dart';

/// Abstract contract for ProductRepository following Clean Architecture principles
abstract class IProductRepository {
  Future<ProductData> getProducts({int limit = 100, int skip = 0});
  Future<ProductData> searchProducts(String query);
}

/// Concrete implementation of ProductRepository
class ProductRepository implements IProductRepository {
  final ProductRemoteProvider _remoteProvider;

  ProductRepository({ProductRemoteProvider? remoteProvider})
      : _remoteProvider = remoteProvider ?? ProductRemoteProvider();

  @override
  Future<ProductData> getProducts({int limit = 100, int skip = 0}) async {
    try {
      return await _remoteProvider.fetchProducts(limit: limit, skip: skip);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductData> searchProducts(String query) async {
    try {
      return await _remoteProvider.searchProducts(query);
    } catch (e) {
      rethrow;
    }
  }
}
