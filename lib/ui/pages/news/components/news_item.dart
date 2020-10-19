import 'package:flutter/material.dart';

class NewsItem extends StatelessWidget {
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
              "O Boticário",
              style: TextStyle(fontSize: 16),
            ),
            Text(
                "Com a união das demais marcas do grupo, doamos 216 toneladas de produtos de higiene para comunidades em vulnerabilidade social de diversas partes do país."),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "19 out 2020",
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
