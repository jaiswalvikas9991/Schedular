import 'package:rxdart/rxdart.dart';

class TodoBloc {
  String id;
  bool _isChecked;
  String _content;

  // Behaviour Subjects
  BehaviorSubject<bool> _subjectIsChecked;
  BehaviorSubject<String> _subjectContent;

  TodoBloc(id , {isChecked, String content}) {
    this.id = id;
    this._content = content ?? "Add some todo..." ;
    this._isChecked = isChecked ?? false;
    _subjectIsChecked = new BehaviorSubject<bool>();
    _subjectContent = new BehaviorSubject<String>();
  }

  // Streams
  Observable<bool> get isCheckedObservable => _subjectIsChecked.stream;
  Observable<String> get contentObservable => _subjectContent.stream;

  void updateCheckedState(bool isChecked) {
    this._isChecked = isChecked;
    _subjectIsChecked.sink.add(this._isChecked);
  }

  void updateContent(String content) {
    if (this._content != content) {
      this._content = content;
      _subjectContent.sink.add(this._content);
    }
  }

  void dispose() {
    _subjectIsChecked.close();
    _subjectContent.close();
  }
}
