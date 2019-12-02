import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/bloc/TodoListBloc.dart';
import 'package:schedular/screens/Home.dart';
import 'package:schedular/screens/Plan.dart';
import 'package:schedular/utils/Theme.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:line_icons/line_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [Home(), Plan(), Container()],
    );
  }

  void _changeTab(int newIndex) {
    this.setState(() {
      this._selectedTab = newIndex;
      this._tabController.index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedular',
      theme: theme(),
      home: Scaffold(
        body: BlocProvider<PlanListBloc>(
          builder: (_, bloc) => bloc ?? PlanListBloc(),
          onDispose: (_, bloc) => bloc.dispose(),
          child: BlocProvider<TodoListBloc>(
            builder: (_, bloc) => bloc ?? TodoListBloc(),
            child: _buildTabContent(),
            onDispose: (_, bloc) => bloc.dispose(),
          ),
        ),
        bottomNavigationBar:
            buildBottomNavBar(context, this._selectedTab, this._changeTab),
      ),
    );
  }

  ClipRRect buildBottomNavBar(
      BuildContext context, int selectedTab, Function changeTab) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(40),
        topLeft: Radius.circular(40),
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Card(
        elevation: 0.0,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(LineIcons.home),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(LineIcons.pencil),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(LineIcons.line_chart),
              title: Text(''),
            ),
          ],
          unselectedItemColor: Colors.grey,
          selectedItemColor: Theme.of(context).primaryColor,
          currentIndex: selectedTab,
          showUnselectedLabels: true,
          onTap: changeTab,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
