import 'package:equatable/equatable.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/repositories/product_repository.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;
  final SortOption sortOption;
  final String? selectedCategory;

  const ProductLoaded({
    required this.products,
    required this.filteredProducts,
    this.searchQuery = '',
    this.sortOption = SortOption.none,
    this.selectedCategory,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
    SortOption? sortOption,
    String? selectedCategory,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    products, 
    filteredProducts, 
    searchQuery, 
    sortOption, 
    selectedCategory
  ];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}