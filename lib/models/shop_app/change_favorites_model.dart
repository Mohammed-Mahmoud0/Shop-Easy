// ignore_for_file: empty_constructor_bodies

class ChangeFavoritesModel {
  bool? status;
  String? message;

  ChangeFavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}