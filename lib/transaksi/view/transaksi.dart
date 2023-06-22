import 'package:flutter/material.dart';
import 'package:flutter_batu/home/menu_page.dart';
// ignore: unused_import
import 'package:flutter_batu/home/view/home.dart';
import 'package:flutter_batu/pay/view/pay.dart';
// ignore: unused_import
import 'package:flutter_batu/transaksi/view/transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class transaksiPage extends StatefulWidget {
  const transaksiPage({super.key});

  @override
  State<transaksiPage> createState() => _transaksiPageState();
}

List _get = [];

class _transaksiPageState extends State<transaksiPage> {
  Future riwayatTiket() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var id_user = preferences.getString('id_user');
      var token = preferences.getString('token');
      var _riwayatTiket = Uri.parse(
          'https://batu.dlhcode.com/api/get_pemesanan_by_id/${id_user.toString()}');
      http.Response response = await http.get(_riwayatTiket, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token.toString(),
      });
      // print(id_user);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
// print(data['data']);
        setState(() {
          _get = data['data'];
          // print(_get);
        });
        // print(_get[0]['order_id']);

        // print(data);
        for (var i = 0; i < data['data'].length; i++) {
          var orderId = data['data'][i]['order_id'];
          // print(orderId);
          String username = 'SB-Mid-server-z5T9WhivZDuXrJxC7w-civ_k';
          String password = '';
          String basicAuth =
              'Basic ' + base64Encode(utf8.encode('$username:$password'));
          http.Response responseTransaksi = await http.get(
            Uri.parse(
                "https://api.sandbox.midtrans.com/v2/" + orderId + "/status"),
            headers: <String, String>{
              'authorization': basicAuth,
              'Content-Type': 'application/json'
            },
          );
          var jsonTransaksi = jsonDecode(responseTransaksi.body.toString());
          // print(jsonTransaksi['status_code']);
          if (jsonTransaksi['status_code'] == '200') {
            var updateTransaksi =
                Uri.parse('https://batu.dlhcode.com/api/updateTransaksi');
            // ignore: unused_local_variable
            http.Response getOrderId =
                await http.post(updateTransaksi, headers: {
              "Accept": "application/json",
              "Authorization": "Bearer " + token.toString(),
            }, body: {
              "order_id": orderId,
            });
            // print(getOrderId.body);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future refresh() async {
    setState(() {
      riwayatTiket();
    });
  }

  void initState() {
    super.initState();
    riwayatTiket();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Transaksi"),
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
            itemCount: _get.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.all(10),
              elevation: 8,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 48, 31, 83),
                  child: Icon(
                    Icons.directions_car,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  
                      _get[index]['nama_barang'].toString() +
                      ' | ' +
                      _get[index]['total_harga'].toString(),
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _get[index]['barang_in'].toString(),
                      
                  maxLines: 2,
                  style: new TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(_get[index]['status_pemesanan'].toString()),
                onTap: () {
                  if (_get[index]['status_pemesanan'] == 'Proses') {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Status Pembayaran'),
                        content:
                            const Text('Selamat pembayaran anda telah lunas'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PayPage(
                          nama_barang: _get[index]['nama_barang'].toString(),
                          total_harga: _get[index]['total_harga'].toString(),
                          status_pemesanan: _get[index]['status_pemesanan'].toString(),
                          keterangan: _get[index]['keterangan'].toString(),
                          redirect_url: _get[index]['redirect_url'].toString(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
        drawer: MenuPage(),
      ),
    );
  }
}
