import 'package:rxdart/rxdart.dart';

class TodoBloc {
  bool _isChecked = false;
  String _content = "Add some todo...";

  // Behaviour Subjects
  BehaviorSubject<bool> _subjectIsChecked;
  BehaviorSubject<String> _subjectContent;

  TodoBloc() {
    _subjectIsChecked = new BehaviorSubject<bool>.seeded(false);
    _subjectContent = new BehaviorSubject<String>.seeded("Add some todo...");
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
