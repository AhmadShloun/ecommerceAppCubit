import 'package:ecommerceapp_cubit/models/login_model.dart';
import 'package:ecommerceapp_cubit/modules/login/cubit/states.dart';
import 'package:ecommerceapp_cubit/shared/network/end_points.dart';
import 'package:ecommerceapp_cubit/shared/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;

  void userLogin({
    @required String? email,
    @required String? password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      // print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);
      // print(loginModel!.data);

      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShow = true;

  void changePasswordVisibility() {
    isPasswordShow = !isPasswordShow;
    suffix = isPasswordShow
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());
  }

// Future<void> userLogin({
//   @required String? email,
//   @required String? password,
// }) async {
//   emit(ShopLoginLoadingState());
//   Map<String, String> headers = {
//     "Content-Type": "application/json",
//     'lang': "en",
//   };
//   final body = jsonEncode({
//     "email": email,
//     "password": password,
//   });
//   final String url = "https://student.valuxapps.com/api/login";
//   final http.Response response = await http.post(
//     Uri.parse(url),
//     body: body,
//     headers: headers,
//   );
//   if (response.statusCode == 200) {
//     emit(ShopLoginSuccessState());
//     print(response.body);
//   } else {
//     emit(ShopLoginErrorState(response.statusCode.toString()));
//     print(response.statusCode);
//   }
// }
}
