import 'package:rxdart/rxdart.dart';
import 'package:schedular/utils/DBProvider.dart';

class TodoBloc {
  // Real Data
  String id;
  bool _isChecked = false;
  String _content = '';

  // Behaviour Subjects
  BehaviorSubject<bool> _subjectIsChecked;
  BehaviorSubject<String> _subjectContent;

  TodoBloc(this.id , {String content, bool isChecked}){
    this._isChecked = isChecked ?? false;
    this._content = content ?? "";
    _subjectIsChecked = new BehaviorSubject<bool>.seeded(this._isChecked);
    _subjectContent = new BehaviorSubject<String>.seeded(this._content == '' ? "Click on Edit" : this._content);
  }

  // This constructor is used when the data is fetched from the database
  factory TodoBloc.fromMap(Map<String, dynamic> todoBloc){
    return TodoBloc(
      todoBloc["id"],
      content: todoBloc["content"],
      isChecked: todoBloc["isChecked"] == 1
    );
  }


  // Streams
  Observable<bool> get isCheckedObservable => _subjectIsChecked.stream;
  Observable<String> get contentObservable => _subjectContent.stream;

  void updateCheckedState(bool isChecked) {
    this._isChecked = isChecked;
    _subjectIsChecked.sink.add(this._isChecked);
    DBProvider.db.updateTodo(this.toMap());
  }

  void updateContent(String content) {
    if (this._content != content) {
      this._content = content;
      _subjectContent.sink.add(this._content);
      DBProvider.db.updateTodo(this.toMap());
    }
  }

  void dispose() {
    _subjectIsChecked.close();
    _subjectContent.close();
  }

  // This function is used to write data to the database
  Map<String, dynamic> toMap() => {
    "id" : this.id,
    "content" : this._content,
    "isChecked" : this._isChecked ? 1 : 0, //Converts bool to a bit because sqllite does not support bool directly
  };
}
