import 'dart:async';
import 'dart:convert';
import 'package:flutter_batu/product/view/productAdmin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_text_form_field/flutter_text_form_field.dart';

class EditProductAdmin extends StatefulWidget {
  final String id;
  final String nama_barang;
  final String harga;
  final String keterangan;
  final String gambar;
  const EditProductAdmin({
    Key? key,
    required this.id,
    required this.nama_barang,
    required this.harga,
    required this.keterangan,
    required this.gambar,
  }) : super(
          key: key,
        );

  @override
// ignore: library_private_types_in_public_api
  _EditProductAdminState createState() {
    return _EditProductAdminState();
  }
}

String id = '';
String nama_barang = '';
String harga = '';
String keterangan = '';
String gambar = '';

class _EditProductAdminState extends State<EditProductAdmin> {
  final TextEditingController NamaBarang = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text("Edit Product"),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 255, 255, 255)),
                onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListProductAdmin(),
                      ),
                    ))),
        
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (_, i) => Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.nama_barang.toString(),
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
                        initialValue: widget.harga.toString(),
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
                        initialValue: widget.keterangan.toString(),
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
                        initialValue: widget.gambar.toString(),
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
        ),
      );
    
  }
}
