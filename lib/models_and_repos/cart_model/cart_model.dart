import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  final double price;
  final int count;
  final int checkoutCount;
  final String barcodeNumber;
  final String productName;
  final String brand;
  final String category;
  final String docId;
  final String image;
  final String imageThumb;

  CartModel(
      {this.count,
      this.checkoutCount,
      this.price,
      this.barcodeNumber,
      this.productName,
      this.category,
      this.brand,
      this.docId,
      this.image,
      this.imageThumb
      })
      : super([
          count,
          checkoutCount,
          price,
          barcodeNumber,
          productName,
          category,
          brand,
          docId,
          image,
          imageThumb
        ]);

  static CartModel fromDb(DocumentSnapshot product) {
    return CartModel(
      docId: product.documentID,
      count: product.data['count'],
      checkoutCount: 1,
      price: product.data['price'],
      barcodeNumber: product.data['barcode'],
      brand: product.data['brand'],
      category: product.data['category'],
      productName: product.data['name'],
      image: product.data['image'],
      imageThumb: product.data['imageThumb']
    );
  }

  static Map toMap(CartModel checkoutData) => {
        'docId': checkoutData.docId,
        'barcode': checkoutData.barcodeNumber,
        'count': checkoutData.count,
        'checkoutCount': checkoutData.checkoutCount,
        'price': checkoutData.price,
        'brand': checkoutData.brand,
        'name': checkoutData.productName,
        'category': checkoutData.category,
        // 'image': checkoutData.image,
        // 'imageThumb': checkoutData.imageThumb
      };

  CartModel copyWith({
    double price, 
    int count,
    int checkoutCount,
    String barcodeNumber,
    String productName,
    String brand,
    String category,
    String docId,
    String image,
    String imageThumb
    })=> CartModel(
      price: price ?? this.price,
      category: category ?? this.category,
      checkoutCount: checkoutCount ?? this.checkoutCount,
      count: count ?? this.count,
      barcodeNumber: barcodeNumber ?? this.barcodeNumber,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      docId: docId ?? this.docId,
      image: image ?? this.image,
      imageThumb: imageThumb ?? this.imageThumb
    );
}
