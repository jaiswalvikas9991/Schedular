import 'package:schedular/utils/Constants.dart';
import 'package:schedular/utils/DBProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NaiveBayes {
  static int alpha = 1;
  static int numberOfBuckets;
  NaiveBayes._();
  static void loadModel() {}

  static Future<double> probabilityWithRating(
      DateTime time, String bucket, int rating) async {
    double prior = await DBProvider.db.getPrior(rating);
    double likelyhoodBucket =
        await DBProvider.db.getBucketProbabilityFromRating(rating, bucket);
    double likelyhoodTime = await DBProvider.db
        .getTimeProbabilityFromRating(rating, time.toString().substring(0, 2));
    return (prior * likelyhoodBucket * likelyhoodTime);
  }

  static Future<Map<String, dynamic>> probability(
      DateTime time, String bucket) async {
    Map<String, dynamic> maxMap = {
      'probability': -1,
      'bucket': '',
      'rating': -1
    };
    //* We are calculating the probability for every rating
    for (int i = 1; i <= 5; i++) {
      double prob = await probabilityWithRating(time, bucket, i);
      if (prob * i > maxMap['probability'])
        maxMap = {'probability': prob * i, 'bucket': bucket, 'rating': i};
    }
    return (maxMap);
  }

  static Future<Map<String, dynamic>> predict(DateTime time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //* This is the smoothing term
    alpha = 1;
    //* This gets the list of the bucket
    final List<String> buckets = prefs.getStringList(bucketKey);
    numberOfBuckets = buckets.length;
    Map<String, dynamic> maxMap = {
      'probability': -1,
      'bucket': '',
      'rating': -1
    };
    //# We will check every bucket with every rating and then we will take the frequency weighted average to determine the final value of the probaility
    //# And we will declare that bucket as the anser which will have the higest weighted probability
    buckets.forEach((String bucket) async {
      //# Here we are calculating the probability of each rating
      Map<String, dynamic> map = await probability(time, bucket);
      if (map['probability'] > maxMap['probability']) maxMap = map;
    });
    return (maxMap);
  }

  //* This functions updates the frequency tables of bucket and time
  static void fit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String date = await prefs.get('lastTrainDate');

    //* This takes care of the very first train
    if (date == null)
      date = DateTime.now().toString();
    //* To handel already tarined
    else if (DateTime.parse(date) == DateTime.now()) return;

    List<Map<String, dynamic>> data =
        await DBProvider.db.getMlData(DateTime.parse(date));

    data.forEach((Map<String, dynamic> value) async {
      await DBProvider.db.updateBucketTable(value['rating'], value['bucket']);
      await DBProvider.db.updateTimeTable(value['rating'], value['fromTime']);
    });
    await prefs.setString('lastTrainDate', DateTime.now().toString());
  }
}
