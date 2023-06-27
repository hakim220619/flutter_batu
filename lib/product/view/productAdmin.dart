import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_batu/home/view/homeAdmin.dart';
import 'package:flutter_batu/product/service/service_product.dart';
import 'package:flutter_batu/product/view/productEdit.dart';
import 'package:flutter_batu/product/view/tambah_produk_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
// ignore: duplicate_import
import 'dart:convert';

import 'package:http/http.dart' as http;

class ListProductAdmin extends StatefulWidget {
  const ListProductAdmin({super.key});

  @override
  ListProductAdminState createState() => ListProductAdminState();
}

class ListProductAdminState extends State<ListProductAdmin> {
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

  @override
  void initState() {
    super.initState();
    barang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: const Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomePageAdmin()),
              (Route<dynamic> route) => false),
        ),
        title: const Text("Product"),
      ),
      body: Center(
          child: RefreshIndicator(
              onRefresh: barang,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
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
                                        Text(_get[index]['keterangan']
                                            .toString()),
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
                                      onPressed: () async {
                                        final result = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Are you sure?'),
                                            content: const Text(
                                                'This action will permanently delete this data'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await ServiceProduct
                                                      .DeleteBarang(
                                                          _get[index]['id']
                                                              .toString(),
                                                          context);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditProductView(
                                              id: _get[index]['id'].toString(),
                                              nama_barang: _get[index]
                                                      ['nama_barang']
                                                  .toString(),
                                              harga: _get[index]['harga']
                                                  .toString(),
                                              keterangan: _get[index]
                                                      ['keterangan']
                                                  .toString(),
                                              gbr: _get[index]['gambar'],
                                            ),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
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
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TambahProdukView()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
