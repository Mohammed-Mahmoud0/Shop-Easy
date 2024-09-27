// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/shop_app/cubit/cubit.dart';
import 'layout/shop_app/shop_layout.dart';
import 'modules/shop_app/login/shop_login_screen.dart';
import 'modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = isValueTrue(CacheHelper.getData(key: 'isDark'));
  bool onBoarding = isValueTrue(CacheHelper.getData(key: 'onBoarding'));
  String? token = CacheHelper.getData(key: 'token');

  Widget widget;

  if (onBoarding == true && token == null) {
    widget = ShopLoginScreen();
  } else if (token != null) {
    widget = ShopLayout();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

bool isValueTrue(dynamic value) {
  if (value != null && value is bool) {
    return value;
  }
  return false;
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  MyApp({super.key, required this.isDark, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()
        ..getHomeData()
        ..getCategoriesData()
        ..getFavoritesData()
        ..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
