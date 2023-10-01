import 'package:ecommerceapp_cubit/layout/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/layout/cubit/states.dart';
import 'package:ecommerceapp_cubit/models/categories_model.dart';
import 'package:ecommerceapp_cubit/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CateogriesScreen extends StatelessWidget {
  const CateogriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildCatItem(ShopCubit.get(context).categoriesModel!.data!.data![index]),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: ShopCubit.get(context).categoriesModel!.data!.data!.length,
        );
      },
    );
  }

  Widget buildCatItem(DataModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(
                  '${model.image}'),
              height: 80.0,
              width: 80.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              '${model.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
            ),
          ],
        ),
      );
}
