import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_batu/home/view/home.dart';
import 'package:flutter_batu/product/view/transaksiAdmin.dart';
import 'package:flutter_batu/transaksi/view/transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class UpdateTransaksiAdmin extends StatefulWidget {
  const UpdateTransaksiAdmin({
    Key? key,
    required this.id,
    required this.nama_barang,
    required this.total_harga,
    required this.status_pemesanan,
    required this.redirect_url,
    required this.keterangan,
  }) : super(key: key);
  final String id;
  final String nama_barang;
  final String total_harga;
  final String status_pemesanan;
  final String redirect_url;
  final String keterangan;

  @override
  State<UpdateTransaksiAdmin> createState() => _UpdateTransaksiAdminState();
}

class _UpdateTransaksiAdminState extends State<UpdateTransaksiAdmin> {
  TextEditingController barang_in = TextEditingController();
  final _timeC = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  // TextEditingController Email = TextEditingController();
  // TextEditingController Nohp = TextEditingController();
  @override
  void dispose() {
    _formkey.currentState?.dispose();
    super.dispose();
  }

  var barang_;

  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2025);

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    Future displayTimePicker(BuildContext context) async {
      var time = await showTimePicker(context: context, initialTime: timeOfDay);

      if (time != null) {
        setState(() {
          _timeC.text = "${time.hour}:${time.minute}";
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const transaksiPage(),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(253, 255, 252, 252),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                    leading: Icon(
                      Icons.production_quantity_limits,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      widget.nama_barang,
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontFamily: "Source Sans Pro"),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                    leading: Icon(
                      Icons.money,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      widget.total_harga,
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontFamily: "Source Sans Pro"),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                    leading: Icon(
                      Icons.description,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      widget.keterangan,
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontFamily: "Source Sans Pro"),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                    leading: Icon(
                      Icons.payment,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      widget.status_pemesanan,
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontFamily: "Source Sans Pro"),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                  child: Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: TextFormField(
                  controller: _timeC,
                  onTap: () => displayTimePicker(context),
                  onChanged: (value) {
                    setState(() {
                      barang_ = value;
                    });
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: '00:00:00',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Barang Out"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "tidak boleh kosong";
                    }
                    return null;
                  },
                ),
              )),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.redAccent[50],
                child: Center(
                    child: ElevatedButton(
                  child: Text("Kirim Pesanan"),
                  onPressed: () async {
                    // print(_timeC.text);
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();

                    var token = preferences.getString('token');
                    var updateTransaksi = Uri.parse(
                        'https://batu.dlhcode.com/api/updateTransaksiAdmin');
                    // ignore: unused_local_variable
                    http.Response response =
                        await http.post(updateTransaksi, headers: {
                      "Accept": "application/json",
                      "Authorization": "Bearer " + token.toString(),
                    }, body: {
                      "id": widget.id.toString(),
                      "barang_out": _timeC.text
                    });
                    print(response.statusCode);
                    if (response.statusCode == 200) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ListTransaksiAdmin()),
                          (Route<dynamic> route) => false);
                    }
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
