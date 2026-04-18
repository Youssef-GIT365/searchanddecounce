import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:searchanddecounce/controller/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  List<String> allData = [
    "Flutter",
    "Firebase",
    "Dart",
    "React",
    "Node",
    "Python",
    "Java",
    "C++",
  ];

  List<String> history = [];

  Timer? _debounce;

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.isEmpty) {
        emit(SearchHistoryState(history));
      } else {
        _search(query);
      }
    });
  }

  void _search(String query) {
    emit(SearchLoading());

    List<Map<String, dynamic>> scored = [];

    for (var item in allData) {
      int score = 0;

      if (item.toLowerCase() == query.toLowerCase()) {
        score = 3;
      } else if (item.toLowerCase().startsWith(query.toLowerCase())) {
        score = 2;
      } else if (item.toLowerCase().contains(query.toLowerCase())) {
        score = 1;
      }

      if (score > 0) {
        scored.add({"item": item, "score": score});
      }
    }

    scored.sort((a, b) => b["score"].compareTo(a["score"]));

    List<String> results = scored.map((e) => e["item"] as String).toList();

    _addToHistory(query);

    emit(SearchResults(results));
  }

  void _addToHistory(String query) {
    if (history.contains(query)) return;

    history.insert(0, query);

    if (history.length > 5) {
      history.removeLast();
    }
  }
}
