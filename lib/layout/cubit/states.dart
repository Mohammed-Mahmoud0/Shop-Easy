import 'package:shop_easy/models/change_favorites_model.dart';
import 'package:shop_easy/models/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {}

class ShopAddOrRemoveProductSuccessState extends ShopStates {}

class ShopAddOrRemoveProductErrorState extends ShopStates {}

class ShopAddOrRemoveProductLoadingState extends ShopStates {}

class ShopSuccessFaqsState extends ShopStates {}

class ShopErrorFaqsState extends ShopStates {}

class ShopSuccessCartsState extends ShopStates {}

class ShopErrorCartsState extends ShopStates {}

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates {}

class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {
  final ShopLoginModel loginModel;

  ShopSuccessUserDataState(this.loginModel);
}

class ShopErrorUserDataState extends ShopStates {}

class ShopLoadingUpdateUserDataState extends ShopStates {}

class ShopSuccessUpdateUserDataState extends ShopStates {
  final ShopLoginModel loginModel;

  ShopSuccessUpdateUserDataState(this.loginModel);
}

class ShopErrorUpdateUserDataState extends ShopStates {}

class ShopChangeQuantityOfCartItem extends ShopStates {}

class ShopChangeTotalOfCartItems extends ShopStates {}

class ShopSuccessAllClearCartItems extends ShopStates {}

class ShopSuccessClearCartItem extends ShopStates {}

class ShopChangePasswordLoadingState extends ShopStates {}

class ShopChangePasswordSuccessState extends ShopStates {}

class ShopChangePasswordWithErrorState extends ShopStates {}
