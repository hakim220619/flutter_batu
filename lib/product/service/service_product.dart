import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:flutter_batu/pay/view/pay.dart';
import 'package:flutter_batu/transaksi/view/transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_batu/product/service/data.dart';

class ServiceProduct {
  static var _pesanmidtransUrl =
      Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');

  Future<List<Data>> fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse('http://batu.dlhcode.com/api/barang');
    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token.toString(),
    });
    // print(response.body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static var _pesanUrl =
      Uri.parse("https://batu.dlhcode.com/api/add_pemesanan");

  static pesan(id, jumlah, harga, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id_user = prefs.getString('id_user');
    var token = prefs.getString('token');
    // print(id);
    // print(jumlah);
    // print(harga);
    // print(id_user);

    Random objectname = Random();
    int number = objectname.nextInt(10000000);
    String username = 'SB-Mid-server-z5T9WhivZDuXrJxC7w-civ_k';
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    http.Response responseMidtrans = await http.post(_pesanmidtransUrl,
        headers: <String, String>{
          'authorization': basicAuth,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'transaction_details': {'order_id': number, 'gross_amount': harga},
          "credit_card": {"secure": true}
        }));
    var jsonMidtrans = jsonDecode(responseMidtrans.body.toString());
    // print(jsonMidtrans['redirect_url']);

    http.Response response = await http.post(_pesanUrl, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${token.toString()}" ,
    }, body: {
      "id_barang": id.toString(),
      "id_user": id_user.toString(),
      "jumlah_berat": jumlah.toString(),
      "order_id": number.toString(),
      "redirect_url": jsonMidtrans['redirect_url'].toString(),
    });
    // print(response.body);
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var json = jsonDecode(response.body.toString());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => transaksiPage()),
      );
    }
  }
}