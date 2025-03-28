import 'dart:convert';

import 'package:myutils/constants/api_constant.dart';

/// status_code : 200
/// status : "success"
/// message : "Get contracts successfully!"
/// data : {"defaultContract":{"id":15,"code":"SND416 - 1","slug":"2c86d97c-cbe9-11ef-a285-9ea6660d1027","product":{"id":4,"name":"Basic 9 đến 11 tháng"}},"products":[{"id":15,"code":"SND416 - 1","slug":"2c86d97c-cbe9-11ef-a285-9ea6660d1027","product":{"id":4,"name":"Basic 9 đến 11 tháng"}},{"id":16,"code":"SND416 - 2","slug":"2c86e14c-cbe9-11ef-a285-9ea6660d1027","product":{"id":16,"name":"1-1 Chung 10 buổi"}},{"id":17,"code":"SND416-3","slug":"2c86e6f6-cbe9-11ef-a285-9ea6660d1027","product":{"id":12,"name":"Golden Beat"}},{"id":21,"code":"SND416-5","slug":"2c8708f2-cbe9-11ef-a285-9ea6660d1027","product":{"id":16,"name":"1-1 Chung 10 buổi"}},{"id":19,"code":"SND416-4","slug":"2c86fe5c-cbe9-11ef-a285-9ea6660d1027","product":{"id":3,"name":"Basic 1 đến 3 tháng"}}]}
/// errors : []

ListProductsOutput listProductsOutputFromJson(String str) =>
    ListProductsOutput.fromJson(json.decode(str));

String listProductsOutputToJson(ListProductsOutput data) =>
    json.encode(data.toJson());

class ListProductsOutput {
  ListProductsOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  ListProductsOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['status_code'] == ApiStatusCode.success) {
      data = json['data'] != null ? DataMenu.fromJson(json['data']) : null;
    } else {
      data = null;
    }
  }

  num? statusCode;
  String? status;
  String? message;
  DataMenu? data;
  List<dynamic>? errors;

  ListProductsOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    DataMenu? data,
    List<dynamic>? errors,
  }) =>
      ListProductsOutput(
        statusCode: statusCode ?? this.statusCode,
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
        errors: errors ?? this.errors,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// defaultContract : {"id":15,"code":"SND416 - 1","slug":"2c86d97c-cbe9-11ef-a285-9ea6660d1027","product":{"id":4,"name":"Basic 9 đến 11 tháng"}}
/// products : [{"id":15,"code":"SND416 - 1","slug":"2c86d97c-cbe9-11ef-a285-9ea6660d1027","product":{"id":4,"name":"Basic 9 đến 11 tháng"}},{"id":16,"code":"SND416 - 2","slug":"2c86e14c-cbe9-11ef-a285-9ea6660d1027","product":{"id":16,"name":"1-1 Chung 10 buổi"}},{"id":17,"code":"SND416-3","slug":"2c86e6f6-cbe9-11ef-a285-9ea6660d1027","product":{"id":12,"name":"Golden Beat"}},{"id":21,"code":"SND416-5","slug":"2c8708f2-cbe9-11ef-a285-9ea6660d1027","product":{"id":16,"name":"1-1 Chung 10 buổi"}},{"id":19,"code":"SND416-4","slug":"2c86fe5c-cbe9-11ef-a285-9ea6660d1027","product":{"id":3,"name":"Basic 1 đến 3 tháng"}}]

class DataMenu {
  DataMenu({
    this.defaultContract,
    this.products,
  });

  DataMenu.fromJson(dynamic json) {
    defaultContract = json['defaultContract'] != null
        ? DefaultContract.fromJson(json['defaultContract'])
        : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
  }

  DefaultContract? defaultContract;
  List<Products>? products;

  DataMenu copyWith({
    DefaultContract? defaultContract,
    List<Products>? products,
  }) =>
      DataMenu(
        defaultContract: defaultContract ?? this.defaultContract,
        products: products ?? this.products,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (defaultContract != null) {
      map['defaultContract'] = defaultContract?.toJson();
    }
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 15
/// code : "SND416 - 1"
/// slug : "2c86d97c-cbe9-11ef-a285-9ea6660d1027"
/// product : {"id":4,"name":"Basic 9 đến 11 tháng"}

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  Products(
      {this.id, this.code, this.slug, this.product, this.isSelect = false});

  Products.fromJson(dynamic json) {
    id = json['id'];
    code = json['code'];
    slug = json['slug'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    isSelect = false;
  }

  num? id;
  String? code;
  String? slug;
  bool? isSelect;
  Product? product;

  Products copyWith(
          {num? id,
          String? code,
          String? slug,
          Product? product,
          bool? isSelect}) =>
      Products(
          id: id ?? this.id,
          code: code ?? this.code,
          slug: slug ?? this.slug,
          product: product ?? this.product,
          isSelect: isSelect ?? this.isSelect);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['slug'] = slug;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }
}

/// id : 4
/// name : "Basic 9 đến 11 tháng"

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.id,
    this.name,
  });

  Product.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  num? id;
  String? name;

  Product copyWith({
    num? id,
    String? name,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

/// id : 15
/// code : "SND416 - 1"
/// slug : "2c86d97c-cbe9-11ef-a285-9ea6660d1027"
/// product : {"id":4,"name":"Basic 9 đến 11 tháng"}

DefaultContract defaultContractFromJson(String str) =>
    DefaultContract.fromJson(json.decode(str));

String defaultContractToJson(DefaultContract data) =>
    json.encode(data.toJson());

class DefaultContract {
  DefaultContract({
    this.id,
    this.code,
    this.slug,
    this.product,
  });

  DefaultContract.fromJson(dynamic json) {
    id = json['id'];
    code = json['code'];
    slug = json['slug'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  num? id;
  String? code;
  String? slug;
  Product? product;

  DefaultContract copyWith({
    num? id,
    String? code,
    String? slug,
    Product? product,
  }) =>
      DefaultContract(
        id: id ?? this.id,
        code: code ?? this.code,
        slug: slug ?? this.slug,
        product: product ?? this.product,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['slug'] = slug;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }
}
