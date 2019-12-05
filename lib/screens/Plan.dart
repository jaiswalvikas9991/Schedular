import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/widgets/PlanCard.dart';
import 'package:schedular/utils/Provider.dart';

class Plan extends StatefulWidget {
  final String date;
  Plan(this.date, {Key key}) : super(key: key);

  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  PageController _pageController = new PageController(viewportFraction: 0.8);
  int _currentPage = 0; // This variable keeps track of which page is in the current view
  
  final imageUrls = <String>["https://images.pexels.com/photos/259698/pexels-photo-259698.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
  "https://images.pexels.com/photos/70365/forest-sunbeams-trees-sunlight-70365.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
  "https://images.pexels.com/photos/358238/pexels-photo-358238.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  "https://images.pexels.com/photos/807598/pexels-photo-807598.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
  "https://images.pexels.com/photos/673857/pexels-photo-673857.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  "https://images.pexels.com/photos/392586/pexels-photo-392586.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  "https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  "https://images.pexels.com/photos/459301/pexels-photo-459301.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
  ];

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


  Widget _renderPage(bool active, PlanBloc planData, int currentIndex){
    return PlanCard(planData,active, this.imageUrls[currentIndex % this.imageUrls.length]);
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
              IconButton(icon : Icon(Icons.add , size: 40,) , color: Theme.of(context).primaryColor,
                onPressed: (){
                  _planListBloc.addPlan(widget.date);
                },
              )
            ],
          ),
          Text("Good evening", style: TextStyle(color: Color(0xff48c6ef) , fontFamily: 'Schyler', fontWeight: FontWeight.bold, fontSize: 25)),
          Text("Let's plan", style: TextStyle(color: Colors.black , fontFamily: 'Schyler', fontWeight: FontWeight.bold, fontSize: 25)),
          Expanded(
            child: StreamBuilder<List<PlanBloc>>(
              stream: _planListBloc.allPlanObservable,
              builder: (context, AsyncSnapshot<List<PlanBloc>> snapshot) {
                return snapshot.hasData ?  PageView.builder(
                  controller: this._pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int currentIndex){
                    bool active = this._currentPage == currentIndex;
                    return this._renderPage(active , snapshot.data[currentIndex], currentIndex);
                  },
                ) : Container();
              }
            ),
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
