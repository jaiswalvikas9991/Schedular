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
import 'package:shared_preferences/shared_preferences.dart';

// Flutter notification is a singleton itself.
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController _tabController;
  //* This is the date that is central to all the pages
  DateTime _centralDate = DateTime.now();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  PlanListBloc _planListBloc;
  TodoListBloc _todoListBloc;

  Color _primaryColor;
  bool _dark = false;

  _MyAppState() {
    this._primaryColor = this._dark ? Color(0xffc5cae9) : Color(0xff48c6ef);
    //* Getting the app color
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      if (prefs.getString('color') != null) {
        int color = int.parse('0xff' + prefs.getString('color'));
        this.setState(() {
          this._primaryColor = Color(color);
        });
      }

      if (prefs.getBool('dark') != null) {
        this.setState(() {
          this._dark = prefs.getBool('dark');
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    //* Initializing the bloc
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

  void _changeMode(bool state) {
    this.setState(() {
      this._dark = state;
    });
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setBool('dark', this._dark);
    });
  }

  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  void _changePrimaryColor(Color color) {
    if (this._primaryColor != color) {
      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        prefs.setString('color', color.toString().substring(10, 16));
      });
      this.setState(() {
        this._primaryColor = color;
      });
    }
  }

  bool changeCentralDate(DateTime date) {
    // print('chage fired with ' + date.toIso8601String());
    if (this._centralDate != date) {
      this.setState(() {
        this._centralDate = date;
      });
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
        Setting(
            changeMode: this._changeMode,
            dark: this._dark,
            changePrimaryColor: this._changePrimaryColor,
            currrentPrimaryColor: this._primaryColor)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedular',
      theme: theme(primaryColor: this._primaryColor, dark: this._dark),
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
          labelColor: this._primaryColor,
          unselectedLabelColor: Colors.black,
          tabs: <Widget>[
            Tab(icon: Icon(LineIcons.home)),
            Tab(icon: Icon(LineIcons.pencil)),
            Tab(icon: Icon(LineIcons.line_chart)),
            Tab(icon: Icon(LineIcons.cog)),
          ],
          controller: _tabController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    DBProvider.db.dispose();
    super.dispose();
  }
}
