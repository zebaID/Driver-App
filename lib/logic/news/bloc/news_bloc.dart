import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/logic/news/news_model.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final AuthRepository authRepository;
  NewsBloc({required this.authRepository}) : super(const NewsState()) {
    on<GetNews>(_OnGetNews);
  }

  void _OnGetNews(GetNews event, Emitter<NewsState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final getNews = await authRepository.getNews();
      if (getNews != null) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            newsModel: jsonDecode(getNews)
                .map<NewsModel>((news) => NewsModel.fromJson(news))
                .toList()));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
