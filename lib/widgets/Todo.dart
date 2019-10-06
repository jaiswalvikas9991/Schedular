import 'package:flutter/material.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:schedular/bloc/TodoListBloc.dart';
import 'package:schedular/widgets/CCheckBox.dart';

class Todo extends StatefulWidget {
  final String id;
  final TodoListBloc todoListBloc;
  Todo(this.id, this.todoListBloc, {Key key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final TextEditingController _textController = new TextEditingController();
  bool _isBeingEdited = false;
  TodoBloc _todoBloc = new TodoBloc();

  Widget renderButtonBar() {
    return ButtonTheme.bar(
      // make buttons use the appropriate styles for cards
      child: ButtonBar(
        children: <Widget>[
          FlatButton(
            child: const Text('DELETE'),
            onPressed: () {
              widget.todoListBloc.deleteTodo(widget.id);
            },
          ),
          FlatButton(
            child: Text(this._isBeingEdited ? 'SAVE' : 'EDIT'),
            onPressed: () {
              setState(() {
                this._isBeingEdited = !this._isBeingEdited;
              });
              _todoBloc.updateContent(this._textController.text);
              widget.todoListBloc.updateTodoContent(this._textController.text, widget.id);
            },
          ),
        ],
      ),
    );
  }

  Widget renderTextField() {
    return Expanded(
      child: StreamBuilder(
          stream: _todoBloc.contentObservable,
          builder: (context, AsyncSnapshot<String> snapshot) {
            return snapshot.hasData ?  this._isBeingEdited
                ? TextField(
                    key: Key(widget.id),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Write down a quick todo...',
                    ),
                    controller: _textController,
                  )
                : Text(
                    snapshot.data == ''
                        ? 'Click on Edit to add a Todo...'
                        : snapshot.data,
                        key: Key(widget.id),
                    overflow: TextOverflow.ellipsis,
                  ) : Container();
          }),
    );
  }

  Widget renderCheckBox() {
    return StreamBuilder(
        stream: _todoBloc.isCheckedObservable,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return snapshot.hasData ? CCheckBox(
            value: snapshot.data,
              onTap: () {
                _todoBloc.updateCheckedState(!snapshot.data);
                widget.todoListBloc.updateTodoIsChecked(!snapshot.data, widget.id);
              },
            ) : Container();
          
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
              renderCheckBox(),
              renderTextField(),
            ],
          ),
          renderButtonBar(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textController.clear();
    _textController.dispose();
    _todoBloc.dispose();
  }
}
