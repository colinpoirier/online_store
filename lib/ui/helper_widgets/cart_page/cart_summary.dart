import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_store/blocs/cart_bloc/cart.dart';
import '../animated_text_switcher.dart';

class CartSummary extends StatelessWidget {
  final CartBloc cartBloc;

  Future _showDeliveryChoice(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Is this for delivery?'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: const Text('Yes'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                FlatButton(
                  child: const Text('No'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop('cancel'),
              ),
            ],
          ),
    );
  }

  CartSummary({this.cartBloc});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder(
        bloc: cartBloc,
        builder: (context, state) {
          if (state is HasProducts) {
            int totalCount = 0;
            state.products.forEach((f) => totalCount += f.checkoutCount);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: AnimatedTextSwitcher(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Total items: $totalCount',
                      key: UniqueKey(),
                    ),
                  ),
                ),
                Expanded(
                  child: FloatingActionButton.extended(
                    label: const Text('Checkout'),
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      final isDelivery = await _showDeliveryChoice(context);
                      if (isDelivery != 'cancel')
                        Navigator.of(context)
                            .pushNamed('/checkoutDetails', arguments: {
                          'products': state.products,
                          'totalPrice': state.totalPrice,
                          'isDelivery': isDelivery
                        });
                    },
                  ),
                ),
                Expanded(
                  child: AnimatedTextSwitcher(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '\$${state.totalPrice.toStringAsFixed(2)}',
                      key: UniqueKey(),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is AwaitingProducts) {
            return const Text('');
          } else if (state is Error) {
            return const Text('Error');
          }
        },
      ),
    );
  }
}
