import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/widgets/DayTray.dart';
import 'package:schedular/widgets/PlanCard.dart';

class Plan extends StatefulWidget {
  Plan({Key key}) : super(key: key);

  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  PlanListBloc _planListBloc = new PlanListBloc();
  PageController _pageController = new PageController(viewportFraction: 0.8);
  int _currentPage = 0; // This variable keeps track of which page is in the current view

  @override
  void initState() {
    super.initState();
    this._pageController.addListener((){
      int next = this._pageController.page.round();

      if(this._currentPage != next){
        this.setState((){
          this._currentPage = next;
        });
      }
    });
  }

  Widget _renderPage(bool active){
    return PlanCard(active);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          DayTray(),
          Expanded(
            child: PageView.builder(
              controller: this._pageController,
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, int currentIndex){
                bool active = this._currentPage == currentIndex;
                return this._renderPage(active);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _planListBloc.dispose();
    _pageController.dispose();
  }
}
