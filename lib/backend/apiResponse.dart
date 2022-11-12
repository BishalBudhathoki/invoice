import 'package:flutter/material.dart';

class ApiResponse {
  // _data will hold any response converted into
  // its own object. For example user.
  late Object _data='';
  // _apiError will hold the error object
  late Object _apiError={};

  Object get Data {
    print("Datas:"+_data.toString());
    return _data;

  }
  set Data(Object data) {
    _data = data;
    print("Data: ${_data}");
  }

  Object get ApiError => _apiError ;
  set ApiError(Object error) => _apiError = error;
}