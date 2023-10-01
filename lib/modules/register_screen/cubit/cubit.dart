import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:ecommerceapp_cubit/models/login_model.dart';
import 'package:ecommerceapp_cubit/modules/register_screen/cubit/states.dart';
import 'package:ecommerceapp_cubit/shared/network/end_points.dart';
import 'package:ecommerceapp_cubit/shared/network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {

  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  ShopLoginModel ?loginModel;


  void userRegister({
    @required String? email,
    @required String? password,
    @required String? name,
    @required String? phone,
  }) {

    emit(ShopRegisterLoadingState());
     DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,

      },
    ).then((value) {
       // print(value.data);
       loginModel = ShopLoginModel.fromJson(value.data);
       // print(loginModel!.data);
      emit(ShopRegisterSuccessState(loginModel!));
    }).catchError((error) {
      emit(ShopRegisterErrorState(error.toString()));
    });
  }


  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShow = true;

  void changePasswordVisibility()
  {
    isPasswordShow = !isPasswordShow;
    suffix = isPasswordShow?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ShopRegisterChangePasswordVisibilityState());
  }

  /*Future<void> userRegister({
    @required String? email,
    @required String? password,
  }) async {
    emit(ShopRegisterLoadingState());
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'lang': "en",
    };
    final body = jsonEncode({
      "email": email,
      "password": password,
    });
    final String url = "https://student.valuxapps.com/api/login";
   
    final http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      emit(ShopRegisterSuccessState());
      print(response.body);
    } else {
      emit(ShopRegisterErrorState(response.statusCode.toString()));
      print(response.statusCode);
    }
  }*/
}
