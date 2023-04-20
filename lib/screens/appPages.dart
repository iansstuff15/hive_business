import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:hive_business/components/AppLayout.dart';
import 'package:hive_business/screens/profile.dart';
import 'package:hive_business/screens/services.dart';

import 'home.dart';

class AppPages extends StatelessWidget {
  static String id = 'pages';

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return AppLayout(PageView(
      controller: controller,
      children: <Widget>[
        Home(),
        Services(),
        Center(
          child: Text('Third Page'),
        ),
        Profile()
      ],
    ));
    ;
  }
}
