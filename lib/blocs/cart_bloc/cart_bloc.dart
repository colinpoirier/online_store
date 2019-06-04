import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:online_store/models_and_repos/cart_model/cart_model.dart';
import './cart.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  @override
  CartState get initialState => AwaitingProducts();

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if(event is AddToCart){
      yield* _mapAddToCartToState(event, currentState);
    }else if (event is IncreaseCount) {
      yield* _mapIncreaseCheckoutCountToState(event, currentState);
    } else if (event is DecreaseCount) {
      yield* _mapDecreaseCheckoutCountToState(event, currentState);
    } else if (event is Delete) {
      yield* _mapDeleteToState(event, currentState);
    } else if (event is CheckoutCompleted){
      yield* _mapCheckoutCompletedToState();
    }
  }

  Stream<CartState> _mapAddToCartToState(
      AddToCart event, CartState state) async* {
    List<CartModel> products = state is HasProducts ? state.products : [];
    double totalPrice = 0.0;
    String eventDocId = event.product.documentID;
    try {
      yield AwaitingProducts();
      if (products.every((product) => product.docId != eventDocId)) {
        products.add(CartModel.fromDb(event.product));
      } else {
        products = products
            .map((product) => product.docId == eventDocId
                ? product.copyWith(checkoutCount: (product.checkoutCount + 1).clamp(1, product.count))
                : product)
            .toList();
      }
      products.forEach((p) {
        totalPrice += (p.price * p.checkoutCount);
      });
      yield HasProducts(products: products, totalPrice: totalPrice);
    } catch (_) {
      yield CartError();
    }
  }

  Stream<CartState> _mapIncreaseCheckoutCountToState(
      IncreaseCount event, CartState state) async* {
    if (state is HasProducts) {
      final updatedProducts = state.products
          .map((product) => product.barcodeNumber == event.product.barcodeNumber
              ? product.copyWith(checkoutCount: product.checkoutCount + 1)
              : product)
          .toList();
      yield HasProducts(
        products: updatedProducts,
        totalPrice: state.totalPrice + event.product.price,
      );
    }
  }

  Stream<CartState> _mapDecreaseCheckoutCountToState(
      DecreaseCount event, CartState state) async* {
    if (state is HasProducts) {
      final updatedProducts = state.products
          .map((product) => product.barcodeNumber == event.product.barcodeNumber
              ? product.copyWith(checkoutCount: product.checkoutCount - 1)
              : product)
          .toList();
      yield HasProducts(
        products: updatedProducts,
        totalPrice: state.totalPrice - event.product.price,
      );
    }
  }

  Stream<CartState> _mapDeleteToState(
      Delete event, CartState state) async* {
    if (state is HasProducts) {
      final updatedProducts = state.products
          .where(
              (product) => product.barcodeNumber != event.product.barcodeNumber)
          .toList();
      yield updatedProducts.isNotEmpty
          ? HasProducts(
              products: updatedProducts,
              totalPrice: state.totalPrice -
                  (event.product.price * event.product.checkoutCount),
            )
          : AwaitingProducts();
    }
  }

  Stream<CartState> _mapCheckoutCompletedToState() async* {
    yield AwaitingProducts();
  }  

}
