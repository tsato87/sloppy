import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/colors.dart';
import '../app_bar/sloppy_app_bar.dart';
import '../map/map_page.dart';
import '../notes/notes_page.dart';
import '../notification/notification_page.dart';


final selectedIndexProvider = StateProvider.autoDispose((ref) => 0);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  int selectedIndex = 0;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SloppyAppBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          NotesPage(),
          MapPage(),
          NotificationsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_sharp),
            label: 'メモ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room),
            label: '地図',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '通知',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            if (pageController.hasClients) {
              pageController.jumpToPage(index);
            }
          });
        },
      ),
    );
  }
}
