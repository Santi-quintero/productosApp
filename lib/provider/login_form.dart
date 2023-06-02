import 'dart:core';

import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier{

  String emailAddress='';
  String passsword='';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool get isLoading{
    return _isLoading;
  }

  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm(){

    return formKey.currentState?.validate() ?? false;
  }

}