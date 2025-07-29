import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopify/blocs/product/product_bloc.dart';
import 'package:shopify/blocs/product/product_event.dart';
import 'package:shopify/blocs/product/product_state.dart';
import 'package:shopify/repositories/product_repository.dart';

class SortDropdown extends StatelessWidget {
  const SortDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoaded) {
          return PopupMenuButton<SortOption>(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sort, size: 20.sp),
                SizedBox(width: 4.w),
                Text(
                  'Sort',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.white, // Same color for both modes as requested
                  ),
                ),
              ],
            ),
            initialValue: state.sortOption,
            onSelected: (SortOption option) {
              context.read<ProductBloc>().add(SortProducts(option));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              PopupMenuItem<SortOption>(
                value: SortOption.none,
                child: Text('Default', style: TextStyle(fontSize: 14.sp)),
              ),
              PopupMenuItem<SortOption>(
                value: SortOption.priceAsc,
                child: Text('Price: Low to High', style: TextStyle(fontSize: 14.sp)),
              ),
              PopupMenuItem<SortOption>(
                value: SortOption.priceDesc,
                child: Text('Price: High to Low', style: TextStyle(fontSize: 14.sp)),
              ),
              PopupMenuItem<SortOption>(
                value: SortOption.ratingDesc,
                child: Text('Rating: High to Low', style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}