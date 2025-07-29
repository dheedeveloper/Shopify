import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopify/models/product.dart';

class DatabaseService {
  static const String productsBoxName = 'products';
  static const String categoriesBoxName = 'categories';
  static const String themeBoxName = 'theme';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(RatingAdapter());
    
    await Hive.openBox<Product>(productsBoxName);
    await Hive.openBox<String>(categoriesBoxName);
    await Hive.openBox<bool>(themeBoxName);
  }

  // Products methods
  Future<void> saveProducts(List<Product> products) async {
    final box = Hive.box<Product>(productsBoxName);
    await box.clear();
    for (var product in products) {
      await box.put(product.id, product);
    }
  }

  List<Product> getProducts() {
    final box = Hive.box<Product>(productsBoxName);
    return box.values.toList();
  }

  // Categories methods
  Future<void> saveCategories(List<String> categories) async {
    final box = Hive.box<String>(categoriesBoxName);
    await box.clear();
    for (int i = 0; i < categories.length; i++) {
      await box.put(i, categories[i]);
    }
  }

  List<String> getCategories() {
    final box = Hive.box<String>(categoriesBoxName);
    return box.values.toList();
  }

  // Theme methods
  Future<void> saveTheme(bool isDarkMode) async {
    final box = Hive.box<bool>(themeBoxName);
    await box.put('isDarkMode', isDarkMode);
  }

  bool getTheme() {
    final box = Hive.box<bool>(themeBoxName);
    return box.get('isDarkMode', defaultValue: false) ?? false;
  }
}