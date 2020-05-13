import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schedular/widgets/AddBucket.dart';
import 'package:schedular/widgets/BucketCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedular/utils/Animate.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:schedular/utils/Constants.dart';

class Setting extends StatefulWidget {
  final Function changePrimaryColor;
  final Color currrentPrimaryColor;
  final Function changeMode;
  bool dark = false;
  Setting(
      {Key key,
      this.changePrimaryColor,
      @required this.currrentPrimaryColor,
      this.changeMode,
      this.dark})
      : super(key: key);
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  List<String> _bucketList = new List<String>();

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

  // void _copyDb() async {
  //   //* Source file
  //   String sourcePath = await DBProvider.db.copyDb();
  //   //debugPrint("Data copied form : " + sourcePath);
  //   File sourceFile = File(sourcePath);
  //   List content = await sourceFile.readAsBytes();

  //   //* target file
  //   final targetDir = await getExternalStorageDirectory();
  //   final targetPath = join(targetDir.path,
  //       DateFormat("dd-MM-yyyy").format(DateTime.now()) + '.db');
  //   //debugPrint("Data Copied to : " + targetPath);
  //   File targetFile = File(targetPath);
  //   await targetFile.writeAsBytes(content, flush: true);
  // }

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
                  "Dark Mode",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Theme.of(context).primaryColor),
                  key: UniqueKey(),
                ),
                Switch(value: widget.dark, onChanged: widget.changeMode, activeColor: Theme.of(context).primaryColor)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Change Color",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Theme.of(context).primaryColor),
                    key: UniqueKey()),
                IconButton(
                  icon: Icon(LineIcons.paint_brush),
                  color: Colors.black,
                  tooltip: "Change App Color",
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        title: const Text('Pick a color'),
                        content: Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          child: SingleChildScrollView(
                            child: MaterialPicker(
                              pickerColor: widget.currrentPrimaryColor,
                              onColorChanged: widget.changePrimaryColor,
                              //showLabel: true,
                              //pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Done',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: Theme.of(context).primaryColor)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Default',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: Theme.of(context).primaryColor)),
                            onPressed: () {
                              widget.changePrimaryColor(Color(0xff48c6ef));
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Text(
            //       "Train",
            //       style: Theme.of(context)
            //           .textTheme
            //           .headline5
            //           .copyWith(color: Theme.of(context).primaryColor),
            //       key: UniqueKey(),
            //     ),
            //     IconButton(
            //       onPressed: () async {
            //         bool outcome = await NaiveBayes.fit();
            //         showDialog(
            //             context: context,
            //             builder: (BuildContext context) => AlertDialog(
            //                 shape: RoundedRectangleBorder(
            //                     borderRadius:
            //                         BorderRadius.all(Radius.circular(10.0))),
            //                 content: Text(
            //                     outcome
            //                         ? "Training Completed"
            //                         : "No Data To Train",
            //                     style: Theme.of(context)
            //                         .textTheme
            //                         .bodyText1
            //                         .copyWith(
            //                             color:
            //                                 Theme.of(context).primaryColor))));
            //       },
            //       icon: Icon(LineIcons.play_circle),
            //       color: Colors.black,
            //       tooltip: "Train the algorithm",
            //     )
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Task Categories",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Theme.of(context).primaryColor),
                  key: UniqueKey(),
                ),
                IconButton(
                  onPressed: () {
                    this._showDialog(context);
                  },
                  icon: Icon(LineIcons.plus),
                  color: Colors.black,
                  tooltip: "Add a new Task Category",
                )
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: this._bucketList.length,
                itemBuilder: (BuildContext context, int index) => Animator(
                      duration: 500,
                      child: BucketCard(
                          bucket: this._bucketList[index],
                          delete: this._deleteBucket,
                          index: index),
                    )),
          ],
        ),
      )),
    );
  }
}
