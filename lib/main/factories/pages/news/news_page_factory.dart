import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import 'news_presenter_factory.dart';

Widget makeLoginPage() => NewsPage(presenter: makeGetxNewsPresenter());
