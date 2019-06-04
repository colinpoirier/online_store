import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_store/blocs/dbData_bloc/dbData.dart';
import 'package:online_store/ui/helper_widgets/home_page/home_page_helper_widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  ScrollController scrollController;

  List<String> tabNames = const [
    'Juice',
    'Snacks',
    'Pasta',
    'Fruit',
    'Vegetables',
    'Ice Cream',
    'Cereal'
  ];
  List<String> categoryNames = const [
    'Juice',
    'Snack',
    'Taco',
    'Fruit',
    'Vegetables',
    'Ice Cream',
    'Cereal'
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: tabNames.length);
    tabController.addListener(()=>_tabListener());
    scrollController = ScrollController();
  }

  void _tabListener(){
    // print(tabController.offset);
    // // if(tabController.indexIsChanging || tabController.offset > 0.0){
    //   print(tabController.previousIndex);
    //   print(tabController.index);
    // // }
  }

  @override
  void dispose() { 
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  List<Widget> _buildTabBar() {
    return tabNames
        .map((f) => Text(
              f,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, _) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
                forceElevated: true,
                pinned: true,
                title: const Text(
                  'Carlson\'s General Store',
                ),
                expandedHeight: 250.0,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => Navigator.of(context).pushNamed('/searchPage'),
                  ),
                ],
                bottom: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  tabs: _buildTabBar(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: BackgroundWithMovingGradient(
                    scrollController: scrollController,
                  ),
                ),
              ),
            )
          ];
        },
        body: BlocBuilder(
          bloc: BlocProvider.of<DbDataBloc>(context),
          builder: (context, state) {
            Widget child;
            if (state is HasDbData) {
              child = TabBarView(
                controller: tabController,
                children: categoryNames.map((category) {
                  var products = state.dbData
                      .where((d) => d.data['category'].contains(category))
                      .toList();
                  return ProductBuilder(products: products, category: category);
                }).toList(),
              );
            } else if (state is DbError) {
              child = const Center(child: Text('Error'));
            } else if (state is LoadingDbData) {
              child = const Center(child: CircularProgressIndicator());
            }
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: child,
            );
          },
        ),
      ),
      bottomNavigationBar: ViewCartButton(),
    );
  }
}
