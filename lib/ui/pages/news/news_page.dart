import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../components/spinner_dialog.dart';
import '../../helpers/i18n/i18n.dart';
import 'components/news_item.dart';
import 'news_presenter.dart';

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
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [NewsItem(), NewsItem(), NewsItem()],
            ),
          );
        },
      ),
    );
  }
}
