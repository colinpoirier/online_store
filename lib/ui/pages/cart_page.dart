import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_store/blocs/cart_bloc/cart.dart';
import 'package:online_store/ui/helper_widgets/cart_page/cart_page_helper_widgets.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = BlocProvider.of<CartBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: BlocBuilder(
        bloc: cartBloc,
        builder: (context, state) {
          Widget child;
          if (state is HasProducts) {
            child = ColorSeperatedList(
              key: const ValueKey<String>('__cartList__'),
              itemCount: state.products.length,
              itemBuilder: (context, index){
                return CheckoutListItem(
                  cartBloc: cartBloc,
                  cartModel: state.products[index],
                );
              },
            );
          } else if (state is AwaitingProducts) {
            child = const Center(child: Text('Cart Empty'));
          } else if (state is Error) {
            child = const Text('Error');
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: child,
          );
        },
      ),
      bottomNavigationBar: CartSummary(cartBloc: cartBloc),
    );
  }
}
