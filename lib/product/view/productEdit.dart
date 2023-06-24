import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_text_form_field/flutter_text_form_field.dart';

class EditProductAdmin extends StatefulWidget {
  const EditProductAdmin({Key? key}) : super(key: key);

  @override
// ignore: library_private_types_in_public_api
  _EditProductAdminState createState() {
    return _EditProductAdminState();
  }
}

class _EditProductAdminState extends State<EditProductAdmin> {
  final TextEditingController NamaBarang = TextEditingController();
  String nama_barang = '';
  String harga = '';
  String keterangan = '';
  String gambar = '';

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    List _get = [];
    Future barang() async {
      try {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var id_user = preferences.getString('id_user');
        var token = preferences.getString('token');
        var _riwayatTiket =
            Uri.parse('http://batu.dlhcode.com/api/get_barang_by_id/4');
        http.Response response = await http.get(_riwayatTiket, headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + token.toString(),
        });
        // print(id_user);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
// print(data['data']);
          setState(() {
            nama_barang = data['data'][0]['nama_barang'];
            harga = data['data'][0]['harga'];
            keterangan = data['data'][0]['keterangan'];
            gambar = data['data'][0]['gambar'];

            // print(nama_barang);
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
      //  print(_futureAlbum);
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Update Data Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: RefreshIndicator(
              onRefresh: barang,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemCount: 1,
                itemBuilder: (_, i) => Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: nama_barang.toString(),
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan Nama Barang';
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Masukan Nama Barang',
                            hintText: 'Masukan Nama Barang'),
                        onChanged: (value) {
                          setState(() {
                            nama_barang = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: harga.toString(),
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan Harga';
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Masukan Harga',
                            hintText: 'Masukan Harga'),
                        onChanged: (value) {
                          setState(() {
                            harga = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: keterangan.toString(),
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan Keterangan';
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Masukan Keterangan',
                            hintText: 'Masukan Keterangan'),
                        onChanged: (value) {
                          setState(() {
                            keterangan = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: gambar.toString(),
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan Gambar';
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Masukan Gambar',
                            hintText: 'Masukan Gambar'),
                        onChanged: (value) {
                          setState(() {
                            gambar = value;
                          });
                        },
                      ),
                      InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              // await HttpService.register(
                              //     email, password, nama, noHp, context);
                            }
                          },
                          child: Container(
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 250),
                            child: const Center(
                              child: Text(
                                "Simpan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(9, 107, 199, 1),
                                borderRadius: BorderRadius.circular(10)),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        )));
  }
}
