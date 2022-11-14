import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/HttpException.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryTime;

  bool get isAuthenticated {
    return token != null;
  }

  String get token {
    if (_expiryTime != null &&
        _expiryTime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }
  String get userId{
    return _userId;
  }

  Future<void> _authenticated(
      String email, String password, String urlSegmentation) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegmentation?key=AIzaSyD76yZa9YXorjJjBAqvu58j6MtoKMi5idk';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticated(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    return _authenticated(email, password, 'signUp');
  }

  void logout(){
    _userId = null;
    _expiryTime = null;
    _token = null;
    notifyListeners();
  }
}
