import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:online_store/models_and_repos/dbRepository/dbRepository.dart';
import './dbData.dart';

class DbDataBloc extends Bloc<DbDataEvent, DbDataState> {
  final DbRepository dbRepository;

  DbDataBloc({this.dbRepository});

  @override
  DbDataState get initialState => InitialDbdataState();

  @override
  Stream<DbDataState> mapEventToState(
    DbDataEvent event,
  ) async* {
    if (event is GetDbData){
      yield* _mapGetDbDataToState();
    }
  }

  Stream<DbDataState> _mapGetDbDataToState() async* {
    yield LoadingDbData();
    try{
      await dbRepository.getDbData();
      final dbData = dbRepository.products.where((product)=>product['image'] != null).toList();
      yield HasDbData(dbData: dbData);
    } catch (_){
      yield DbError();
    }
  }
}
