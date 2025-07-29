import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopify/blocs/category/category_bloc.dart';
import 'package:shopify/blocs/product/product_bloc.dart';
import 'package:shopify/blocs/product/product_event.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.light
        ? Colors.black
        : Colors.white;

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return SizedBox(
            height: 40.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is CategoryError) {
          return SizedBox(
            height: 40.h,
            child: Center(
              child: Text(
                'Failed to load categories',
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            ),
          );
        }

        if (state is CategoryLoaded) {
          return SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemBuilder: (context, index) {
                final category = state.categories[index];
                final isSelected = state.selectedCategory == category;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: FilterChip(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        side: BorderSide(color: borderColor)
                    ),
                    label: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        context.read<ProductBloc>().add(
                          LoadProductsByCategory(category),
                        );
                        context.read<CategoryBloc>().emit(
                          (state).copyWith(
                            selectedCategory: category,
                          ),
                        );
                      }
                    },
                    backgroundColor: theme.cardColor,
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    showCheckmark: false,
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}