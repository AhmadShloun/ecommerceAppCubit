import 'package:bloc/bloc.dart';
import 'package:ecommerceapp_cubit/shared/cubit/states.dart';
import 'package:ecommerceapp_cubit/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  //object AppCubit
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Database? database;

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;


  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }



  void changeBottomSheetState({
    @required bool? isShow,
    @required IconData? icon,
  }) {
    isBottomSheetShow = isShow!;
    fabIcon = icon!;

    emit(AppChangeBottomSheetState());
  }




  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
    }
    else
      isDark = !isDark;
    CacheHelper.putbool(key: 'isDark', value: isDark).then((value) {
      emit(AppChangeMode());
    });
  }
}
