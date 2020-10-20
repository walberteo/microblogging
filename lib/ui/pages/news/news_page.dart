import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import 'components/news_item.dart';
import 'news_presenter.dart';
import 'news_viewmodel.dart';

class NewsPage extends StatelessWidget {
  final NewsPresenter presenter;

  const NewsPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text(R.translations.news),
      ),
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          return SafeArea(
            child: StreamBuilder<List<NewsViewModel>>(
                stream: presenter.loadNewsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      children: [
                        Text(snapshot.error),
                        RaisedButton(
                          child: Text(R.translations.reloading),
                          onPressed: () {},
                        ),
                      ],
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [NewsItem(), NewsItem(), NewsItem()],
                  );
                }),
          );
        },
      ),
    );
  }
}
