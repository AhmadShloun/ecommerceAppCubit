import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ecommerceapp_cubit/layout/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/layout/shop_layout.dart';
import 'package:ecommerceapp_cubit/modules/login/shop_login_screen.dart';
import 'package:ecommerceapp_cubit/modules/on_boarding/on_boardin_screen.dart';
import 'package:ecommerceapp_cubit/shared/bloc_observer.dart';
import 'package:ecommerceapp_cubit/shared/components/constants.dart';
import 'package:ecommerceapp_cubit/shared/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/shared/cubit/states.dart';
import 'package:ecommerceapp_cubit/shared/network/local/cache_helper.dart';
import 'package:ecommerceapp_cubit/shared/network/remote/dio_helper.dart';
import 'package:ecommerceapp_cubit/shared/styles/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      //await
      DioHelper.init();
      await CacheHelper.init();

      // CacheHelper.putbool(key: 'isDark', value: false);
      bool isDark = CacheHelper.getData(key: 'isDark') ?? false;

      Widget widget;

      bool onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
      token = CacheHelper.getData(key: 'token');
      print(token);
      if (onBoarding) {
        if (token != null) {
          widget = const ShopLayout();
        } else {
          widget = ShopLoginScreen();
        }
      } else {
        widget = const OnBoardingScreen();
      }

      print('onBoarding : $onBoarding');
      HttpOverrides.global = MyHttpOverrides();
      runApp(MyApp(
        isDark: isDark,
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  MyApp({
    required this.isDark,
    required this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark
                ? ThemeMode.light
                : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
