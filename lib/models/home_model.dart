import 'package:shop_easy/models/banner_model.dart';
import 'package:shop_easy/models/product_model.dart';

class HomeModel {
  late bool status;
  late HomeDataModel data;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel {
  List<BannerModel> banners = [];
  List<ProductModel> products = [];

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    banners = (json['banners'] as List<dynamic>)
        .map((element) => BannerModel.fromJson(element))
        .toList();
    products = (json['products'] as List<dynamic>)
        .map((element) => ProductModel.fromJson(element))
        .toList();
  }
}
