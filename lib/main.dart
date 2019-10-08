import 'package:flutter/material.dart';
import 'package:schedular/screens/Home.dart';
import 'package:schedular/screens/Plan.dart';
import 'package:schedular/utils/Theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<Widget> _widgetList = [Home(), Plan(), Container()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedular',
      theme: theme(),
      home: SafeArea(
          child: Scaffold(
            body: _widgetList[this._selectedIndex],
            bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text('Plan'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart),
                title: Text('Dashboard'),
              ),
            ],
            unselectedItemColor: Colors.grey,
            selectedItemColor: Theme.of(context).primaryColor,
            currentIndex: _selectedIndex,
            showUnselectedLabels: true,
            onTap: (int selectedIndex) {
              setState(() {
                this._selectedIndex = selectedIndex;
              });
            },
          ),
        ),
            )
            ),
    );
  }
}
