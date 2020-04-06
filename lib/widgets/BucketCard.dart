import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class BucketCard extends StatelessWidget {
  final String bucket;
  final Function delete;
  final int index;
  const BucketCard({Key key, @required this.delete, @required this.bucket, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(bucket, style: Theme.of(context).textTheme.headline.copyWith(color: Colors.black)),
          Spacer(),
          IconButton(
              icon: Icon(LineIcons.minus),
              onPressed: (){
                this.delete(this.bucket);
                AnimatedList.of(context).removeItem(this.index, (BuildContext context, animation){
                  return(Container());
                });
              },
              color: Colors.black)
        ],
      ),
    );
  }
}
