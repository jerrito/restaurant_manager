import 'package:flutter/foundation.dart';
import 'package:manager/databases/firebase_services.dart';
import 'package:manager/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProvider extends ChangeNotifier {
  final SharedPreferences? preferences;
  final firebaseService = FirebaseServices();

  CustomerProvider({required this.preferences}) {
    var appUserString = preferences?.getString("app_user") ?? '';
    _appUser = appUserString.isNotEmpty ? Customer.fromString(appUserString) : null;
  }

  Customer? _appUser;
  Customer? get appUser => _appUser;

  set appUser(Customer? a) {
    _appUser = a;
    notifyListeners();

    preferences?.setString(
      "app_user",
      a?.toString() ?? '',
    );
  }

  Future<QueryResult<Customer>?>? getUser({required String phoneNumber}) async {
    var result = await firebaseService.getUser(phoneNumber: phoneNumber);

    if (result?.status == QueryStatus.successful && result?.data != null) {
      appUser = result?.data;
    }

    return result;
  }

  Future<QueryResult<Customer>?>? getUser_2(
      {required String phoneNumber, required String password}) async {
    var result = await firebaseService.getUser_2(
        phoneNumber: phoneNumber, password: password);

    if (result?.status == QueryStatus.successful && result?.data != null) {
      appUser = result?.data;
    }

    return result;
  }

  Future<QueryResult<Customer>?>? updateUser({required Customer customer}) async {
    var result = await firebaseService.updateUser(customer: customer);

    if (result?.status == QueryStatus.successful) {
      await getUser(phoneNumber: customer.number ?? "");
    }

    return result;
  }
}


class ProductProvider extends ChangeNotifier {
  final SharedPreferences? preference;
  final firebaseService = FirebaseServices();

  ProductProvider({required this.preference}) {
    var productTypeString = preference?.getString("type") ?? '';
        _type = productTypeString.isNotEmpty? Product.fromString(productTypeString) : null;
  }

  Product? _type;
  Product? get typeOf => _type;

  set typeOf(Product? a) {
    _type = a;
    notifyListeners();

    preference?.setString(
      "type",
      a?.toString() ?? '',
    );
  }

  Future<QueryResults<Product>?>? getProduct({required String productName,required String id}) async {
    var result = await ProductServices().getProduct(productName: productName,id:id);

    if (result?.status == QueryStatuses.successful && result?.data != null) {
      typeOf = result?.data;
    }

    return result;
  }
  Future<QueryResults<Product>?>? getCategoryProduct({required String productName,
    required String value,required String restuarantName}) async {
    var result = await ProductServices().getCategoryProduct(productName: productName,
        restuarantName:restuarantName,value:value);

    if (result?.status == QueryStatuses.successful && result?.data != null) {
      typeOf = result?.data;
    }

    return result;
  }



  Future<QueryResults<Product>?>? updateProduct({required Product product, required id}) async {
    var result = await ProductServices().updateProduct(product: product,id:id);
    //var result_2 = await ProductServices().updateCategory(product: product,value:id);

    if (result?.status == QueryStatuses.successful) {
      await getProduct(productName: product.productName ?? "", id: product.id ?? "");
    }

    return result;
  }
  Future<QueryResults<Product>?>? updateCategory({required Product product,
    required String value, required String prodId}) async {
    //var result = await ProductServices().updateProduct(product: product,id:id);
    var result = await ProductServices().updateCategory(product: product,value:value,
        prodId: prodId);

    if (result?.status == QueryStatuses.successful) {
      await getCategoryProduct(productName: product.productName ?? "",
          value:product.id ?? "",
          restuarantName: product.restaurantName ?? "");
    }

    return result;
  }
}
