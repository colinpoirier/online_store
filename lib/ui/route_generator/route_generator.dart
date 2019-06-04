import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/ui/pages/cart_page.dart';
import 'package:online_store/ui/pages/checkout_details.dart';
import 'package:online_store/ui/pages/home_page.dart';
import 'package:online_store/ui/pages/product_page.dart';
import 'package:online_store/ui/pages/search_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/cartPage':
        return MaterialPageRoute(builder: (_) => CartPage());
      case '/productPage':
        if(args is DocumentSnapshot){
          return MaterialPageRoute(builder: (_) => ProductPage(product: args,));
        }
        return _errorRoute();
      case '/searchPage':
        return MaterialPageRoute(builder: (_) => SearchPage());
      case '/checkoutDetails':
        if(args is Map){
         return MaterialPageRoute(builder: (_) => CheckoutDetails(
           isDelivery: args['isDelivery'],
           products: args['products'],
           totalPrice: args['totalPrice'],
           )); 
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Error'),),
      );
    });
  }
}
 