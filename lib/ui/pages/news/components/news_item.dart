import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../news.dart';

class NewsItem extends StatelessWidget {
  final NewsViewModel viewModel;

  const NewsItem({Key key, @required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.name,
              style: TextStyle(fontSize: 16),
            ),
            Text(viewModel.content),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                viewModel.createAt,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
