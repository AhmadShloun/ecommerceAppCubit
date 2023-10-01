import 'dart:io';

import 'package:ecommerceapp_cubit/layout/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/modules/login/shop_login_screen.dart';
import 'package:ecommerceapp_cubit/shared/components/components.dart';
import 'package:ecommerceapp_cubit/shared/network/local/cache_helper.dart';
import 'package:path_provider/path_provider.dart';

String token = '';

void clearCache() async {
  var appDir = (await getTemporaryDirectory()).path;
  Directory(appDir).delete(recursive: true);
}

void signOut(context) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    if (value) {
      token = '';
      ShopCubit.get(context).currentIndex = 0;
      navigateAndFinish(
        context,
        ShopLoginScreen(),
      );
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1.800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
