import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomNavigatorPage extends StatefulWidget {
  const BottomNavigatorPage({Key? key}) : super(key: key);

  @override
  State<BottomNavigatorPage> createState() => _BottomNavigatorPageState();
}

class _BottomNavigatorPageState extends State<BottomNavigatorPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xffF2F6FC),
      ),
    );
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
        bottomNavigationBar: menu(),
      ),
    );
  }

  Widget menu() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF205867),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: const TabBar(
        indicatorColor: Colors.transparent,
        tabs: [
          Tab(
            text: "Beranda",
            icon: Icon(
              Icons.home_outlined,
              size: 25,
            ),
          ),
          Tab(
            text: "Profile",
            icon: Icon(
              Icons.person_outline,
              size: 25,
            ),
          ),
          Tab(
            text: "Bantuan",
            icon: Icon(
              Icons.question_mark_outlined,
              size: 25,
            ),
          ),
          Tab(
            text: "Menu",
            icon: Icon(
              Icons.menu,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
