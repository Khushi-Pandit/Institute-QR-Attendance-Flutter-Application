import 'package:softwareproject/UI/SplashScreen/SplashScreen.dart';

import './common/theme_provider.dart';
import 'package:softwareproject/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver{

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.theme,
            theme: FAppTheme.lightTheme,
            darkTheme: FAppTheme.darkTheme,
            home: const SplashScreen()
          );
        }
    );
  }
}