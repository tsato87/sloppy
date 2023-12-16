import 'package:flutter/material.dart';

import 'app/routing_manager/page_switcher.dart';
import 'const/colors.dart';


// This widget is the root of app.
class Sloppy extends StatelessWidget {
  const Sloppy({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sloppy',
      theme: ThemeData(
        primaryColor: SloppyColors.sloppyTheme,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const PageSwitcher(),
    );
  }
}
