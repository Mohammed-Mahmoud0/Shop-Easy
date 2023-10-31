// ignore_for_file: avoid_print


import '../../modules/shop_app/login/shop_login_screen.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigateAndFinish(context, ShopLoginScreen());
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1, 800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

// String token = 'uzNP5lX7nph6sg8WeqtobGazA6yRiwQEDz14EGvvkatPrkAicX7S49hlbhZ3jUQm34a93k';
String token = CacheHelper.getData(key: 'token');
