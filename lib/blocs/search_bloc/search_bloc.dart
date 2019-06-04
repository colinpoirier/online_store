import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:online_store/models_and_repos/dbRepository/dbRepository.dart';
import './search.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final DbRepository dbRepository;

  SearchBloc({this.dbRepository});

  @override
  SearchState get initialState => InitialSearchState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchDbData) {
      yield* _mapSearchDbDataToState(event);
    }
  }

  Stream<SearchState> _mapSearchDbDataToState(SearchDbData event) async* {
    yield Searching();
    try {
      assert(dbRepository.products != null);
      final dbProducts = dbRepository.products
          .where((product) => product['image'] != null)
          .toList();
      final products = event.query == null
          ? dbProducts.take(10).toList()
          : dbProducts
              .where((d) => d.data.values
                  .toList()
                  .toString()
                  .replaceAll(d.data['image'], '')
                  .replaceAll(d.data['imageThumb'], '')
                  .toLowerCase()
                  .contains(event.query.toLowerCase()))
              .take(50)
              .toList();
      yield HasSearch(products: products);
    } catch (_) {
      yield SearchError();
    }
  }
}
