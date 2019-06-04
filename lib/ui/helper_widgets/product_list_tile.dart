import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  final DocumentSnapshot product;
  final VoidCallback onPressed;

  ProductListTile({Key key, this.product, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product['imageThumb']),
      ),
      title: Text(product['name']),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(product['brand']),
          Text('\$' + product['price'].toStringAsFixed(2))
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: onPressed,
      ),
      onTap: () => Navigator.of(context).pushNamed(
            '/productPage',
            arguments: product,
          ),
    );
  }
}
