import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                title: Text('Carlson\'s General Store',
                style: TextStyle(
                  color: Colors.black
                  ),
                ),
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'assets/store.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              !snapshot.hasData 
              ? SliverList(delegate: SliverChildBuilderDelegate((context, index){
                return CircularProgressIndicator();
              }),)
              : SliverFixedExtentList(
                itemExtent: 700,
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data.documents[index]['image']),
                    ),
                    title: Text(snapshot.data.documents[index]['name']),
                    subtitle: Text(snapshot.data.documents[index]['brand']),
                  );
                },
                childCount: snapshot.data.documents.length,
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
