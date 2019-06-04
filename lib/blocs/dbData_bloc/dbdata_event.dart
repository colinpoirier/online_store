import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DbDataEvent extends Equatable {
  DbDataEvent([List props = const []]) : super(props);
}

class GetDbData extends DbDataEvent{}