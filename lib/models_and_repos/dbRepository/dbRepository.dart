import 'package:cloud_firestore/cloud_firestore.dart';

class DbRepository{
  List<DocumentSnapshot> products;

  Future getDbData() async{
    var productQuery = await Firestore.instance.collection('products').getDocuments();
    products = productQuery.documents;
  }
}