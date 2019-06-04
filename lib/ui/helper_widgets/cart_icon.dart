import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_store/blocs/cart_bloc/cart.dart';
import './animated_text_switcher.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        const Icon(Icons.shopping_cart),
        BlocBuilder(
          bloc: BlocProvider.of<CartBloc>(context),
          builder: (context, state) {
            int totalCount = 0;
            if (state is HasProducts)
              state.products.forEach((f) => totalCount += f.checkoutCount);
            return Positioned(
              top: -8,
              right: -5,
              child: AnimatedTextSwitcher(
                alignment: Alignment.center,
                child: Container(
                  key: UniqueKey(),
                  padding: const EdgeInsets.fromLTRB(3, 2, 2, 2),
                  decoration: state is HasProducts
                      ? const ShapeDecoration(
                          color: Colors.red,
                          shape: CircleBorder(),
                        )
                      : null,
                  child: state is HasProducts ? Text('$totalCount') : null,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
