import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_store/providers/bloc_provider_stateful.dart';
import 'package:online_store/ui/route_generator/route_generator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.blue
    ));
    return BlocProviderStateful(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Online Store',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
