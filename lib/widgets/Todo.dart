import 'package:flutter/material.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:schedular/bloc/TodoListBloc.dart';
import 'package:schedular/utils/ColorText.dart';
import 'package:schedular/utils/FromStream.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:schedular/widgets/CCheckBox.dart';

class Todo extends StatefulWidget {
  final TodoBloc todoBloc;
  Todo(this.todoBloc, {Key key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  TextEditingController _textController;
  bool _isBeingEdited = false;

  _TodoState() {
    this._textController = new TextEditingController();
  }

  Widget renderButtonBar(BuildContext context) {
    final TodoListBloc _todoListBloc = Provider.of<TodoListBloc>(context);
    return ButtonBarTheme(
      // make buttons use the appropriate styles for cards
      data: ButtonBarThemeData(),
      child: ButtonBar(
        children: <Widget>[
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: const Text('DELETE'),
            onPressed: () {
              _todoListBloc.deleteTodo(widget.todoBloc.id);
            },
          ),
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(this._isBeingEdited ? 'SAVE' : 'EDIT'),
            onPressed: () {
              if (this._isBeingEdited == true &&
                  this._textController.text != '') {
                widget.todoBloc.updateContent(this._textController.text);
              }
              setState(() {
                this._isBeingEdited = !this._isBeingEdited;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget renderTextField() {
    return Expanded(
      child: FromStream<String>(
          stream: widget.todoBloc.contentObservable,
          initialData: "Click on Edit",
          child: (String data) {
            this._textController.text = data;
            return (this._isBeingEdited
                ? TextField(
                    style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1.fontFamily),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Write down a quick todo...',
                    ),
                    controller: _textController,
                  )
                : colorText(
                  context,
                    text : data == '' ? 'Click on edit...' : data,
                    style : Theme.of(context).textTheme.bodyText2,
                  ));
          }),
    );
  }

  Widget renderCheckBox() {
    return FromStream<bool>(
        stream: widget.todoBloc.isCheckedObservable,
        initialData: false,
        child: (bool data) {
          return CCheckBox(
            value: data,
            onTap: () {
              widget.todoBloc.updateCheckedState(!data);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              this.renderCheckBox(),
              this.renderTextField(),
            ],
          ),
          this.renderButtonBar(context),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.clear();
    _textController.dispose();
    super.dispose();
  }
}
