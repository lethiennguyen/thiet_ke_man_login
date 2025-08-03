import 'package:flutter/cupertino.dart';

enum ProductField { name, price, quantity }

extension ProductFieldExtentsion on ProductField {
  String get lable {
    switch (this) {
      case ProductField.name:
        return "Tên sản pẩm";
      case ProductField.price:
        return "Giá";
      case ProductField.quantity:
        return "Số lượng";
    }
  }

  String get hint {
    switch (this) {
      case ProductField.name:
        return "Tên sản pẩm";
      case ProductField.price:
        return "Điền giá";
      case ProductField.quantity:
        return "Diền số lượng";
    }
  }

  TextInputType get keyboardType {
    switch (this) {
      case ProductField.price:
      case ProductField.quantity:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}
