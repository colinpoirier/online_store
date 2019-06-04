import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:online_store/models_and_repos/cart_model/cart_model.dart';

@immutable
abstract class CartEvent extends Equatable {
  CartEvent([List props = const []]) : super(props);
}

class AddToCart extends CartEvent{
  final DocumentSnapshot product;

  AddToCart({this.product}):super([product]);
}

class IncreaseCount extends CartEvent{
  final CartModel product;

  IncreaseCount({this.product}):super([product]);
}

class DecreaseCount extends CartEvent{
  final CartModel product;

  DecreaseCount({this.product}):super([product]);
}

class Delete extends CartEvent{
  final CartModel product;
  
  Delete({this.product}):super([product]);
}

class CompleteCheckout extends CartEvent{
  final List<CartModel> products;

  CompleteCheckout({this.products}):super([products]);
}

class CheckoutCompleted extends CartEvent{}