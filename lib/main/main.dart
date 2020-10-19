import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:microblogging/main/factories/pages/pages.dart';
import 'package:microblogging/ui/components/app_theme.dart';
import 'package:microblogging/ui/helpers/i18n/i18n.dart';

void main() {
  R.load(Locale('pt', 'BR'));
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: 'Walber - Microblogging',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: '/news',
      getPages: [GetPage(name: '/news', page: makeLoginPage)],
    );
  }
}
