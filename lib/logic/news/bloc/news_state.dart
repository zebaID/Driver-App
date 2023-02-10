part of 'news_bloc.dart';

class NewsState extends Equatable {
  final FormzStatus status;
  final List<NewsModel> newsModel;

  const NewsState({this.status = FormzStatus.pure, this.newsModel = const []});

  NewsState copyWith({
    FormzStatus? status,
    List<NewsModel>? newsModel,
  }) {
    return NewsState(
      status: status ?? this.status,
      newsModel: newsModel ?? this.newsModel,
    );
  }

  @override
  List<Object> get props => [status, newsModel];
}
