import 'package:flutter/material.dart';

class Edit extends StatefulWidget {
  Edit({Key key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                _renderImage(context),
                Text("30 th Novemeber", style: Theme.of(context).textTheme.body2,),
                Text("Time to and from", style: Theme.of(context).textTheme.body2,),

                Row(
                  children: <Widget>[
                    Text(
                      "Description of the Task",
                      style: Theme.of(context).textTheme.body2,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.notifications,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.alarm,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Rating", style: Theme.of(context).textTheme.body2),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            _renderBack(),
          ],
        ),
      ),
    );
  }

  Container _renderImage(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        transform: Matrix4.translationValues(
            MediaQuery.of(context).size.width * -0.2,
            MediaQuery.of(context).size.height * -0.1,
            0),
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://images.pexels.com/photos/259698/pexels-photo-259698.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260")),
          borderRadius: BorderRadius.all(
              Radius.circular(MediaQuery.of(context).size.width)),
          color: Colors.redAccent,
        ));
  }

  Positioned _renderBack() {
    return Positioned(
      top: 0,
      left: 0,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: CircleAvatar(
              backgroundColor: Colors.white, child: Icon(Icons.arrow_back_ios)),
        ),
      ),
    );
  }
}
