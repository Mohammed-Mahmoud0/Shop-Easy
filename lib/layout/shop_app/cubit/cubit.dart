import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_easy/models/shop_app/faqs_model.dart';
import 'package:shop_easy/modules/shop_app/faqs/faqs_screen.dart';
import 'package:shop_easy/modules/shop_app/favorites/favorites_screen.dart';
import 'package:shop_easy/modules/shop_app/home/home_screen.dart';
import 'package:shop_easy/modules/shop_app/settings/settings_screen.dart';

import '../../../models/shop_app/categories_model.dart';
import '../../../models/shop_app/change_favorites_model.dart';
import '../../../models/shop_app/favorites_model.dart';
import '../../../models/shop_app/home_model.dart';
import '../../../models/shop_app/login_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreens = [
    const HomeScreen(),
    const FavoritesScreen(),
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
    emit(ShopLoadingHomeDataState());

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
      // printFullText(value.data.toString());

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
}
