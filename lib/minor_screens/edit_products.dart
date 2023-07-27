// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'package:cbs/utilities/categ_list.dart';
import 'package:cbs/widgets/pink_butto..dart';
import 'package:cbs/widgets/snackbar.dart';
import 'package:cbs/widgets/yellow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class EditProduct extends StatefulWidget {
  final dynamic items;
  const EditProduct({Key? key, required this.items}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String proName;
  late String proDesc;
  late String proId;
  int? discount = 0;
  bool processing = false;
  String mainCategValue = 'select category';
  String subCategValue = 'select subcategory';
  List<String> subCategList = [];

  void selectedMainCateg(String value) {
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'men') {
      subCategList = men;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'kids') {
      subCategList = kids;
    }
    print(value);
    setState(() {
      mainCategValue = value;
      subCategValue = 'select subcategory';
    });
  }

  Future uploadImages() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imageFileList!.isNotEmpty) {
        if (mainCategValue != 'select category' &&
            subCategValue != 'select subcategory') {
          try {
            for (var image in imageFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imageUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'please select categories');
        }
      } else {
        imageUrlList = widget.items['proimages'];
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  editProductData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.items['proid']);
      transaction.update(documentReference, {
        'maincateg': mainCategValue,
        'subcateg': subCategValue,
        'price': price,
        'instock': quantity,
        'proname': proName,
        'prodesc': proDesc,
        'proimages': imageUrlList,
        'discount': discount,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    await uploadImages().whenComplete(() => editProductData());
  }

  List<XFile>? imageFileList = [];
  List<dynamic> imageUrlList = [];
  dynamic _pickedImageError;
  final ImagePicker _picker = ImagePicker();

  void _pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imageFileList = pickedImages;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Widget previewImages() {
    if (imageFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imageFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imageFileList![index].path));
          });
    } else {
      return const Center(
        child: Text(
          'you have not \n \n picked images yet !',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget previewCurrentImages() {
    List<dynamic> itemImages = widget.items['proimages'];
    return ListView.builder(
        itemCount: itemImages.length,
        itemBuilder: (context, index) {
          return Image.network(itemImages[index].toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            color: Colors.blueGrey.shade100,
                            height: MediaQuery.of(context).size.width * 0.5,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: previewCurrentImages(),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.27,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(' Main category',
                                        style: TextStyle(
                                          color: Colors.red,
                                        )),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      margin: const EdgeInsets.all(6),
                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child:
                                              Text(widget.items['maincateg'])),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      ' Subcategory',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      margin: const EdgeInsets.all(6),
                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child:
                                              Text(widget.items['subcateg'])),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      ExpandablePanel(
                          theme: const ExpandableThemeData(hasIcon: false),
                          header: Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(6),
                                child: const Center(
                                  child: Text(
                                    'Change Images & Categories',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                          collapsed: SizedBox(),
                          expanded: changeImages()),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 1.5,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: TextFormField(
                              initialValue:
                                  widget.items['price'].toStringAsFixed(2),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter price of product';
                                } else if (value.isValidPrice() != true) {
                                  return 'invalid price';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                price = double.parse(value!);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: textFormDecoration.copyWith(
                                labelText: 'Price',
                                hintText: 'price .. Rs',
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: TextFormField(
                              initialValue: widget.items['discount'].toString(),
                              maxLength: 2,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return null;
                                } else if (value.isValidDiscount() != true) {
                                  return 'invalid discount';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                discount = int.parse(value!);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: textFormDecoration.copyWith(
                                labelText: 'Discount',
                                hintText: 'discount .. %',
                              )),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                          initialValue: widget.items['instock'].toString(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter quantity of product';
                            } else if (value.isValidQuantity() != true) {
                              return 'not valid quantity';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            quantity = int.parse(value!);
                          },
                          keyboardType: TextInputType.number,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Quantity',
                            hintText: 'Add Quantity',
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue: widget.items['proname'],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter product name';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            proName = value!;
                          },
                          maxLength: 100,
                          maxLines: 3,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Product name',
                            hintText: 'Enter product name',
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue: widget.items['prodesc'],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter price of product';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            proDesc = value!;
                          },
                          maxLength: 800,
                          maxLines: 5,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Product description',
                            hintText: 'please enter product description',
                          )),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          YellowButton(
                              label: 'Cancel',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              width: 0.25),
                          YellowButton(
                              label: 'Save Changes',
                              onPressed: () {
                                saveChanges();
                              },
                              width: 0.5),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PinkButton(
                            label: "Delete  Item",
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .runTransaction((transaction) async{
                                DocumentReference documentReference =
                                    FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(widget.items['proid']);
                                transaction.delete(documentReference);
                              }).whenComplete(() => Navigator.pop(context));
                            },
                            width: 0.7),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget changeImages() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              color: Colors.blueGrey.shade100,
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
              child: imageFileList != null
                  ? previewImages()
                  : const Center(
                      child: Text(
                        'you have not \n \n picked images yet !',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.27,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text('* Select main category',
                          style: TextStyle(
                            color: Colors.red,
                          )),
                      DropdownButton(
                          iconSize: 40,
                          iconEnabledColor: Colors.red,
                          dropdownColor: Colors.yellow.shade400,
                          value: mainCategValue,
                          items:
                              maincateg.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (value) {
                            selectedMainCateg(value!);
                          }),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        '* Select subcategory',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      DropdownButton(
                          iconSize: 40,
                          iconEnabledColor: Colors.red,
                          iconDisabledColor: Colors.black,
                          menuMaxHeight: 500,
                          dropdownColor: Colors.yellow.shade400,
                          disabledHint: const Text('select subcategory'),
                          value: subCategValue,
                          items: subCategList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              subCategValue = value!;
                            });
                          })
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: imageFileList!.isNotEmpty
              ? YellowButton(
                  label: 'Reset Images',
                  onPressed: () {
                    setState(() {
                      imageFileList = [];
                    });
                  },
                  width: 0.6)
              : YellowButton(
                  label: 'Change Images',
                  onPressed: () {
                    _pickProductImages();
                  },
                  width: 0.6),
        ),
      ],
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Price',
  hintText: 'price .. Rs',
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.yellow, width: 1)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
);

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^[1-9][0-9]*([\.][0-9]{1,2})*$').hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
