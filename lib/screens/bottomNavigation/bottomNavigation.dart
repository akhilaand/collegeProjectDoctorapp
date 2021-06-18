import 'package:college_project_doctor/constants/colors.dart';
import 'package:college_project_doctor/screens/chatScreen/mainScreen.dart';
import 'package:college_project_doctor/screens/homeScreen/homeScreen.dart';
import 'package:flutter/material.dart';

class Bottom_Navigation extends StatefulWidget {
  @override
  _Bottom_NavigationState createState() => _Bottom_NavigationState();
}

class _Bottom_NavigationState extends State<Bottom_Navigation>
    with SingleTickerProviderStateMixin {
  int _current_Index = 0;
  TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: TabBar(
          controller: controller,
          indicatorColor: Colors.transparent,
          labelColor: blue,
          unselectedLabelColor: Colors.black26,
          tabs: [
            Tab(
                icon: Icon(
              Icons.home,
            )),
            Tab(icon: Icon(Icons.chat)),

          ],
        ),
      ),
      body: TabBarView(controller: controller, children: [
        HomeScreen(),
        ChatMainScreen(),

      ]),
    );
  }
}
