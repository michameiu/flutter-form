import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/model.dart';
import '../models/http_exception.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  DateTime _expiryDate;
  String _userId;
  String _otp;
  Map<String, dynamic> _otp_into;
  String _token = "";
  String _refresh_token = "";
  dynamic _profile;
  bool _is_first_time = true;

  Auth() {
    print("#################");
    print("##### AUTH ######");
    print("#################");
    this.getToken();
  }

  void updateProfile() async {
    print("getting the profile");
    var profile_resp = await this.getProfile();

    if (profile_resp.statusCode == 200) {
      var profile = json.decode(profile_resp.body);
      print(profile);
      setProfile(profile);
    }
  }

  bool get isAuth {
    print("Auth ${_token != null && _token != ""}");
    return _token != null && _token != "";
  }

  bool get is_first_time {
    return _is_first_time;
  }

  Map<String, dynamic> get profile {
    return _profile;
  }

  Profile get myProfile {
    return profile.parseProfile();
  }

  String get otp {
    return _otp;
  }

  String get token {
    return _token; //"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcXVhcmVjaC1hcGkubWFydGlhbi1meC5jb21cL2FwaVwvYXV0aFwvbG9naW4iLCJpYXQiOjE1ODkzMTI5MDMsImV4cCI6MTU5MDUyMjUwMywibmJmIjoxNTg5MzEyOTAzLCJqdGkiOiJyMFVIYVUxZTVFcVBiZkVXIiwic3ViIjoxOSwicHJ2IjoiMTRmMTQzNGI2NTI5YWI5YzRlN2E3NDlkOThhNmMxN2VlYThkZDkwNiJ9.z_oXm9v0KITVhtwU4WfOxBrLtmQtk95s3eWfOleMCU0";
  }

  void setIsFirstTime(bool status) {
    _is_first_time = status;
//    notifyListeners();
  }

  void setOtp(otp) {
    _otp = otp;
  }

  setOtpInfo(Map<String, dynamic> data) {
    _otp_into = data;
    notifyListeners();
  }

  Future<void> storeTokenInfo(info) async {
    var _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("token", json.encode(info));
  }

  Map<String, dynamic> get optInfo {
    if (_otp_into == null) {
      return {};
    }
    return _otp_into;
  }

  String getToken() {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<bool> getStorageToken() async {
//    return false;
    var _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey("token")) {
      var token = _prefs.getString("token");
      setTokeInfo(json.decode(token));
      if (_prefs.containsKey("profile")) {
        _profile = json.decode(_prefs.getString("profile"));
      } else {
        print("No profile found.");
      }
      return true;
    } else {
      print("No token found.");
    }
    return false;
  }

  get headers {
    print("getting headers");
    return {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json"
    };
  }

  get signupHeaders {
    return {"Content-Type": "application/json"};
  }

  Future<void> setTokeInfo(info) async {
    print(info);
    if (info == null) {
      return;
    }
    _token = info["access_token"];
    _expiryDate = DateTime.now().add(Duration(seconds: info['expires_in']));
    return await storeTokenInfo(info);
//    notifyListeners();
  }

  Future<bool> logout() async {
    print("Logging out");
    _token = null;
    _userId = null;
    _expiryDate = null;
    _profile = null;
    //Todo: stop the notifications....

    await clearStorage();
    notifyListeners();
    return true;
  }

  Future<bool> clearStorage() async {
    var _prefs = await SharedPreferences.getInstance();
    return _prefs.clear();
  }

  static const base_api_url = "https://api.safarinjema.wavvy.dev";

//  static const base_api_url = "http://localhost:8000";

  static const baseApiV1 = "$base_api_url/api/v1";

  static const client_id = "Dd2oVCnc1QrpQ19y45CixHT8yAdoj8A0BNhDVtl4";

  static const x_authorization = "8ff6f7ddf91d1575b28408698de12417e94dde37";

  static const signUpUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAwjzzNSWmpylyKRtD43BpsV_PBRvYukHM";
  static const signInUrl = "${base_api_url}/auth/token";

  String get baseApiUrl {
    return base_api_url;
  }

  Future<http.Response> signUp(Map<dynamic, dynamic> data) async {
    // throw HttpException(400,"Not implemented");
    // setIsFirstTime(true);
    var body = json.encode(data);
    print(body);
    try {
      var res = await http.post("$baseApiV1/users/",
          body: body, headers: signupHeaders);
      print("Got response ${res.statusCode}");
      if (res.statusCode == 201) {
        print(json.decode(res.body));
        var token = json.decode(res.body)["token"]["access_token"];
        _token = token;
        await setTokeInfo(json.decode(res.body)["token"]);
        var profile = json.decode(res.body)["profile"];
        await setProfile(profile);
        notifyListeners();
      }
      return res;
    } catch (error) {
      print(error);
      throw HttpException(500, error);
    }
  }

  void setProfile(profile) async {
    //Force fish/feeds supplier
//    profile["supplier_category"]="fish";
    _profile = profile;
    var _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("profile", json.encode(profile));
    print(profile);
  }

  Future<http.Response> getProfile() {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    return http.get("$base_api_url/api/v1/users/me/profile/", headers: headers);
  }

  Future<http.Response> signIn(String email, String password) async {
    print("Signin in....");
    var body = json.encode({
      "username": email,
      "password": password,
      "grant_type": "password",
      "client_id": client_id
    });
    print(signInUrl);
    var reponse = await http.post(signInUrl,
        body: body,
        headers: {"Content-Type": "application/json"}).then((response) async {
      var respBody = json.decode(response.body);

      print(respBody);
      if (response.statusCode != 200) {
        print("error found...");
        throw HttpException(400, respBody['error']);
      }
      print(respBody);
      _token = respBody['access_token'];
      _userId = respBody['localId'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: respBody['expires_in']));
      print(_expiryDate);
      await setTokeInfo(respBody);
      var profile_resp = await this.getProfile();
      print(profile_resp.statusCode);
      if (profile_resp.statusCode == 200) {
        var profile = json.decode(profile_resp.body);
        setProfile(profile);

        print("done setting body");
      }
      return profile_resp;
    });
    notifyListeners();
    return reponse;
  }
}
