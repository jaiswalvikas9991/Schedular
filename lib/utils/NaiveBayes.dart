import 'dart:collection';
import 'package:schedular/utils/DBProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
abstract class NaiveBayes {
  NaiveBayes._();
  static void loadModel() {}
  static void predict() {
    HashMap<String, List<int>> time = new HashMap<String, List<int>>();
  }
  static void fit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String date = prefs.get('lastTrainDate');
  }
}