import '../../models/api_response.dart';
import '../../models/coupon.dart';
import '../../models/my_notification.dart';
import '../../models/order.dart';
import '../../models/poster.dart';
import '../../models/product.dart';
import '../../models/variant_type.dart';
import '../../services/http_services.dart';
import '../../utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import '../../../models/category.dart';
import '../../models/brand.dart';
import '../../models/sub_category.dart';
import '../../models/variant.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];
  List<Brand> get brands => _filteredBrands;

  List<VariantType> _allVariantTypes = [];
  List<VariantType> _filteredVariantTypes = [];
  List<VariantType> get variantTypes => _filteredVariantTypes;

  List<Variant> _allVariants = [];
  List<Variant> _filteredVariants = [];
  List<Variant> get variants => _filteredVariants;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;

  List<Coupon> _allCoupons = [];
  List<Coupon> _filteredCoupons = [];
  List<Coupon> get coupons => _filteredCoupons;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;

  List<MyNotification> _allNotifications = [];
  List<MyNotification> _filteredNotifications = [];
  List<MyNotification> get notifications => _filteredNotifications;

  DataProvider() {
    getAllCategory();
    getAllSubCategory();
  }


Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try{
      Response response = await service.getItems(endpointUrl: 'categories');
      if(response.isOk){
        ApiResponse<List<Category>> apiResponse = ApiResponse<List<Category>>.fromJson(
          response.body,
            (json) => (json as List).map((item) => Category.fromJson(item)).toList(),
        );
        _allCategories = apiResponse.data ?? [];
        _filteredCategories = List.from(_allCategories);
        notifyListeners();
        if(showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch(err){

      if(showSnack) SnackBarHelper.showErrorSnackBar(err.toString());
      rethrow;
    }
    return _filteredCategories;
}

  void filterCategories(String keyword){
    if(keyword.isEmpty){
      _filteredCategories = List.from(_allCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredCategories = _allCategories.where((category){
        return (category.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<SubCategory>> getAllSubCategory({bool showSnack = false}) async {
    try{
      Response response = await service.getItems(endpointUrl: 'subCategories');
      if(response.isOk){
        ApiResponse<List<SubCategory>> apiResponse = ApiResponse<List<SubCategory>>.fromJson(
          response.body,
              (json) => (json as List).map((item) => SubCategory.fromJson(item)).toList(),
        );
        _allSubCategories = apiResponse.data ?? [];
        _filteredSubCategories = List.from(_allSubCategories);
        notifyListeners();
        if(showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch(err){

      if(showSnack) SnackBarHelper.showErrorSnackBar(err.toString());
      rethrow;
    }
    return _filteredSubCategories;
  }

  //TODO: should complete filterSubCategories
  void filterSubCategories(String keyword){
    if(keyword.isEmpty){
      _filteredCategories = List.from(_allSubCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredSubCategories = _allSubCategories.where((subCategory){
        return (subCategory.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }


  //TODO: should complete getAllBrands


  //TODO: should complete filterBrands


  //TODO: should complete getAllVariantType


  //TODO: should complete filterVariantTypes



  //TODO: should complete getAllVariant


  //TODO: should complete filterVariants


  //TODO: should complete getAllProduct


  //TODO: should complete filterProducts


  //TODO: should complete getAllCoupons


  //TODO: should complete filterCoupons


  //TODO: should complete getAllPosters


  //TODO: should complete filterPosters


  //TODO: should complete getAllNotifications


  //TODO: should complete filterNotifications


  //TODO: should complete getAllOrders


  //TODO: should complete filterOrders




  //TODO: should complete calculateOrdersWithStatus


  //TODO: should complete filterProductsByQuantity


  //TODO: should complete calculateProductWithQuantity


}
