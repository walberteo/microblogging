import 'package:flutter/material.dart';

import '../../helpers/i18n/i18n.dart';
import 'components/news_item.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.translations.news),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [NewsItem(), NewsItem(), NewsItem()],
        ),
      ),
    );
  }
}
