import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopify/blocs/product/product_event.dart';
import 'package:shopify/blocs/product/product_state.dart';
import 'package:shopify/repositories/product_repository.dart';

import '../../models/product.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  
  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<SearchProducts>(_onSearchProducts);
    on<SortProducts>(_onSortProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts();
      emit(ProductLoaded(
        products: products,
        filteredProducts: products,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = event.category == 'all' 
          ? await repository.getProducts()
          : await repository.getProductsByCategory(event.category);
      
      emit(ProductLoaded(
        products: await repository.getProducts(),
        filteredProducts: products,
        selectedCategory: event.category == 'all' ? null : event.category,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final baseProducts = currentState.selectedCategory == null
          ? currentState.products
          : currentState.products
              .where((p) => p.category == currentState.selectedCategory)
              .toList();
      
      final searchResults = repository.searchProducts(baseProducts, event.query);
      final sortedResults = repository.sortProducts(searchResults, currentState.sortOption);
      
      emit(currentState.copyWith(
        filteredProducts: sortedResults,
        searchQuery: event.query,
      ));
    }
  }

  void _onSortProducts(
      SortProducts event,
      Emitter<ProductState> emit,
      ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      List<Product> sortedProducts;

      if (event.sortOption == SortOption.none) {
        if (currentState.searchQuery.isNotEmpty) {
          sortedProducts = repository.searchProducts(
              currentState.products, currentState.searchQuery);
        } else if (currentState.selectedCategory != null) {
          sortedProducts = currentState.products
              .where((product) =>
          product.category == currentState.selectedCategory)
              .toList();
        } else {
          sortedProducts = List<Product>.from(currentState.products);
        }
      } else {
        sortedProducts = repository.sortProducts(
            currentState.filteredProducts,
            event.sortOption
        );
      }

      emit(currentState.copyWith(
        filteredProducts: sortedProducts,
        sortOption: event.sortOption,
      ));
    }
  }}