import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';

import 'package:client/data/news_item.dart';

class NewsItem extends StatelessWidget {
  NewsItem({super.key, required this.item});

  final _theme = ThemeProvider();

  final NewsItemData item;  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text( item.title, style: _theme.styleNewsTitle, ),
        SizedBox( height: _theme.gap / 2 ),
        Text( item.posted.toString(), style: _theme.styleNewsPosted, ),
        SizedBox( height: _theme.gap / 2 ),
        Text( item.body, style: _theme.styleNewsBody, ),        
      ],
    );
  }
}