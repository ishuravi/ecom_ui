import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cart = [];

  List<CartItem> get cart => _cart;

  CartProvider() {
    loadGuestCart(); // Initialize with guest cart data
  }

  /// Load the guest cart from local storage
  Future<void> loadGuestCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> guestCart = prefs.getStringList('guestCart') ?? [];
    _cart = guestCart
        .map((item) => CartItem.fromJson(jsonDecode(item)))
        .toList();
    notifyListeners();
  }

  /// Add a new item to the cart
  Future<void> addToCart(CartItem item) async {
    final existingIndex =
    _cart.indexWhere((cartItem) => cartItem.productId == item.productId);

    if (existingIndex >= 0) {
      // If the item exists, update the quantity
      _cart[existingIndex].quantity += item.quantity;
    } else {
      // Add the new item to the cart
      _cart.add(item);
    }

    await saveGuestCart();
    notifyListeners();
  }

  /// Remove an item from the cart
  Future<void> removeFromCart(String productId) async {
    _cart.removeWhere((item) => item.productId == productId);
    await saveGuestCart();
    notifyListeners();
  }

  /// Save the guest cart to local storage
  Future<void> saveGuestCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> guestCart = _cart.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('guestCart', guestCart);
  }

  /// Increment the quantity of a cart item
  void incrementQtn(int index) {
    _cart[index].quantity++;
    saveGuestCart();
    notifyListeners();
  }

  /// Decrement the quantity of a cart item
  void decrementQtn(int index) {
    if (_cart[index].quantity > 1) {
      _cart[index].quantity--;
      saveGuestCart();
      notifyListeners();
    }
  }

  /// Clear the cart (for example, after checkout)
  Future<void> clearCart() async {
    _cart.clear();
    await saveGuestCart();
    notifyListeners();
  }
  /// Calculate and return the total price of all items in the cart
  double totalPrice() {
    return _cart.fold(0.0, (sum, item) => sum + (item.offerPrice * item.quantity));
  }
}

class CartItem {
  final String productId;
  final String title;
  final String imageUrl;
  final double offerPrice;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.offerPrice,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['ProductId'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      offerPrice: json['offerPrice'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'title': title,
      'imageUrl': imageUrl,
      'offerPrice': offerPrice,
      'quantity': quantity,
    };
  }
}

