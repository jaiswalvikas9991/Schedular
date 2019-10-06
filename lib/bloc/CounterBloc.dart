import 'package:rxdart/rxdart.dart';

class CounterBloc {

  int initialCount = 0; //if the data is not passed by paramether it initializes with 0
  BehaviorSubject<int> _subjectCounter; // This create the pipe

  CounterBloc({this.initialCount}){
   _subjectCounter = new BehaviorSubject<int>.seeded(this.initialCount); //initializes the subject with element already
  }

  Observable<int> get counterObservable => _subjectCounter.stream;//This is the end of the pipe

  void increment(){
    initialCount++;
    _subjectCounter.sink.add(initialCount);//This is the start of the pipe
  }

  void decrement(){
    initialCount--;
    _subjectCounter.sink.add(initialCount);
  }

  void dispose(){
    _subjectCounter.close();
  }
  
}