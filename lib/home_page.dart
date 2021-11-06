import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/product_detail_page.dart';
import 'package:flutter_test1/product_item.dart';
import 'package:flutter_test1/products.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _queryProductList();
    super.initState();
  }
  List products = [];
  RefreshController _refreshController =
  RefreshController(initialRefresh: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('产品列表'),
        actions: <Widget>[
          // IconButton(icon: Icon(Icons.menu),onPressed: (){},),
          // IconButton(icon: Icon(Icons.add),onPressed: (){},)
          _buildRestaurantRow('Reload', () {
            _refreshController.requestRefresh();
          }),
          _buildRestaurantRow('Sort', () {
            products.sort((a, b) {
              List<int> al = a['title'].codeUnits;
              List<int> bl = b['title'].codeUnits;
              for (int i = 0; i < al.length; i++) {
                if (bl.length <= i) return 1;
                if (al[i] > bl[i]) {
                  return 1;
                } else if (al[i] < bl[i]) return -1;
              }
              return 0;
            });
            setState(() {
            });
          }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 10.0,
        ),
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: () {_queryProductList();},
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 10.0),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products == null ? 0 : products.length,
                itemBuilder: (BuildContext context, int index) {
                  Map product = products[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProductDetailPage(product['title']);
                          },
                        ),
                      );
                    },
                    child: ProductItem(
                      img: product["img"],
                      title: product["title"],
                      address: product["address"],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        )
      ),
    );
  }

  _buildRestaurantRow(
    String tip,
    VoidCallback onPressed,
  ) {
    return FlatButton(
      child: Text(
        "$tip",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
    );
  }

  _queryProductList() async {
    // TODO: request server,but the host 'https://milwaukee.dtndev.com' is not available
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
    products.clear();
    products.addAll(productList);
    setState(() {});
    // Dio dio = Dio();
    // var response = await dio.get('https://milwaukee.dtndev.com/rest/default/V1/products');
    // if (response.statusCode == HttpStatus.OK) {
    //   var data = jsonDecode(response.data);
    //   print(data);
    // } else {
    //   print('Error getting IP address:\nHttp status ${response.statusCode}');
    // }
  }
}
