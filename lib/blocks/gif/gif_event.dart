import 'package:equatable/equatable.dart';

class GifEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GifSearch extends GifEvent {
  final String word;
  GifSearch({required this.word});
}

class GifFound extends GifEvent {}

class GifLoading extends GifEvent {}
