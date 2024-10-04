class CartsModel {
  bool? status;
  CartsDataModel? data;

  CartsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CartsDataModel.fromJson(json['data']);
  }
}

class CartsDataModel {
  List<CartsItemsModel>? cartItems = [];
  dynamic total;

  CartsDataModel.fromJson(Map<String, dynamic> json) {
    json['cart_items'].forEach((element) {
      cartItems!.add(CartsItemsModel.fromJson(element));
    });
    total = json['total'];
  }
}

class CartsItemsModel {
  int? id;
  dynamic quantity;
  ProductModel? product;

  CartsItemsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = ProductModel.fromJson(json['product']);
  }
}

class ProductModel {
  int? id;
  dynamic price;
  String? image;
  String? name;

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
  }
}
