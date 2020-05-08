import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/utils/FromStream.dart';
import 'package:schedular/widgets/PlaceHolder.dart';
import 'package:schedular/widgets/PlanCard.dart';
import 'package:schedular/utils/Provider.dart';

typedef ChangeDate = bool Function(DateTime date);
class Plan extends StatefulWidget {
  final DateTime date;
  Plan(this.date, {Key key}) : super(key: key);

  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  PageController _pageController = new PageController(viewportFraction: 0.8);
  //* This variable keeps track of which page is in the current view
  int _currentPage = 0;

  final imageUrls = <String>[
    "images/0.jpeg",
    "images/1.jpeg",
    "images/2.jpeg",
    "images/3.jpeg",
    "images/4.jpeg",
    "images/5.jpeg",
    "images/6.jpeg",
    "images/7.jpeg",
  ];

  @override
  void initState() {
    super.initState();
    this._pageController.addListener(() {
      int next = this._pageController.page.round();
      if (this._currentPage != next) {
        this.setState(() {
          this._currentPage = next;
        });
      }
    });
  }

  Widget _renderPage(bool active, PlanBloc planData, int currentIndex) {
    return PlanCard(
        planData,
        active,
        this.imageUrls[planData.id.hashCode % this.imageUrls.length],
        widget.date);
  }

  String _greeting() {
    var hour = DateTime.now().hour;
    if (hour >= 3 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    if (hour >= 17 && hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  @override
  Widget build(BuildContext context) {
    final PlanListBloc _planListBloc = Provider.of<PlanListBloc>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 40,
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  _planListBloc.addPlan(widget.date);
                },
                tooltip: "Add new Plan",
              )
            ],
          ),
          Text(this._greeting(),
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Theme.of(context).primaryColor)),
          Text("Let's plan",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Schyler',
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          Expanded(
            child: FromStream<List<PlanBloc>>(
                stream: _planListBloc.allPlanObservable,
                condition: (List<PlanBloc> data) => data.length != 0,
                placeholder: PlaceHolder(
                    fontSize: 20.0,
                    data: "Click on the + icon to \n add a plan"),
                child: (List<PlanBloc> data) {
                  return PageView.builder(
                    controller: this._pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, int currentIndex) {
                      bool active = this._currentPage == currentIndex;
                      return this._renderPage(
                          active, data[currentIndex], currentIndex);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
