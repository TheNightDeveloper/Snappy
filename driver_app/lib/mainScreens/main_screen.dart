import 'package:driver_app/constant/constasnt.dart';
import 'package:driver_app/tabPages/earning_tab.dart';
import 'package:driver_app/tabPages/home_tab.dart';
import 'package:driver_app/tabPages/profile_tab.dart';
import 'package:driver_app/tabPages/rating_tab.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeTabPage(),
              EarningTabPage(),
              RatingTabPage(),
              ProfileTabPage()
            ]),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              // backgroundColor: Color.fromARGB(255, 7, 2, 111),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.credit_card), label: 'Earning'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Rating'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
          unselectedItemColor: Colors.blueGrey,
          selectedItemColor: Colors.white,
          backgroundColor: kmainColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: onItemClicked,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ));
  }
}
