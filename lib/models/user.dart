import 'dart:convert';

import 'package:manager/databases/firebase_services.dart';


class Customer implements Serializable {
  String? fullName;
  String? number;
  String? email;
  String? password;
  String? id;
  String? image;
  String? location;
  double? latitude;
  double? longitude;

  Customer({
    this.fullName,
    this.number,
    this.id,
    this.email,
    this.password,
    this.image,
    this.location,
    this.latitude,
    this.longitude,
  });
  factory Customer.fromJson(Map? json) => Customer(
        id: json?["id"],
        fullName: json?["fullName"],
        number: json?["number"],
        email: json?["email"],
        password: json?["password"],
        image: json?["image"],
        location: json?["location"],
        latitude: json?["latitude"],
       longitude: json?["longitude"],
      );
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "fullName": fullName,
      "number": number,
      "password": password,
      "email": email,
      "image": image,
      "location": location,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  static Customer fromString(String userString) {
    return Customer.fromJson(jsonDecode(userString));
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Product implements Serializable {
  String? productName;
  String? restaurantName;
  String? description;
  String? category;
  String? picture;
  String? id;
  double? price;



  Product({
    this.productName,
    this.description,
    this.id,
    this.picture,
    this.price,
    this.category,
    this.restaurantName

  });
  factory Product.fromJson(Map? json) => Product(
    id: json?["id"],
    productName: json?["productName"],
    description: json?["description"],
    picture: json?["picture"],
    price: json?["price"],
    category: json?["category"],
    restaurantName: json?["restaurantName"],

  );
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "productName": productName,
      "description": description,
      "picture": picture,
      "price": price,
      "category": category,
      "restaurantName": restaurantName,

    };
  }

  static Product fromString(String userString) {
    return Product.fromJson(jsonDecode(userString));
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}


class Orders {
  String? name;
  int? quantity;
  double? amount;
  String? title;
  double? totalAmount;
  int? date;
  String? id;
  String? status;
  bool? statusCheck;
  String? customerName;
  String? customerNumber;
  String? customerEmail;
  String? customerLocation;
  double? customerLongitude;
  double? customerLatitude;
  String? driverLocation;
  String? driverName;
  String? driverStatus;
  double? driverLongitude;
  double? driverLatitude;

  Orders({
    this.name,
    this.quantity,
    this.amount,
    this.title,
    this.totalAmount,
    this.date,
    this.id,
    this.status,
    this.statusCheck,
    this.customerName,
    this.customerNumber,
    this.customerEmail,
    this.customerLocation,
    this.customerLongitude,
    this.customerLatitude,
  });

  factory Orders.fromRawJson(String str) => Orders.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    name: json["name"],
    quantity: json["quantity"],
    amount: json["amount"]?.toDouble(),
    title: json["title"],
    totalAmount: json["totalAmount"]?.toDouble(),
    date: json["date"],
    id: json["id"],
    status: json["status"],
    statusCheck: json["statusCheck"],
    customerName: json["customerName"],
    customerNumber: json["customerNumber"],
    customerEmail: json["customerEmail"],
    customerLocation: json["customerLocation"],
    customerLongitude: json["customerLongitude"]?.toDouble(),
    customerLatitude: json["customerLatitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "amount": amount,
    "title": title,
    "totalAmount": totalAmount,
    "date": date,
    "id": id,
    "status": status,
    "statusCheck": statusCheck,
    "customerName": customerName,
    "customerNumber": customerNumber,
    "customerEmail": customerEmail,
    "customerLocation": customerLocation,
    "customerLongitude": customerLongitude,
    "customerLatitude": customerLatitude,
  };
}
