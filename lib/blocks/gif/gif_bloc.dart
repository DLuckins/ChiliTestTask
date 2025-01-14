import 'package:flutter_application_1/blocks/gif/gif_event.dart';
import 'package:flutter_application_1/blocks/gif/gif_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  GifBloc() : super(InitialState()) {
    on<GifSearch>((event, emit) {
      emit(SearchState(search: event.word));
    });
    on<GifFound>((event, emit) {
      emit(FoundState());
    });
    on<GifLoading>((event, emit) {
      emit(LoadingState());
    });
  }
}
