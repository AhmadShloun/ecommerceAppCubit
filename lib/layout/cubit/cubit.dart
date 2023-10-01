import 'package:bloc/bloc.dart';
import 'package:ecommerceapp_cubit/layout/cubit/states.dart';
import 'package:ecommerceapp_cubit/models/categories_model.dart';
import 'package:ecommerceapp_cubit/models/change_favorites_model.dart';
import 'package:ecommerceapp_cubit/models/favorites_model.dart';
import 'package:ecommerceapp_cubit/models/home_model.dart';
import 'package:ecommerceapp_cubit/models/login_model.dart';
import 'package:ecommerceapp_cubit/modules/cateogries/cateogries_screen.dart';
import 'package:ecommerceapp_cubit/modules/favorites/favorites+screen.dart';
import 'package:ecommerceapp_cubit/modules/products/products_screen.dart';
import 'package:ecommerceapp_cubit/modules/settings/settings_screen.dart';
import 'package:ecommerceapp_cubit/shared/components/constants.dart';
import 'package:ecommerceapp_cubit/shared/network/end_points.dart';
import 'package:ecommerceapp_cubit/shared/network/remote/dio_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottonScreens = [
    ProductsScreen(),
    CateogriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomnNavState());
  }

  HomeModel? homeModel;

  //id (true, false)
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      // print(homeModel!.data!.banners[0].image);
      // print(homeModel.toString());
      // print('${homeModel!.status}');\
      for (var element in homeModel!.data!.products) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      }

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (kDebugMode) {
        print(value.data);
      }

      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorUpdateUserState());
    });
  }
}
