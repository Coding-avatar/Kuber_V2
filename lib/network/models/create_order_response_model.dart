class CreateOrderResponseModel {
  OrderData data;
  String message;
  bool status;

  CreateOrderResponseModel({this.data, this.message, this.status});

  CreateOrderResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OrderData.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class OrderData {
  String orderId;

  OrderData({this.orderId});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    return data;
  }
}
