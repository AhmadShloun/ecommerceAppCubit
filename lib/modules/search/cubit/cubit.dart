import 'package:ecommerceapp_cubit/models/search_model.dart';
import 'package:ecommerceapp_cubit/modules/search/cubit/states.dart';
import 'package:ecommerceapp_cubit/shared/components/constants.dart';
import 'package:ecommerceapp_cubit/shared/network/end_points.dart';
import 'package:ecommerceapp_cubit/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String text) {
    emit(SearchLoadingState());

    DioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text': text,
      },
    ).then((value) {
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
