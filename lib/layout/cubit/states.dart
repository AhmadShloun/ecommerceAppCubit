
import 'package:ecommerceapp_cubit/models/change_favorites_model.dart';
import 'package:ecommerceapp_cubit/models/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomnNavState extends ShopStates{}
//-----------------------------------------
class ShopLoadingHomeDataState extends ShopStates{}

class ShopSuccessHomeDataState extends ShopStates{}

class ShopErrorHomeDataState extends ShopStates{}
//-----------------------------------------

class ShopSuccessCategoriesState extends ShopStates{}

class ShopErrorCategoriesState extends ShopStates{}

//-----------------------------------------
class ShopChangeFavoritesState extends ShopStates{}

class ShopSuccessChangeFavoritesState extends ShopStates{
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}
class ShopErrorChangeFavoritesState extends ShopStates{}

class ShopLoadingGetFavoritesState extends ShopStates{}


class ShopSuccessGetFavoritesState extends ShopStates{}

class ShopErrorGetFavoritesState extends ShopStates{}



class ShopLoadingUserDataState extends ShopStates{}

class ShopSuccessUserDataState extends ShopStates{
  final ShopLoginModel model;

  ShopSuccessUserDataState(this.model);
}

class ShopErrorUserDataState extends ShopStates{}


class ShopLoadingUpdateUserState extends ShopStates{}

class ShopSuccessUpdateUserState extends ShopStates{
  final ShopLoginModel model;

  ShopSuccessUpdateUserState(this.model);
}

class ShopErrorUpdateUserState extends ShopStates{}