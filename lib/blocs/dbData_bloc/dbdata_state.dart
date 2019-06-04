import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DbDataState extends Equatable {
  DbDataState([List props = const []]) : super(props);
}

class InitialDbdataState extends DbDataState {}

class LoadingDbData extends DbDataState{}

class HasDbData extends DbDataState{
  final List<DocumentSnapshot> dbData;

  HasDbData({this.dbData}):super([dbData]);
}

class DbError extends DbDataState{}
