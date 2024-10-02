class FaqsModel {
  bool? status;
  FaqsDataModel? data;

  FaqsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = FaqsDataModel.fromJson(json['data']);
  }
}

class FaqsDataModel {
  int? currentPage;
  List<DataModel>? data = [];

  FaqsDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((element) {
      data!.add(DataModel.fromJson(element));
    });
  }
}

class DataModel {
  int? id;
  String? question;
  String? answer;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }
}
