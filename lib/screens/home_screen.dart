import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopify/blocs/category/category_bloc.dart';
import 'package:shopify/blocs/product/product_bloc.dart';
import 'package:shopify/blocs/product/product_event.dart';
import 'package:shopify/blocs/theme/theme_bloc.dart';
import 'package:shopify/widgets/category_filter.dart';
import 'package:shopify/widgets/product_grid.dart';
import 'package:shopify/widgets/search_bar.dart';
import 'package:shopify/widgets/sort_dropdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    context.read<ProductBloc>().add(const LoadProducts());
    context.read<CategoryBloc>().add(const LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text('Shopify', style: TextStyle(fontSize: 18.sp)),
        actions: [
          const SortDropdown(),
          IconButton(
            icon: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Icon(
                  state.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  size: 24.sp,
                );
              },
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(const ToggleTheme());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductBloc>().add(const LoadProducts());
          context.read<CategoryBloc>().add(const LoadCategories());
        },
        child: const Column(
          children: [
            // Search bar
            ProductSearchBar(),
            
            // Category filter
            CategoryFilter(),
            
            // Products grid
            Expanded(
              child: ProductGrid(),
            ),
          ],
        ),
      ),
    );
  }
}