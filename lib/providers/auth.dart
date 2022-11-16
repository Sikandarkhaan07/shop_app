import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/HttpException.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryTime;
  Timer _authTimer;

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
      _autoLogout();
      notifyListeners();
      final sharePrefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryTime': _expiryTime,
      });
      sharePrefs.setString('data', userData);

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

  Future<bool> autoLogin() async{
    final sharePrefs = await SharedPreferences.getInstance();
    if(!sharePrefs.containsKey('data')){
      return false;
    }
    final extractedData = json.decode(sharePrefs.getString('data')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryTime']);

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryTime = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _userId = null;
    _expiryTime = null;
    _token = null;
    if(_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // prefs.remove('data');
  }
  
  void _autoLogout(){
    if(_authTimer != null){
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryTime.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    notifyListeners();
  }

}
