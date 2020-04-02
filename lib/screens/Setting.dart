import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schedular/widgets/AddBucket.dart';
import 'package:schedular/widgets/BucketCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final bucketKey = "key";
  @override
  void initState() {
    super.initState();
    this._getBucketList().then((onValue) {
      this._bucketList = onValue;
      this.setState(() {});
    });
  }

  List<Widget> _bucketList = new List<Widget>();

  Future<List<String>> _getBuckets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> value = prefs.getStringList(bucketKey) ?? [];
    return (value);
  }

  Future<void> _deleteBucket(String bucket) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> buckets = await this._getBuckets();
    if (!buckets.contains(bucket)) return;
    buckets.removeAt(buckets.indexOf(bucket));
    await prefs.setStringList(bucketKey, buckets);
    this._getBucketList().then((onValue) {
      this._bucketList = onValue;
      this.setState(() {});
    });
  }

  Future<void> _addBucket(String bucket) async {
    //* Getting the instance of shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> buckets = await this._getBuckets();
    if (buckets.contains(bucket)) return;
    buckets.add(bucket);
    await prefs.setStringList(bucketKey, buckets);
  }

  Future<List<Widget>> _getBucketList() async {
    List<String> buckets = await this._getBuckets();
    List<Widget> bucketWidgets = new List<Widget>();
    buckets.forEach((String bucket) {
      bucketWidgets.add(BucketCard(delete: this._deleteBucket, bucket: bucket));
    });
    return (bucketWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Buckets",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Schyler',
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                key: UniqueKey(),
              ),
              IconButton(
                onPressed: () async {
                  String text = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return (AddBucket());
                      });
                  await this._addBucket(text);
                  List<Widget> list = await this._getBucketList();
                  this.setState(() {
                    this._bucketList = list;
                  });
                },
                icon: Icon(LineIcons.plus),
                color: Colors.black,
              )
            ],
          ),
          Expanded(
            child: ListView(
              children: this._bucketList,
            ),
          )
        ],
      )),
    );
  }
}
