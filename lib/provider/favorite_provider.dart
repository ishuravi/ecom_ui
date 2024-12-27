import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final String _baseUrl = 'http://103.61.224.178:8022'; // API base URL
  String _authToken = ''; // Token initialized as empty

  final List<Product> _favorite = [];
  List<Product> get favorites => _favorite;

  FavoriteProvider() {
    _loadAuthToken();
  }

  /// Load the token from local storage during initialization
  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('authToken') ?? '';
    notifyListeners();
  }

  /// Save the token to local storage
  Future<void> _saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  /// Set the authentication token and save it locally
  void setAuthToken(String token) {
    _authToken = token;
    _saveAuthToken(token);
    notifyListeners();
  }

  /// Check if a product is already in favorites
  bool isExist(Product product) {
    return _favorite.any((item) => item.id == product.id);
  }

  /// Toggle favorite state and handle API interaction
  Future<void> toggleFavorite(Product product) async {
    if (isExist(product)) {
      _favorite.removeWhere((item) => item.id == product.id);
    } else {
      final success = await _addToFavorites(product);
      if (success) {
        _favorite.add(product);
      } else {
        print('Failed to add to favorites.');
      }
    }
    notifyListeners();
  }

  /// Call the `/addwishlist` API to add a product to the favorites
  Future<bool> _addToFavorites(Product product) async {
    if (_authToken.isEmpty) {
      print('Authentication token is missing.');
      return false;
    }

    final url = Uri.parse('$_baseUrl/user/addwishlist');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: json.encode({'prodId': product.id}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error adding to favorites: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error adding to favorites: $error');
      return false;
    }
  }
}
