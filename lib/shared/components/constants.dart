import '../../modules/shop_app/login/shop_login_screen.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigateAndFinish(context, const ShopLoginScreen());
    }
  });
}

// String token = 'uzNP5lX7nph6sg8WeqtobGazA6yRiwQEDz14EGvvkatPrkAicX7S49hlbhZ3jUQm34a93k';
String token = CacheHelper.getData(key: 'token');
