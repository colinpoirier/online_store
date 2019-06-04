import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchEvent extends Equatable {
  SearchEvent([List props = const []]) : super(props);
}

class SearchDbData extends SearchEvent{
  final String query;

  SearchDbData({this.query}):super([query]);
}

