import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddBucket extends StatelessWidget {
  final TextEditingController _controller = new TextEditingController();
  AddBucket({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text("Bucket Name",
          style: Theme.of(context)
              .textTheme
              .headline
              .copyWith(color: Colors.black)),
      content: TextField(
        controller: this._controller,
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Cancel',
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: const Color(0xff48c6ef))),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        FlatButton(
            child: Text('Save',
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: const Color(0xff48c6ef))),
            onPressed: () {
              Navigator.pop(context, this._controller.text);
            })
      ],
    );
  }
}
