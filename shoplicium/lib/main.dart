import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'config/themes/text_styles.dart';
import 'dependecy_locator.dart';
import 'domain/repositories/local_data_source.dart';
import 'presentation/views/shopping_list/shopping_list_page.dart';
import 'utils/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DependencyLocator.locateDependencies();

  await GetIt.instance<LocalDataSource>().initDatabase();

  runApp(const ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoplicium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: TextStyles.defaultFontFamily,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyles.appBarTitleTextStyle,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue1),
        useMaterial3: true,
      ),
      home: const ShoppingListPage(),
    );
  }
}
