import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopify/blocs/category/category_bloc.dart';
import 'package:shopify/blocs/product/product_bloc.dart';
import 'package:shopify/blocs/theme/theme_bloc.dart';
import 'package:shopify/core/di/dependency_injection.dart';
import 'package:shopify/core/services/database_service.dart';
import 'package:shopify/core/theme/app_theme.dart';
import 'package:shopify/screens/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize Hive database
  await DatabaseService.init();

  // Setup dependency injection
  await setupDependencies();

  // Load theme preference
  final themeBloc = getIt<ThemeBloc>();
  themeBloc.add(const LoadTheme());

  runApp(MyApp(themeBloc: themeBloc));
}

class MyApp extends StatelessWidget {
  final ThemeBloc themeBloc;

  const MyApp({
    Key? key,
    required this.themeBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: themeBloc),
            BlocProvider<ProductBloc>(
              create: (_) => getIt<ProductBloc>(),
            ),
            BlocProvider<CategoryBloc>(
              create: (_) => getIt<CategoryBloc>(),
            ),
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: 'shopify',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                home: const HomeScreen(),
                builder: (context, widget) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: widget!,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('${bloc.runtimeType} $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType} $transition');
  }
}
