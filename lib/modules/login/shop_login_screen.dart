// ignore_for_file: must_be_immutable

import 'package:conditional_builder/conditional_builder.dart';
import 'package:ecommerceapp_cubit/layout/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/layout/shop_layout.dart';
import 'package:ecommerceapp_cubit/modules/login/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/modules/login/cubit/states.dart';
import 'package:ecommerceapp_cubit/modules/register_screen/shop_register_screen.dart';
import 'package:ecommerceapp_cubit/shared/components/components.dart';
import 'package:ecommerceapp_cubit/shared/components/constants.dart';
import 'package:ecommerceapp_cubit/shared/network/local/cache_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';

class ShopLoginScreen extends StatelessWidget {
  ShopLoginScreen({super.key});

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status!) {
              if (kDebugMode) {
                print(state.loginModel.data!.token);
                print(state.loginModel.message);
              }
              showToast(
                text: '${state.loginModel.message}',
                state: ToastStates.SUCCESS,
              );
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                //مهمة جدا مشان يحفظا بس اسجل ما ياخود الفديم لما اعمل تسجيل خروج

                token = '${state.loginModel.data!.token}';
                ShopCubit.get(context).getUserData();
                ShopCubit.get(context).getHomeData();
                ShopCubit.get(context).getCategoriesData();
                ShopCubit.get(context).getFavorites();

                navigateAndFinish(context, const ShopLayout());
              });
            } else {
              if (kDebugMode) {
                print(state.loginModel.message);
              }

              showToast(
                text: '${state.loginModel.message}',
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Colors.black,
                              ),
                        ),
                        Text(
                          'Login now to browse our hor offers',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          labelText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          labelText: 'Password',
                          prefixIcon: Icons.lock,
                          suffixIcon: ShopLoginCubit.get(context).suffix,
                          suffixPress: () {
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          onPassword:
                              ShopLoginCubit.get(context).isPasswordShow,
                          onSubmitted: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                            return null;
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                            text: 'login',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                            ),
                            defaultTextButton(
                              function: () {
                                navigateTo(context, ShopRegisterScreen());
                              },
                              text: 'register',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
