abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResults extends SearchState {
  final List<String> results;
  SearchResults(this.results);
}

class SearchSuggestions extends SearchState {
  final List<String> suggestions;
  SearchSuggestions(this.suggestions);
}

class SearchHistoryState extends SearchState {
  final List<String> history;
  SearchHistoryState(this.history);
}