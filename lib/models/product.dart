// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

class Product {
    bool avalaible;
    String name;
    String? picture;
    double price;
    String? id;

    Product({
        required this.avalaible,
        required this.name,
        this.picture,
        required this.price,
        this.id
    });

    factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        avalaible: json["avalaible"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "avalaible": avalaible,
        "name": name,
        "picture": picture,
        "price": price,
    };

    Product copy()=>Product(avalaible: avalaible, name: name, price: price, id: id, picture: picture);
}
