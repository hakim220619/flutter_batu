import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_batu/product/service/service_product.dart';
import 'package:flutter_batu/product/view/productAdmin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';

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

// String id = '';

class _EditProductAdminState extends State<EditProductAdmin> {
  // TextEditingController NamaBarang = TextEditingController();
  final NamaBarang = TextEditingController();
  final Harga = TextEditingController();
  final Keterangan = TextEditingController();
  // final NamaBarang = TextEditingController();
  // late TextEditingController NamaBarang;

  final _formKey = GlobalKey<FormState>();
  late String nama_barang;
  late String harga;
  late String keterangan;
  late String gambar;
  late File uploadimage;

  // XFile? _image;


  //variable for choosed file
  @override
  void initState() {
    super.initState();
    NamaBarang.text = widget.nama_barang.toString();
    Harga.text = widget.harga.toString();
    Keterangan.text = widget.keterangan.toString();
    // Gambar.text = widget.gambar.toString();
    // uploadImage();
  }
@override
  Widget build(BuildContext context) {
    // final TextEditingController NamaBarang = TextEditingController();

  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text("Edit Product"),
            leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: const Color.fromARGB(255, 255, 255, 255)),
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
                      // initialValue: widget.nama_barang.toString(),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukan Nama Barang';
                        }
                        return null;
                      },
                      maxLines: 1,
                      controller: NamaBarang,
                      keyboardType: TextInputType.text,
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
                          // print(nama_barang);
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      // initialValue: widget.harga.toString(),
                      controller: Harga,
                      keyboardType: TextInputType.number,
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
                      controller: Keterangan,
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

                    // Column(
                    //   children: [
                    //     TextButton(
                    //         onPressed: _imageHandler,
                    //         child: const Text("Pick image")),
                    //     if (_image != null) Image.file(File(_image!.path))
                    //   ],
                    // ),
                    // Container(
                    //     //show image here after choosing image
                    //     child: uploadimage ==
                    //         ? Container()
                    //         : //if uploadimage is null then show empty container
                    //         Container(
                    //             //elese show image here
                    //             child: SizedBox(
                    //                 height: 150,
                    //                 child: Image.file(
                    //                     uploadimage) //load image from file
                    //
                    //            ))),
                    
                    Container(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();
                          var choosedimage = await _picker.pickImage(
                              source: ImageSource.gallery);

                          // print(choosedimage);
                          //set source: ImageSource.camera to get image from camera
                          setState(() {
                            uploadimage = choosedimage as File;

                            // print(baseimage);
                          });
                        },
                        icon: Icon(Icons.folder_open),
                        label: Text("CHOOSE IMAGE"),
                      ),
                    ),
                    InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await ServiceProduct.UpdateProduct(
                                widget.id,
                                NamaBarang,
                                Harga,
                                Keterangan,
                                uploadimage,
                                context);
                            //  print(uploadimage);
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

//   Future<File> getImage() async {
//     final ImagePicker _picker = ImagePicker();
// // Pick an image
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// //TO convert Xfile into file
//     File file = File(image!.path);
// //print(‘Image picked’);
//     return file;
//   }
  // Future<void> chooseImage() async {

  // }
}
