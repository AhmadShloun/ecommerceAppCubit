import 'package:conditional_builder/conditional_builder.dart';
import 'package:ecommerceapp_cubit/layout/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/layout/cubit/states.dart';
import 'package:ecommerceapp_cubit/shared/components/components.dart';
import 'package:ecommerceapp_cubit/shared/components/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is ShopLoadingUpdateUserState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      labelText: 'Name',
                      prefixIcon: Icons.person,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'name must not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      labelText: 'Email Address',
                      prefixIcon: Icons.email,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'email must not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      type: TextInputType.number,
                      labelText: 'Phone',
                      prefixIcon: Icons.phone,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'phone must not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                      text: 'update',
                      function: () {
                        if (formKey.currentState!.validate()) {
                          ShopCubit.get(context).updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                      text: 'Logout',
                      function: () {
                        signOut(context);
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                      text: 'king',
                      function: () {
                       if (kDebugMode) {
                         print(token);
                       }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
