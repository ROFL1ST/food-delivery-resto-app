import 'dart:convert';

class PopularResponseModel {
    final String? status;
    final String? message;
    final List<Datum>? data;

    PopularResponseModel({
        this.status,
        this.message,
        this.data,
    });

    factory PopularResponseModel.fromRawJson(String str) => PopularResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PopularResponseModel.fromJson(Map<String, dynamic> json) => PopularResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final String? name;
    final String? image;
    final String? sales;

    Datum({
        this.name,
        this.image,
        this.sales,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"],
        image: json["image"],
        sales: json["sales"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "sales": sales,
    };
}
