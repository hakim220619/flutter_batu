import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_batu/product/view/productEdit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
// ignore: duplicate_import
import 'dart:convert';

import 'package:http/http.dart' as http;

class ListProductAdmin extends StatefulWidget {
  @override
  _ListProductAdminState createState() => _ListProductAdminState();
}

class _ListProductAdminState extends State<ListProductAdmin> {
  List _get = [];
  Future barang() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('http://batu.dlhcode.com/api/barang');
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token.toString(),
      });
      // print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);
        setState(() {
          _get = data['data'];
          // print(_get);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    barang();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: RefreshIndicator(
            onRefresh: barang,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListView.builder(
                  itemCount: _get.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        _get[index]['nama_barang'].toString(),
                                        // style: Theme.of(context).textTheme.title,
                                      ),
                                      Text(_get[index]['harga'].toString()),
                                      Text(
                                          _get[index]['keterangan'].toString()),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Image.network(
                                      'https://batu.dlhcode.com/upload/produk/${_get[index]['gambar']}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      // TODO: do something in here
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (
                                            context,
                                          ) =>
                                                  EditProductAdmin()));
                                    },
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )));
  }
}
