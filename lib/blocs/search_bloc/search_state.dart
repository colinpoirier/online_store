import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchState extends Equatable {
  SearchState([List props = const []]) : super(props);
}

class InitialSearchState extends SearchState {}

class Searching extends SearchState{}

class HasSearch extends SearchState{
  final List<DocumentSnapshot> products;

  HasSearch({this.products}):super([products]);
}

class SearchError extends SearchState{}