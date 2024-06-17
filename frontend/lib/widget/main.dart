import 'dart:convert';

import 'package:flutter/material.dart';

import 'search.dart';
import 'home.dart';
import 'my_jobs.dart';
import 'profile.dart';
import 'my_company.dart';
import '../user_info.dart';
import 'request.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() {
    return MainWidgetState();
  }
}

class MainWidgetState extends State<MainWidget> {
  int _selectedIndex = 0;
  late bool _isCandidate;

  @override
  void initState() {
    super.initState();
    if (UserInfo.instance.user == '') {
      _isCandidate = true;
    } else {
      _isCandidate = jsonDecode(UserInfo.instance.user)['role'] == 'Candidate';
    }
  }

  List<String> _getWidgetTitle() {
    if (_isCandidate) {
      return [ 'Home', 'My Jobs', 'Profile' ];
    } else {
      return [ 'My Company', 'Request', 'Profile' ];
    }
  }

  List<Widget> _getWidgetOptions() {
    if (_isCandidate) {
      return <Widget>[
        const Home(),
        const MyJobs(),
        const Profile(),
      ];
    } else {
      return <Widget>[
        const MyCompany(),
        const Request(),
        const Profile(),
      ];
    }
  }

  List<BottomNavigationBarItem> _getBottomBarItems() {
    if (_isCandidate) {
      return <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'My Jobs',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ].toList();
    } else {
      return <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'My Company',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.call_received_outlined),
          label: 'Request',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ].toList();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getWidgetTitle()[_selectedIndex]),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchWidget()
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
        body: _getWidgetOptions().elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: _getBottomBarItems(),
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
