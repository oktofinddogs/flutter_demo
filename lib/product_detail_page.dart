import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatefulWidget{

  final String name;
  ProductDetailPage(this.name);


  @override
  State<StatefulWidget> createState() {
    return _ProductDetailPageState();
  }

}

class _ProductDetailPageState extends State<ProductDetailPage>{
  SharedPreferences? prefs;
  List<String> bookmarkList = [];
  bool isMarked = false;
  final String prefsKey = "bookmarkList";
  @override
  void initState() {
    _initPrefs();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name}详情'),
        actions: [IconButton(icon: Icon(isMarked ? Icons.bookmark : Icons.bookmark_border),onPressed: (){
          setState(() {
            isMarked = !isMarked;
          });
          if (isMarked) {
            bookmarkList.add(widget.name);
          } else {
            bookmarkList.remove(widget.name);
          }
          prefs!.setStringList(prefsKey, bookmarkList);
        },),],
      ),
      body: Text(widget.name),
    );
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    bookmarkList = prefs!.getStringList(prefsKey) ?? [];
    setState(() {
      isMarked = bookmarkList.contains(widget.name);
    });
  }

}