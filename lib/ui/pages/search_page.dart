import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_store/blocs/cart_bloc/cart.dart';
import 'package:online_store/blocs/dbData_bloc/dbData.dart';
import 'package:online_store/ui/helper_widgets/search_page/search_page_helper_widgets.dart';
import 'package:online_store/blocs/search_bloc/search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller;
  SearchBloc searchBloc;

  @override
  void initState() {
    controller = TextEditingController();
    final dbRepository = BlocProvider.of<DbDataBloc>(context).dbRepository;
    searchBloc = SearchBloc(dbRepository: dbRepository);
    searchBloc.dispatch(SearchDbData());
    controller.addListener(
        () => searchBloc.dispatch(SearchDbData(query: controller.text)));
    super.initState();
  }

  @override
  void dispose() {
    searchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Search',
            labelStyle: const TextStyle(color: Colors.black),
            hintText: 'Type to search',
            border: const UnderlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const CartIcon(),
            onPressed: () => Navigator.of(context)
                .pushNamed('/cartPage'),
          )
        ],
      ),
      body: BlocBuilder(
        bloc: searchBloc,
        builder: (context, state) {
          if (state is HasSearch) {
            final products = state.products;
            return ColorSeperatedList(
              itemCount: products.length,
              itemBuilder: (context, index){
                final product = products[index];
                return ProductListTile(
                  product: product,
                  onPressed: (){
                    BlocProvider.of<CartBloc>(context).dispatch(AddToCart(product: product));
                  },
                );
              },
            );
          } else if (state is Searching) {
            return const CircularProgressIndicator();
          } else if (state is SearchError) {
            return const Text('error');
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
