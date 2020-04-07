import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/bloc/TodoListBloc.dart';
import 'package:schedular/screens/Home.dart';
import 'package:schedular/screens/Plan.dart';
import 'package:schedular/screens/Setting.dart';
import 'package:schedular/utils/DBProvider.dart';
import 'package:schedular/utils/Theme.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schedular/screens/Statistics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Flutter notification is a singleton itself.
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String _centralDate =
      DateTime.now().toString().substring(0, 11).replaceAll(' ', '');
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  PlanListBloc _planListBloc;
  TodoListBloc _todoListBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    //* Initializing the block
    this._todoListBloc = new TodoListBloc();
    this._planListBloc = new PlanListBloc();
    // initializing the flutter notification plugin
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android, ios);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  bool changeCentralDate(String date) {
    if (this._centralDate != date) {
      this._centralDate = date;
      return (true);
    }
    return (false);
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Home(this.changeCentralDate),
        Plan(this._centralDate),
        Statistics(),
        Setting()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedular',
      theme: theme(),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: BlocProvider<PlanListBloc>(
            builder: (_, bloc) => bloc ?? this._planListBloc,
            onDispose: (_, bloc) => bloc.dispose(),
            child: BlocProvider<TodoListBloc>(
              builder: (_, bloc) => bloc ?? this._todoListBloc,
              child: _buildTabContent(),
              onDispose: (_, bloc) => bloc.dispose(),
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(context),
        ),
      ),
    );
  }

  ClipRRect _buildBottomNavBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(40),
        topLeft: Radius.circular(40),
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Card(
        child: TabBar(
          isScrollable: false,
          indicatorColor: Colors.transparent,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.black,
          tabs: <Widget>[
            Tab(
              icon: Icon(LineIcons.home),
            ),
            Tab(
              icon: Icon(LineIcons.pencil),
            ),
            Tab(
              icon: Icon(LineIcons.line_chart),
            ),
            Tab(
              icon: Icon(LineIcons.cog),
            ),
          ],
          controller: _tabController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    DBProvider.db.dispose();
  }
}
