import 'package:ecommerceapp_cubit/modules/search/cubit/cubit.dart';
import 'package:ecommerceapp_cubit/modules/search/cubit/states.dart';
import 'package:ecommerceapp_cubit/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      labelText: 'Search',
                      prefixIcon: Icons.search,
                      onSubmitted: (text) {
                        SearchCubit.get(context).search(text!);
                        return null;
                      },
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'enter text to search';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchLoadingState) const LinearProgressIndicator(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => buildListProduct(
                            SearchCubit.get(context).model!.data!.data![index],
                            context,
                            isOldPrice: false,
                          ),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount: SearchCubit.get(context)
                              .model!
                              .data!
                              .data!
                              .length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
