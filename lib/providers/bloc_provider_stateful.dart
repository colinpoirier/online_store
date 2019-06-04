import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_store/blocs/cart_bloc/cart.dart';
import 'package:online_store/blocs/dbData_bloc/dbData.dart';
import 'package:online_store/models_and_repos/dbRepository/dbRepository.dart';

class BlocProviderStateful extends StatefulWidget {
  final Widget child;

  BlocProviderStateful({Key key, this.child}) : super(key: key);

  _BlocProviderStatefulState createState() => _BlocProviderStatefulState();
}

class _BlocProviderStatefulState extends State<BlocProviderStateful> {
  CartBloc cartBloc;
  DbDataBloc dbDataBloc;

  DbRepository dbRepository;

  @override
  void initState() { 
    super.initState();
    dbRepository = DbRepository();    
    cartBloc = CartBloc();
    dbDataBloc = DbDataBloc(dbRepository: dbRepository);
    dbDataBloc.dispatch(GetDbData());
  }

  @override
  void dispose() {
    super.dispose();
    cartBloc.dispose();
    dbDataBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<CartBloc>(bloc: cartBloc),
        BlocProvider<DbDataBloc>(bloc: dbDataBloc,)
        ],
      child: widget.child,
    );
  }
}