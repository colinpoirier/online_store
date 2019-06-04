import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_store/blocs/cart_bloc/cart.dart';
import 'package:online_store/ui/helper_widgets/product_list_tile.dart';
import 'package:online_store/ui/helper_widgets/search_page/search_page_helper_widgets.dart';

class ProductBuilder extends StatelessWidget {
  final String category;
  final List<DocumentSnapshot> products;

  ProductBuilder({Key key, this.category, this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        int itemCount = products.length;
        int indexCount = (itemCount * 2 - 1) < 0 ? 0 : (itemCount * 2 - 1);
        return CustomScrollView(
          key: PageStorageKey(category),
          slivers: <Widget>[
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index.isEven) {
                    return ProductListTile(
                      product: products[index],
                      onPressed: () => BlocProvider.of<CartBloc>(context)
                          .dispatch(AddToCart(product: products[index])),
                    );
                  } else {
                    return const SeperaterContainer();
                  }
                },
                childCount: indexCount,
                semanticIndexCallback: (_ ,index) {
                  return index.isEven ? index ~/ 2 : null;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
