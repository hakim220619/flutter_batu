import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_batu/product/service/service_product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class TambahProdukView extends StatefulWidget {
  const TambahProdukView({super.key});

  @override
  State<TambahProdukView> createState() => _TambahProdukViewState();
}

class _TambahProdukViewState extends State<TambahProdukView> {
  late TextEditingController namaBarangEditingController;
  late TextEditingController hargaEditingController;
  late TextEditingController keteranganEditingController;

  String? imagePath;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    namaBarangEditingController = TextEditingController();
    hargaEditingController = TextEditingController();
    keteranganEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    namaBarangEditingController.dispose();
    hargaEditingController.dispose();
    keteranganEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah produk'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: [
            CustomTextField(
              controller: namaBarangEditingController, 
              label: 'nama barang',
            ),
            const SizedBox(height: 8,),
            CustomTextField(
              controller: hargaEditingController, 
              label: 'harga barang',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8,),
            CustomTextField(
              controller: keteranganEditingController, 
              label: 'keteranagan',
              maxLine: 4,
            ),
            const SizedBox(height: 8,),
            containerImageWidget(context),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()){
                  showDialog(
                    context: context, 
                    builder: (_){
                      return const AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator.adaptive(),
                            SizedBox(height: 8,),
                            Text('Loading')
                          ],
                        ),
                      );
                    }
                  );
                  await ServiceProduct().addProduct(
                    namaBarangEditingController.text, 
                    hargaEditingController.text, 
                    keteranganEditingController.text, 
                    imagePath
                  ).whenComplete(() => Navigator.pop(context));
                  Fluttertoast.showToast(msg: 'Berhasil menambahkan data');
                }
              }, 
              child: const Text('Tambah data')
            )
          ],
        ),
      )
    );
  }

  Widget containerImageWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final path = await chooseImage();
        setState(() {
          imagePath = path;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(.40)
          ),
          borderRadius: BorderRadius.circular(4),
          image: imagePath != null ?
            DecorationImage(
              image: FileImage(File(imagePath!)),
              fit: BoxFit.cover
            ) : null
        ),
        child: Visibility(
          visible: imagePath == null ? true : false,
          child: const Text('Pilih gambar')
        ),
      ),
    );
  }
}

Future<String?> chooseImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    return image!.path;
  }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key, 
    required this.controller, 
    required this.label, 
    this.keyboardType = TextInputType.text,
    this.maxLine = 1
  });

  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Form tidak boleh kosong';
        }
        return null;
      },
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLine,
    );
  }
}