import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:online_store/models_and_repos/cart_model/cart_model.dart';

@immutable
abstract class CartState extends Equatable {
  CartState([List props = const []]) : super(props);
}

class AwaitingProducts extends CartState {}

class HasProducts extends CartState{
  final List<CartModel> products;
  final double totalPrice;

  HasProducts({this.products, this.totalPrice}):super([products,totalPrice]);
}

class CartError extends CartState{}