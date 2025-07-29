import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopify/blocs/product/product_bloc.dart';
import 'package:shopify/blocs/product/product_event.dart';

class ProductSearchBar extends StatefulWidget {
  const ProductSearchBar({Key? key}) : super(key: key);

  @override
  _ProductSearchBarState createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search, size: 20.sp),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, size: 20.sp),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ProductBloc>().add(const SearchProducts(''));
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        onChanged: (query) {
          context.read<ProductBloc>().add(SearchProducts(query));
        },
      ),
    );
  }
}