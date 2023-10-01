// ignore_for_file: constant_identifier_names, invalid_use_of_visible_for_testing_member

import 'package:conditional_builder/conditional_builder.dart';
import 'package:ecommerceapp_cubit/layout/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/modules/search/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/modules/search/cubit/states.dart';
import 'package:ecommerceapp_cubit/shared/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//Button
Widget defaultButton({
  Color background = Colors.blue,
  double width = double.infinity,
  bool isUpperCase = true,
  @required String? text,
  @required Function? function,
}) =>
    Center(
      child: Container(
        width: width,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: background,
        ),
        child: MaterialButton(
          // height: 40.0,
          onPressed: () {
            function!();
          },
          child: Text(
            isUpperCase ? text!.toUpperCase() : text!,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

Widget defaultTextButton({
  @required Function()? function,
  @required String? text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(text!.toUpperCase()),
    );

// Text Form Feiled
Widget defaultFormField({
  @required TextEditingController? controller,
  @required TextInputType? type,
  String? Function(String?)? onSubmitted,
  //@required String? validate,
  @required String? labelText,
  @required IconData? prefixIcon,
  IconData? suffixIcon,
  Function? suffixPress,
  bool onPassword = false,
  Function(String)? onChange,
  @required String? Function(String?)? validate,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: onPassword,
      onChanged: onChange,
      validator: validate,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            suffixIcon,
          ),
          onPressed: () {
            suffixPress!();
          },
        ),
        border: const OutlineInputBorder(),
      ),
    );



Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );



void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      //عايز الغي يلي فات او اخلي true
      (Route<dynamic> route) => false,
    );

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Toast.show(
      text,
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
      backgroundColor: chooseToastColor(state),
    );

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;

    case ToastStates.ERROR:
      color = Colors.red;
      break;

    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildListProduct(
  model,
  context, {
  bool isOldPrice = true,
}) =>
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage('${model.image}'),
                  width: 120.0,
                  height: 120.0,
                ),
                if (model.discount != 0 && isOldPrice)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    color: Colors.red,
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(fontSize: 8.0, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          model.oldPrice.toString(),
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id!);
                          // ignore: invalid_use_of_protected_member
                          SearchCubit.get(context).emit(SearchSuccessState());
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                              ShopCubit.get(context).favorites[model.id]!
                                  ? defaultColor
                                  : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
