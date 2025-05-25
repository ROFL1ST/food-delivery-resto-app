import 'dart:convert';

class OverviewResponse {
    final String? status;
    final String? message;
    final Data? data;

    OverviewResponse({
        this.status,
        this.message,
        this.data,
    });

    factory OverviewResponse.fromRawJson(String str) => OverviewResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OverviewResponse.fromJson(Map<String, dynamic> json) => OverviewResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final int? totalOrders;
    final int? totalProducts;
    final int? totalRevenue;
    final int? pendingOrders;
    final int? todayDeliveries;
    final int? transactionPercentage;
    final int? pendingPercentage;
    final int? todayDeliveriesPercentage;

    Data({
        this.totalOrders,
        this.totalProducts,
        this.totalRevenue,
        this.pendingOrders,
        this.todayDeliveries,
        this.transactionPercentage,
        this.pendingPercentage,
        this.todayDeliveriesPercentage,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalOrders: json["total_orders_today"],
        totalProducts: json["total_products"],
        totalRevenue: json["total_revenue"],
        pendingOrders: json["pending_orders"],
        todayDeliveries: json["today_deliveries"],
        transactionPercentage: json["transaction_percentage"],
        pendingPercentage: json["pending_percentage"],
        todayDeliveriesPercentage: json["delivery_percentage"],
    );

    Map<String, dynamic> toJson() => {
        "total_orders_today": totalOrders,
        "total_products": totalProducts,
        "total_revenue": totalRevenue,
        "pending_orders": pendingOrders,
        "today_deliveries": todayDeliveries,
        "transaction_percentage": transactionPercentage,
        "pending_percentage": pendingPercentage,
        "delivery_percentage": todayDeliveriesPercentage,
    };
}
