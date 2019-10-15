import 'package:flutter/material.dart';
import 'package:schedular/bloc/TodoListBloc.dart';
import 'package:schedular/screens/Home.dart';
import 'package:schedular/screens/Plan.dart';
import 'package:schedular/utils/Theme.dart';
import 'package:schedular/utils/Provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  final List<Widget> _widgetList = [
    Home(key: PageStorageKey('Home')),
    Plan(key: PageStorageKey('Plan')),
    Container()
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedular',
      theme: theme(),
      home: SafeArea(
          child: Scaffold(
        body: BlocProvider<TodoListBloc>(
          builder: (_,bloc) => bloc ?? TodoListBloc(),
          child: _widgetList[this._selectedIndex],
          onDispose: (_, bloc) => bloc.dispose(),
        ),
        bottomNavigationBar: buildBottomNavBar(context),
      )),
    );
  }

  ClipRRect buildBottomNavBar(BuildContext context) {
    return ClipRRect(
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
      );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
