import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schedular/widgets/AddBucket.dart';
import 'package:schedular/widgets/BucketCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedular/utils/Animate.dart';
import 'package:schedular/utils/DBProvider.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  List<String> _bucketList = new List<String>();
  final bucketKey = "keys";

  @override
  void initState() {
    super.initState();
    this._getBuckets().then((onValue) {
      this._bucketList = onValue;
      this.setState(() {});
    });
  }

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
    this._getBuckets().then((onValue) {
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

  Future<void> _showDialog(BuildContext context) async {
    String text = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return (AddBucket());
        });
    if (text == null || text.isEmpty) return;
    await this._addBucket(text);
    List<String> list = await this._getBuckets();
    this.setState(() {
      this._bucketList = list;
    });
  }

  void _copyDb() async {
    //* Source file
    String sourcePath = await DBProvider.db.copyDb();
    //debugPrint("Data copied form : " + sourcePath);
    File sourceFile = File(sourcePath);
    List content = await sourceFile.readAsBytes();

    //* target file
    final targetDir = await getExternalStorageDirectory();
    final targetPath = join(targetDir.path,
        DateFormat("dd-MM-yyyy").format(DateTime.now()) + '.db');
    //debugPrint("Data Copied to : " + targetPath);
    File targetFile = File(targetPath);
    await targetFile.writeAsBytes(content, flush: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Upload Data",
                  style: Theme.of(context).textTheme.headline.copyWith(
                      color: Color(0xff48c6ef), fontWeight: FontWeight.bold),
                  key: UniqueKey(),
                ),
                IconButton(
                  onPressed: this._copyDb,
                  icon: Icon(LineIcons.upload),
                  color: Colors.black,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Task Name",
                  style: Theme.of(context).textTheme.headline.copyWith(
                      color: Color(0xff48c6ef), fontWeight: FontWeight.bold),
                  key: UniqueKey(),
                ),
                IconButton(
                  onPressed: () {
                    this._showDialog(context);
                  },
                  icon: Icon(LineIcons.plus),
                  color: Colors.black,
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: this._bucketList.length,
                  itemBuilder: (BuildContext context, int index) => Animator(
                        duration: 500,
                        child: BucketCard(
                            bucket: this._bucketList[index],
                            delete: this._deleteBucket,
                            index: index),
                      )),
            ),
          ],
        ),
      )),
    );
  }
}
