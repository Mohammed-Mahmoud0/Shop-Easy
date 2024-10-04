import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_easy/models/cart_model.dart';
import 'package:shop_easy/models/faqs_model.dart';
import 'package:shop_easy/modules/carts/carts_screen.dart';
import 'package:shop_easy/modules/faqs/faqs_screen.dart';
import 'package:shop_easy/modules/favorites/favorites_screen.dart';
import 'package:shop_easy/modules/home/home_screen.dart';
import 'package:shop_easy/modules/settings/settings_screen.dart';

import '../../models/categories_model.dart';
import '../../models/change_favorites_model.dart';
import '../../models/favorites_model.dart';
import '../../models/home_model.dart';
import '../../models/login_model.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/end_points.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/network/remote/dio_helper.dart';
import 'states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CartsScreen(),
    const FaqsScreen(),
    const SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int?, bool?>? favorites = {};

  void addOrRemoveProductFromCart({required int id}) {
    emit(ShopAddOrRemoveProductLoadingState());
    DioHelper.postData(
      url: CARTS,
      token: token,
      data: {
        "product_id": id,
      },
    ).then((value) {
      emit(ShopAddOrRemoveProductSuccessState());
    }).catchError((error) {
      emit(ShopAddOrRemoveProductErrorState());
    });
  }

  void getHomeData() {
    DioHelper.getData(
      url: HOME,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data.products) {
        favorites!.addAll({
          element.id: element.inFavorites,
        });
      }
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      emit(ShopErrorCategoriesState());
    });
  }

  FaqsModel? faqsModel;

  void getFaqsData() {
    DioHelper.getData(
      url: FAQS,
      token: token,
    ).then((value) {
      faqsModel = FaqsModel.fromJson(value.data);
      emit(ShopSuccessFaqsState());
    }).catchError((error) {
      emit(ShopErrorFaqsState());
    });
  }

  CartsModel? cartsModel;

  void getCartsData() {
    DioHelper.getData(
      url: CARTS,
      token: token,
    ).then((value) {
      cartsModel = CartsModel.fromJson(value.data);
      emit(ShopSuccessCartsState());
    }).catchError((error) {
      emit(ShopErrorCartsState());
    });
  }

  void clearAllCartItems() {
    for (var item in cartsModel!.data!.cartItems!) {
      addOrRemoveProductFromCart(id: item.product!.id!);
    }
    for (var item in homeModel!.data.products) {
      if (item.inCart == true) {
        item.inCart = false;
      }
    }
    emit(ShopSuccessAllClearCartItems());
  }

  void clearCartItem({required int id}) {
    addOrRemoveProductFromCart(id: id);
    for (var item in homeModel!.data.products) {
      if (item.id == id) {
        item.inCart = false;
      }
    }
    emit(ShopSuccessClearCartItem());
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites![productId] = !favorites![productId]!;

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (!changeFavoritesModel!.status!) {
        favorites![productId] = !favorites![productId]!;
      } else {
        getFavoritesData();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites![productId] = !favorites![productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavoritesData() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
      lang: 'en',
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserDataState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessUpdateUserDataState(userModel!));
    }).catchError((error) {
      emit(ShopErrorUpdateUserDataState());
    });
  }

  void changePassword(
      {required String userCurrentPassword, required String newPassword}) {
    emit(ShopChangePasswordLoadingState());
    DioHelper.postData(
      url: CHANGEPASSWORD,
      data: {
        'current_password': userCurrentPassword,
        'new_password': newPassword,
      },
      token: token,
    ).then((value) {
      CacheHelper.saveData(key: 'current_password', value: newPassword);
      currentPassword = CacheHelper.getData(key: "current_password");
      emit(ShopChangePasswordSuccessState());
    }).catchError((error) {
      emit(ShopChangePasswordWithErrorState());
    });
  }
}
