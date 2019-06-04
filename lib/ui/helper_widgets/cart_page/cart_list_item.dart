import 'package:flutter/material.dart';
import 'package:online_store/blocs/cart_bloc/cart.dart';
import 'package:online_store/models_and_repos/cart_model/cart_model.dart';
import '../animated_text_switcher.dart';

class CheckoutListItem extends StatelessWidget {
  const CheckoutListItem({
    Key key,
    this.cartBloc,
    this.cartModel,
  }) : super(key: key);

  final CartBloc cartBloc;
  final CartModel cartModel;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) => cartBloc.dispatch(Delete(product: cartModel)),
      key: Key(cartModel.barcodeNumber),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 8),
            padding: const EdgeInsets.symmetric(horizontal: 45),
            height: 60,
            width: 150.0,
            child: CircleAvatar(
              maxRadius: 20,
              backgroundImage: NetworkImage(cartModel.imageThumb),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: cartModel.checkoutCount > 1
                ? () => cartBloc.dispatch(
                      DecreaseCount(
                        product: cartModel,
                      ),
                    )
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: cartModel.checkoutCount < cartModel.count
                ? () => cartBloc.dispatch(
                      IncreaseCount(
                        product: cartModel,
                      ),
                    )
                : null,
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            width: 85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                AnimatedTextSwitcher(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${cartModel.checkoutCount}',
                    key: ValueKey<int>(cartModel.checkoutCount),
                  ),
                ),
                Text(
                  ' x ' + cartModel.price.toStringAsFixed(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
