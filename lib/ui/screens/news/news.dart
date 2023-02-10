import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/logic/news/bloc/news_bloc.dart';
import 'package:id_driver/logic/news/news_model.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  void initState() {
    context.read<NewsBloc>().add(GetNews());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          return state.status.isSubmissionInProgress
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: state.newsModel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return NewsItem(
                      newsModel: state.newsModel[index],
                    );
                  });
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class NewsItem extends StatelessWidget {
  NewsModel newsModel;
  NewsItem({Key? key, required this.newsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                spreadRadius: 1.0,
                offset: const Offset(0.0, 1.0),
                color: Colors.grey.withOpacity(0.5),
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Container(
                  //     width: SizeConfig.screenWidth * 0.15,
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey.withOpacity(0.5),
                  //       borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(18.0),
                  //       child: Text(
                  //         newsModel.id.toString(),
                  //         textAlign: TextAlign.center,
                  //         style: const TextStyle(color: Colors.black),
                  //       ),
                  //     )),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: Text(
                        newsModel.news!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              // const Padding(
              //   padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              //   child: Text(
              //     "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
