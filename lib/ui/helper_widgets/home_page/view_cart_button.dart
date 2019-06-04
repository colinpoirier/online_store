import 'package:flutter/material.dart';
import 'package:online_store/ui/helper_widgets/cart_icon.dart';

class ViewCartButton extends StatelessWidget {
  const ViewCartButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 58,
      child: FloatingActionButton.extended(
        icon: const CartIcon(),
        label: const Text('View Cart'),
        onPressed: () => Navigator.of(context).pushNamed('/cartPage'),
      ),
    );
  }
}
