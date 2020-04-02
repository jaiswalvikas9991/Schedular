import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class BucketCard extends StatelessWidget {
  final String bucket;
  final Function delete;
  const BucketCard({Key key, this.delete, this.bucket}) : super(key: key);

  void _onDelete() {
    this.delete(this.bucket);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(bucket, style: Theme.of(context).textTheme.body2),
          Spacer(),
          IconButton(
              icon: Icon(LineIcons.minus),
              onPressed: this._onDelete,
              color: Colors.black)
        ],
      ),
    );
  }
}
