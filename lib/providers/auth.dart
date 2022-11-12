import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/HttpException.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryTime;

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
      if(responseData['error'] != null){
        print(responseData['error']['message']);
        throw HttpException(responseData['error']['message']);
      }
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
}
