abstract class GifState {}

class InitialState extends GifState {}

class SearchState extends GifState {
  final String search;
  SearchState({required this.search});
}

class FoundState extends GifState {}

class LoadingState extends GifState {}
