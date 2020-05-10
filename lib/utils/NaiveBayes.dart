import 'dart:math';

import 'package:intl/intl.dart';
import 'package:schedular/utils/Constants.dart';
import 'package:schedular/utils/DBProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//* This is non inheritable non instantiable class (aka. Singleton)
abstract class NaiveBayes {
  static int alpha = 1;
  static int numberOfBuckets;
  static List<Map<String, dynamic>> list = List<Map<String, dynamic>>();
  NaiveBayes._();

  // static Future<double> probabilityWithRating(
  //     DateTime time, String bucket, int rating) async {
  //   double prior = await DBProvider.db.getPrior(rating);
  //   double likelyhoodBucket =
  //       await DBProvider.db.getBucketProbabilityFromRating(rating, bucket);
  //   double likelyhoodTime = await DBProvider.db.getTimeProbabilityFromRating(
  //       rating, time.toString().split(' ')[1].substring(0, 2));
  //   return (prior * likelyhoodBucket * likelyhoodTime);
  // }

  // static Future<Map<String, dynamic>> probability(
  //     DateTime time, String bucket) async {
  //   Map<String, dynamic> maxMap = {
  //     'probability': -1,
  //     'bucket': '',
  //     'rating': -1
  //   };
  //   //* We are calculating the probability for every rating
  //   for (int i = 1; i <= 5; i++) {
  //     double prob = await probabilityWithRating(time, bucket, i);
  //     if (prob * i > maxMap['probability'])
  //       maxMap = {'probability': prob * i, 'bucket': bucket, 'rating': i};
  //   }
  //   return (maxMap);
  // }

  // static Future<Map<String, dynamic>> predict(DateTime time) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //* This gets the list of the bucket
  //   final List<String> buckets = prefs.getStringList(bucketKey);
  //   numberOfBuckets = buckets.length;
  //   Map<String, dynamic> maxMap = {
  //     'probability': -1,
  //     'bucket': '',
  //     'rating': -1
  //   };
  //   //# We will check every bucket with every rating and then we will take the frequency weighted average to determine the final value of the probaility
  //   //# And we will declare that bucket as the anser which will have the higest weighted probability
  //   for (int i = 0; i < buckets.length; i++) {
  //     //# Here we are calculating the probability of each rating
  //     Map<String, dynamic> map = await probability(time, buckets[i]);
  //     if (map['probability'] > maxMap['probability']) maxMap = map;
  //   }
  //   maxMap['time'] = time;
  //   return (maxMap);
  // }

  //* This functions updates the frequency tables of bucket and time
  // static void fit() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String date = await prefs.get(dateKey);

  //   print("This is the fetched data :");
  //   await DBProvider.db.checkData('ratingTime');

  //   print(date);
  //   //* This takes care of the very first train
  //   if (date == null)
  //     date = DateTime.now().toString();
  //   //* To handel already tarined
  //   else if (DateFormat('yyyy-MM-dd').format(DateTime.parse(date)) ==
  //       DateFormat('yyyy-MM-dd').format(DateTime.now())) return;

  //   List<Map<String, dynamic>> data =
  //       await DBProvider.db.getMlData(DateTime.parse(date));

  //   print('This is the data from the ML table' + data.toString());

  //   //print("This is the featched data : \n" + data.toString());

  //   data.forEach((Map<String, dynamic> value) async {
  //     await DBProvider.db.updateBucketTable(value['rating'], value['bucket']);
  //     await DBProvider.db.updateTimeTable(value['rating'], value['fromTime']);
  //   });
  //   await prefs.setString(dateKey, DateTime.now().toString());
  // }

  static Future<double> probabilityWithRating(
      DateTime dateTime, String bucket, int rating) async {
    String time = dateTime.toString().split(' ')[1].substring(0, 2);
    double prior = await DBProvider.db.getTimeProb(time);
    double likelyhoodBucket =
        await DBProvider.db.getBucketTimeProb(bucket, time);
    double likelyhoodRating =
        await DBProvider.db.getRatingTimeProb(rating, time);
    //* Here we are calculating log likelyhoods to avoid the numerical underflow
    return (prior + likelyhoodBucket + likelyhoodRating);
  }

  static Future<double> probability(DateTime dateTime, String bucket) async {
    //* We are calculating the probability for every rating
    double rating1 = await probabilityWithRating(dateTime, bucket, 1);
    double rating2 = await probabilityWithRating(dateTime, bucket, 2);
    double rating3 = await probabilityWithRating(dateTime, bucket, 3);
    double rating4 = await probabilityWithRating(dateTime, bucket, 4);
    double rating5 = await probabilityWithRating(dateTime, bucket, 5);
    //print('$rating1 $rating2 $rating3 $rating4 $rating5');
    double finalProbability = rating1 * -3.0 +
        rating2 * -2.0 +
        rating3 * 1.0 +
        rating4 * 2.0 +
        rating5 * 3.0;
    //print('The prob for the bucket $bucket is $finalProbability');
    return (finalProbability);
  }

  static Future<Map<String, dynamic>> predict(DateTime time) async {
    list.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //* This gets the list of the bucket
    final List<String> buckets = prefs.getStringList(bucketKey);
    //* This is if no bucket is added
    if(buckets == null || buckets.length == 0) return(null);
    if(await prefs.get(dateKey) == null) return(null);
    numberOfBuckets = buckets.length;
    Map<String, dynamic> maxMap = {
      'bucket': '',
      'probability': double.negativeInfinity,
      'time': time.toString()
    };
    //# We will check every bucket with every rating and then we will take the frequency weighted average to determine the final value of the probaility
    //# And we will declare that bucket as the anser which will have the higest weighted probability
    for (int i = 0; i < buckets.length; i++) {
      //# Here we are calculating the probability of each rating
      double prob = await probability(time, buckets[i]);
      //* This is the list which keep track of probabilities of all the buckets
      list.add({'bucket': buckets[i], 'probability': prob});
      if (prob < maxMap['probability']) continue;
      maxMap['probability'] = prob;
      maxMap['bucket'] = buckets[i];
    }
    List<Map<String, dynamic>> temp = new List<Map<String, dynamic>>();
    for (int i = 0; i < list.length; i++)
      if (list[i]['probability'] == maxMap['probability']) temp.add(list[i]);
      print(temp);
    if (temp.length == 1) return (temp[0]);
    return (temp[Random().nextInt(temp.length)]);
  }

  static Future<bool> fit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String date = await prefs.get(dateKey);

    //print("This is the fetched data :");
    //await DBProvider.db.checkData('ratingTime');

    //print(date);
    //* This takes care of the very first train
    if (date == null)
      date = DateTime.now().toString();
    //* To handel already tarined
    else if (DateFormat('yyyy-MM-dd').format(DateTime.parse(date)) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now())) return(false);

    List<Map<String, dynamic>> data =
        await DBProvider.db.getMlData(DateTime.parse(date));

    if(data == null || data.isEmpty) return(false);

    //print('This is the data from the ML table' + data.toString());

    for (int i = 0; i < data.length; i++) {
      await DBProvider.db
          .updateRatingTime(data[i]['rating'], data[i]['fromTime']);
      await DBProvider.db
          .updateBucketTime(data[i]['bucket'], data[i]['fromTime']);
    }

    await prefs.setString(dateKey, DateTime.now().toString());
    //print('New date updated');
    return(true);
  }
}
