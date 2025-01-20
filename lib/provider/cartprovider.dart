import 'package:foodapp/model/cartitem.dart';
import 'package:foodapp/model/products.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  void addItem(Products product, String size, String color, int quantity) {
    notifyListeners();
    _items.add(CartItem(
      products: product,
      size: size,
      quantity: quantity,
      color: color,
    ));
  }

  List<CartItem> get items => _items;

  //xóa giỏ hàng
  void removeItem(CartItem item) {
    _items.removeWhere((cartItem) => cartItem == item);
    notifyListeners();
  }

  //làm sạch giỏ hàng
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  String get product {
    return _items.fold("", (total, item) => item.products.toString());
  }

//format tổng tiền ban đầu về VNĐ
  String get formattedPrice {
    final locale = 'vi_VN';
    final formatter = NumberFormat.currency(name: "đ", locale: locale);
    formatter.maximumFractionDigits = 0;
    return formatter.format(subTotalPrice);
  }

  //format tong tien về VNĐ
  String get formattedTotalPrice {
    final locale = 'vi_VN';
    final formatter = NumberFormat.currency(name: "đ", locale: locale);
    formatter.maximumFractionDigits = 0;
    return formatter.format(totalPrice);
  }

  String get formattedShip {
    final locale = 'vi_VN';
    final formatter = NumberFormat.currency(name: "đ", locale: locale);
    formatter.maximumFractionDigits = 0;
    return formatter.format(shipCode);
  }

  //tổng tiền ban đầu
  double get subTotalPrice {
    return _items.fold(
        0, (total, item) => total + item.products.price * item.quantity);
  }

  //màu sắc
  String _discountColor = ""; //màu sắc mặc định trống
  String get discountColor => _discountColor;
  set discountColor(String newRate) {
    _discountColor = newRate;
    notifyListeners();
  }

  // lấy giảm giá bao nhiêu %
  double get discount {
    if (subTotalPrice <= 25000) {
      return 0;
    } else if (subTotalPrice > 25000 && subTotalPrice <= 45000) {
      return subTotalPrice * 0.05; // Giảm 5%
    } else {
      return subTotalPrice * 0.1; // Giảm 10%
    }
  }

  String get discountPercentage {
    if (subTotalPrice <= 10000) {
      return '0%'; // No discount
    } else {
      NumberFormat percentFormat = NumberFormat.percentPattern();
      return percentFormat.format(discount / subTotalPrice);
    }
  }

  //số lượng đã đặt tất cả sản phẩm
  int get quantitys {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  //tính tổng tiền tất cả sản phẩm
  double get totalPrice {
    final subTotal = this.subTotalPrice;
    final discount = this.discount;
    return subTotal - discount + shipCode;
  }

  //tổng tiền để truyền giá trị qua trang hóa đơn
  double calculateTotalPrice() {
    return subTotalPrice - discount + shipCode;
  }

  //phí vận chuyển
  double get shipCode {
    if (subTotalPrice == 0) {
      return 0;
    } else if (subTotalPrice <= 15000) {
      return 2000;
    } else if (subTotalPrice > 15000 && subTotalPrice <= 50000) {
      return 5000;
    } else {
      return 7000;
    }
  }
}
