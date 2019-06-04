import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_store/blocs/cart_bloc/cart.dart';
import 'package:online_store/ui/helper_widgets/cart_icon.dart';

class ProductPage extends StatelessWidget {
  final DocumentSnapshot product;

  ProductPage({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product['name'],
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          IconButton(
            icon: CartIcon(),
            onPressed: () => Navigator.of(context).pushNamed('/cartPage'),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(product['image']),
            )),
          ),
          Text(product['name']),
          Text(product['brand']),
          Text(product['price'].toString()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_shopping_cart),
        onPressed: () => BlocProvider.of<CartBloc>(context)
            .dispatch(AddToCart(product: product)),
      ),
    );
  }
}
