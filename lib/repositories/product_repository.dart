import 'package:shopify/core/services/api_service.dart';
import 'package:shopify/core/services/connectivity_service.dart';
import 'package:shopify/core/services/database_service.dart';
import 'package:shopify/models/product.dart';

class ProductRepository {
  final ApiService apiService;
  final DatabaseService databaseService;
  final ConnectivityService connectivityService;

  ProductRepository({
    required this.apiService,
    required this.databaseService,
    required this.connectivityService,
  });

  Future<List<Product>> getProducts() async {
    try {
      if (await connectivityService.isConnected) {
        final products = await apiService.getProducts();
        await databaseService.saveProducts(products);
        return products;
      } else {
        return databaseService.getProducts();
      }
    } catch (e) {
      final localProducts = databaseService.getProducts();
      if (localProducts.isNotEmpty) {
        return localProducts;
      }
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      if (await connectivityService.isConnected) {
        final categories = await apiService.getCategories();
        await databaseService.saveCategories(categories);
        return categories;
      } else {
        return databaseService.getCategories();
      }
    } catch (e) {
      final localCategories = databaseService.getCategories();
      if (localCategories.isNotEmpty) {
        return localCategories;
      }
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      if (await connectivityService.isConnected) {
        return await apiService.getProductsByCategory(category);
      } else {
        // Filter local products by category
        return databaseService.getProducts()
            .where((product) => product.category == category)
            .toList();
      }
    } catch (e) {
      // Try to get local products filtered by category
      final localProducts = databaseService.getProducts()
          .where((product) => product.category == category)
          .toList();
      
      if (localProducts.isNotEmpty) {
        return localProducts;
      }
      throw Exception('Failed to load products by category: $e');
    }
  }

  List<Product> searchProducts(List<Product> products, String query) {
    if (query.isEmpty) {
      return products;
    }
    return products.where((product) => 
        product.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<Product> sortProducts(List<Product> products, SortOption sortOption) {
    final sortedProducts = List<Product>.from(products);
    switch (sortOption) {
      case SortOption.priceAsc:
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.ratingDesc:
        sortedProducts.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
        break;
      case SortOption.none:
        break;
    }
    return sortedProducts;
  }
}

enum SortOption {
  none,
  priceAsc,
  priceDesc,
  ratingDesc,
}