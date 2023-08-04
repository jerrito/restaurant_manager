import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:manager/models/user.dart';
import 'package:manager/userProvider.dart';

enum QueryStatus { successful, failed }

class QueryResult<T> {
  QueryStatus? status;
  T? data;
  dynamic error;

  QueryResult({this.status, this.data, this.error});
}

abstract class Serializable {
  Map<String, dynamic> toJson();
}

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final usersRef = FirebaseFirestore.instance
      .collection('pashewRestaurantManagerAccount')
      .withConverter<Customer>(
        fromFirestore: (snapshot, _) => Customer.fromJson(snapshot.data()!),
        toFirestore: (customer, _) => customer.toJson(),
      );


  Future<QueryResult<Customer>?> getUser({required String phoneNumber}) async {
    QueryResult<Customer>? result;
    return await usersRef
        .where("number", isEqualTo: phoneNumber)
        .get()
        .then((snapshot) {
      var userSnapShot = snapshot.docs;

      Customer? data;
      if (userSnapShot.isNotEmpty) {
        data = userSnapShot.first.data();
        data.id = userSnapShot.first.id;
        //data.id=
        print(data.id);
      }

      var status = QueryStatus.successful;

      result = QueryResult(
        status: status,
        data: data,
      );
      return result;
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to get user: $error");
      }
      var status = QueryStatus.failed;
      var errorMsg = error;
      result = QueryResult(status: status, error: errorMsg);

      return result;
    });
  }
  

  Future<QueryResult<Customer>?> getUser_2(
      {required String phoneNumber, required String password}) async {
    QueryResult<Customer>? result;

    //
    return await usersRef
        .where("number", isEqualTo: phoneNumber)
        .get()
        .then((snapshot) {
      var userSnapShot = snapshot.docs;

      Customer? data;
      if (userSnapShot.isNotEmpty) {
        data = userSnapShot.first.data();
        data.id = userSnapShot.first.id;
      }

      var status = QueryStatus.successful;

      result = QueryResult(
        status: status,
        data: data,
      );
      return result;
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to get user: $error");
      }
      var status = QueryStatus.failed;
      var errorMsg = error;
      result = QueryResult(status: status, error: errorMsg);

      return result;
    });
  }

  Future<QueryResult<Customer>?>? saveUser({required Customer user}) async {
    QueryResult<Customer>? result;

    //
    await usersRef.add(user).then((value) {
      result = QueryResult(status: QueryStatus.successful);
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to add user: $error");
      }
      result?.status = QueryStatus.failed;
      result?.error = error;
    });

    return result;
  }

  Future<QueryResult<Customer>?> updateUser({required Customer customer}) async {
    QueryResult<Customer>? result;
    print(customer.id);

    //
    await usersRef.doc(customer.id).update(customer.toJson()).then((value) {
      result = QueryResult(status: QueryStatus.successful);
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to update user: $error");
      }
      result?.status = QueryStatus.failed;
      result?.error = error;
    });

    return result;
  }
  Future<void> addProduct(
      double price,
      String description,
      String productName,
      String picture,
      String collectionName,
      String? id) async {
    var user = <String, dynamic>{
      "price": price,
      "picture": picture,
      "description": description,
      "productName": productName,
    };
    await FirebaseFirestore.instance
        .collection("pashewRestaurantManagerAccount")
        .doc(id)
        .collection(collectionName)
        .doc()
        .set(user);
  }
}



enum QueryStatuses { successful, failed }

class QueryResults<T> {
  QueryStatuses? status;
  T? data;
  dynamic error;

  QueryResults({this.status, this.data, this.error});
}



class ProductServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ProductProvider? productProvider;

  final usersRef = FirebaseFirestore.instance
      .collection('pashewRestaurantManagerAccount')
      .doc().
  collection("Products")
      .withConverter<Product>(
    fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
    toFirestore: (product, _) => product.toJson(),
  );


  Future<QueryResults<Product>?> getProduct(
      {required String productName, required String id}) async {
    QueryResults<Product>? result;
    return await FirebaseFirestore.instance
        .collection('pashewRestaurantManagerAccount')
        .doc(id).
    collection("Products")
        .withConverter<Product>(
      fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson(),
    ).where("productName", isEqualTo: productName)
        .get()
        .then((snapshot) {
      var userSnapShot = snapshot.docs;
      Product? data;
      if (userSnapShot.isNotEmpty) {
        data = userSnapShot.first.data();
        data.id = userSnapShot.first.id;
        //data.id=
        print(data.id);
      }

      var status = QueryStatuses.successful;

      result = QueryResults(
        status: status,
        data: data,
      );
      return result;
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to get user: $error");
      }
      var status = QueryStatuses.failed;
      var errorMsg = error;
      result = QueryResults(status: status, error: errorMsg);

      return result;
    });
  }
  Future<QueryResults<Product>?> getCategoryProduct(
      {required String productName, required String value,
        required String restuarantName}) async {
    QueryResults<Product>? result;
    return await FirebaseFirestore.instance
        .collection('pashewRestaurantManagerAccount')
        .doc("category").
    collection(value)
        .withConverter<Product>(
      fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson(),
    ).where("productName", isEqualTo: productName)
    .where("restaurantName",isEqualTo: restuarantName)
        .get()
        .then((snapshot) {
      var userSnapShot = snapshot.docs;
      Product? data;
      if (userSnapShot.isNotEmpty) {
        data = userSnapShot.first.data();
        data.id = userSnapShot.first.id;
        //data.id=
        print(data.id);
      }

      var status = QueryStatuses.successful;

      result = QueryResults(
        status: status,
        data: data,
      );
      return result;
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to get user: $error");
      }
      var status = QueryStatuses.failed;
      var errorMsg = error;
      result = QueryResults(status: status, error: errorMsg);

      return result;
    });
  }

  Future<QueryResults<Product>?>? saveUser(
      {required Product product, id}) async {
    QueryResults<Product>? result;
    FirebaseFirestore.instance
        .collection('pashewRestaurantManagerAccount')
        .doc(id).
    collection("Products")
        .withConverter<Product>(
      fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson(),
    ).add(product).then((value) {
      result = QueryResults(status: QueryStatuses.successful);
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to add user: $error");
      }
      result?.status = QueryStatuses.failed;
      result?.error = error;
    });
    return result;
  }

  Future<QueryResults<Product>?>? saveCategory(
      {required Product product, value}) async {
    QueryResults<Product>? result;
    FirebaseFirestore.instance
        .collection('pashewRestaurantManagerAccount')
        .doc("category").
    collection(value)
        .withConverter<Product>(
      fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson(),
    ).add(product).then((value) {
      result = QueryResults(status: QueryStatuses.successful);
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to add user: $error");
      }
      result?.status = QueryStatuses.failed;
      result?.error = error;
    });
    return result;
  }

  Future<QueryResults<Product>?> updateProduct(
      {required Product product, required id}) async {
    QueryResults<Product>? result;
    //print(product.id);

    //
    await FirebaseFirestore.instance
        .collection('pashewRestaurantManagerAccount')
        .doc(id).
    collection("Products")
        .withConverter<Product>(
      fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson(),
    ).doc(product.id).update(product.toJson()).then((value) {
      result = QueryResults(status: QueryStatuses.successful);
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to update user: $error");
      }
      result?.status = QueryStatuses.failed;
      result?.error = error;
    });

    return result;
  }


  Future<QueryResults<Product>?> updateCategory(
      {required Product product, required String value,required String prodId}) async {
    QueryResults<Product>? result;
    //print(product.id);

    //
    await FirebaseFirestore.instance
        .collection('pashewRestaurantManagerAccount')
        .doc("category").
    collection(value)
        .withConverter<Product>(
      fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson(),
    ).doc(prodId).update(product.toJson()).then((value) {
      result = QueryResults(status: QueryStatuses.successful);
    //  print("success");
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to update user: $error");
      }
      result?.status = QueryStatuses.failed;
      result?.error = error;
    });

    return result;
  }

}


// class FirebaseAppCheckHelper {
//   FirebaseAppCheckHelper._();
//
//   static Future initialise() async {
//     await FirebaseAppCheck.instance.activate(
//       webRecaptchaSiteKey: 'recaptcha-v3-site-key',
//       androidProvider: _androidProvider(),
//     );
//   }
//
//   static AndroidProvider _androidProvider() {
//     if (kDebugMode) {
//       return AndroidProvider.debug;
//     }
//
//     return AndroidProvider.playIntegrity;
//   }
// }
