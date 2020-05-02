import 'package:flutter/material.dart';

typedef bool Condition<T>(T data);
typedef Widget Child<T>(T data);
typedef void Error(error);

class FromStream<T> extends StatelessWidget {
  final Child<T> child;
  final Widget placeholder;
  final Condition<T> condition;
  final T initialData;
  final Stream<T> stream;
  final Error onError;
  FromStream(
      {this.child,
      this.placeholder,
      this.condition,
      @required this.stream,
      this.onError,
      this.initialData});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: this.stream,
      initialData: this.initialData,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError && this.onError != null)
          this.onError(snapshot.error);
        if (snapshot.hasData && (this.condition == null ? true : this.condition(snapshot.data)))
          return (this.child == null ? Container() : this.child(snapshot.data));
        return (this.placeholder ?? Container());
      },
    );
  }
}
