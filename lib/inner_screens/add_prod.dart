import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_admin_panel/controllers/MenuController.dart';
import 'package:grocery_admin_panel/screens/loading_manager.dart';
import 'package:grocery_admin_panel/services/utils.dart';
import 'package:grocery_admin_panel/widgets/buttons.dart';
import 'package:grocery_admin_panel/widgets/header.dart';
import 'package:grocery_admin_panel/widgets/side_menu.dart';
import 'package:grocery_admin_panel/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../responsive.dart';
import '../services/global_method.dart';
import 'package:firebase/firebase.dart' as fb;

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductForm({Key? key}) : super(key: key);

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Indoor';
  late final TextEditingController _titleController,_tipsController,_descriptionController, _priceController, _stocksController;
  int _groupValue = 1;
  bool isPiece = false;
  File? _pickedImage;
  String? imageUri;
  String? filename;
  Uint8List webImage = Uint8List(8);
  @override
  void initState() {
    _priceController = TextEditingController();
    _stocksController = TextEditingController();
    _titleController = TextEditingController();
    _tipsController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _priceController.dispose();
      _stocksController.dispose();
      _titleController.dispose();
    }
    super.dispose();
  }

  bool _isLoading = false;
  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        GlobalMethods.errorDialog(
            subtitle: 'Please pick up an image', context: context);
        return;
      }
      final _uuid = const Uuid().v4();
      try {
        setState(() {
          _isLoading = true;
        });
        UploadTask task = FirebaseStorage.instance
            .ref()
            .child("files/$filename")
            .putData(webImage);
        var dowurl = await (await task).ref.getDownloadURL();
        imageUri = dowurl.toString();
        await FirebaseFirestore.instance.collection('products').doc(_uuid).set({
          'id': _uuid,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'tips': _tipsController.text,
          'price': _priceController.text,
          'stocks':_stocksController.text,
          'salePrice': 0.1,
          'imageUrl': imageUri,
          'productCategoryName': _catValue,
          'isOnSale': false,
          'isBestSeller':false,
          'isPiece': isPiece,
          'createdAt': Timestamp.now(),
        });
        _clearForm();
        Fluttertoast.showToast(
          msg: "Product uploaded succefully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          // backgroundColor: ,
          // textColor: ,
          // fontSize: 16.0
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    isPiece = false;
    _groupValue = 1;

    _priceController.clear();
    _titleController.clear();
    _tipsController.clear();
    _descriptionController.clear();

    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      key: context.read<MenuController>().getAddProductscaffoldKey,
      drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Header(),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: size.width > 650 ? 650 : size.width,
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextWidget(
                              text: 'Product Image:',
                              color: color,
                              isTitle: true,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: size.width > 650
                                      ? 350
                                      : size.width * 0.45,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius:
                                    BorderRadius.circular(12.0),
                                  ),
                                  child: _pickedImage == null
                                      ? dottedBorder(color: color)
                                      : ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    child: kIsWeb
                                        ? Image.memory(webImage,
                                        fit: BoxFit.fill)
                                        : Image.file(_pickedImage!,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                            ),
                            TextWidget(
                              text: 'Product Title:',
                              color: color,
                              isTitle: true,
                            ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                            TextFormField(
                              controller: _titleController,
                              key: const ValueKey('Title'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a Title';
                                }
                                return null;
                              },
                              decoration: inputDecoration,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextWidget(
                              text: 'Product Description:',
                              color: color,
                              isTitle: true,
                            ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                            TextFormField(
                              maxLines: 8,
                              controller: _descriptionController,

                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a Description';
                                }
                                return null;
                              },
                              decoration: inputDecoration,
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            ////////////////////////////////////
                            TextWidget(
                              text: 'Product Caretips:',
                              color: color,
                              isTitle: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              maxLines: 8,
                              controller: _tipsController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter product caretipes type N/A if none';
                                }
                                return null;
                              },
                              decoration: inputDecoration,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  text: 'Price:',
                                  color: color,
                                  isTitle: true,
                                ),

                                TextWidget(
                                  text: 'Stocks',
                                  color: color,
                                  isTitle: true,
                                ),


                                TextWidget(
                                  text: 'Category:',
                                  color: color,
                                  isTitle: true,
                                ),

                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    controller: _priceController,
                                    key: const ValueKey('Price \$'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Price is missed';
                                      }
                                      return null;
                                    },
                                    inputFormatters: <
                                        TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9.]')),
                                    ],
                                    decoration: inputDecoration,
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    controller: _stocksController,
                                    key: const ValueKey('Stocks \$'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Stocks is missed';
                                      }
                                      return null;
                                    },
                                    inputFormatters: <
                                        TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9.]')),
                                    ],
                                    decoration: inputDecoration,
                                  ),
                                ),
                                ////////////



                                // Drop down menu code here
                                SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: _categoryDropDown()),


                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Unit: ',
                                  color: color,
                                  isTitle: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // Radio button code here
                                Row(
                                  children: [
                                    TextWidget(
                                      text: 'KG',
                                      color: color,
                                    ),
                                    Radio(
                                      value: 1,
                                      groupValue: _groupValue,
                                      onChanged: (valuee) {
                                        setState(() {
                                          _groupValue = 1;
                                          isPiece = false;
                                        });
                                      },
                                      activeColor: Colors.green,
                                    ),
                                    TextWidget(
                                      text: 'Piece',
                                      color: color,
                                    ),
                                    Radio(
                                      value: 2,
                                      groupValue: _groupValue,
                                      onChanged: (valuee) {
                                        setState(() {
                                          _groupValue = 2;
                                          isPiece = true;
                                        });
                                      },
                                      activeColor: Colors.green,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [


                                  AnimatedButton(
                                    height: 40,
                                    width: 200,
                                    text: 'Add',
                                    isReverse: true,
                                    textAlignment: Alignment.center,
                                    animatedOn: AnimatedOn.onHover,
                                    animationDuration: Duration(milliseconds: 500),
                                    selectedBackgroundColor: Colors.blue.shade400,
                                    selectedTextColor: Colors.black,
                                    transitionType: TransitionType.BOTTOM_CENTER_ROUNDER,
                                    backgroundColor: Colors.blue.shade900,
                                    borderRadius: 2,
                                    borderWidth: 2,
                                    onPress: () {
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        setState(() {
                                          _uploadForm();
                                        });
                                      });
                                    },
                                  ),
                                  AnimatedButton(
                                    height: 40,
                                    width: 200,
                                    text: 'Clear',
                                    isReverse: true,
                                    animatedOn: AnimatedOn.onHover,
                                    textAlignment: Alignment.center,
                                    animationDuration: Duration(milliseconds: 500),
                                    selectedTextColor: Colors.black,
                                    selectedBackgroundColor: Colors.red.shade400,
                                    transitionType: TransitionType.BOTTOM_CENTER_ROUNDER,
                                    backgroundColor: Colors.red.shade900,
                                    borderRadius: 2,
                                    borderWidth: 2,
                                    onPress: () {
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        setState(() {
                                          _clearForm();
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No image has been picked');
      }
    } else if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      webImage = result!.files.first.bytes!;
      filename = result.files.first.name;
      if (result != null) {
        setState(() {
          webImage;
          _pickedImage = File('a');
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          dashPattern: const [6.7],
          borderType: BorderType.RRect,
          color: color,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: (() {
                      _pickImage();
                    }),
                    child: TextWidget(
                      text: 'Choose an image',
                      color: Colors.blue,
                    ))
              ],
            ),
          )),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          value: _catValue,
          onChanged: (value) {
            setState(() {
              _catValue = value!;
            });
            print(_catValue);
          },
          hint: const Text('Select a category'),
          items: const [
            DropdownMenuItem(
              child: Text(
                'Indoor',
              ),
              value: 'Indoor',
            ),
            DropdownMenuItem(
              child: Text(
                'Outdoor',
              ),
              value: 'Outdoor',
            ),
            DropdownMenuItem(
              child: Text(
                'Pots',
              ),
              value: 'Pots',
            ),
            DropdownMenuItem(
              child: Text(
                'Seeds',
              ),
              value: 'Seeds',
            ),
            DropdownMenuItem(
              child: Text(
                'Soil',
              ),
              value: 'Soil',
            ),
            DropdownMenuItem(
              child: Text(
                'Fertilizer',
              ),
              value: 'Fertilizer',
            )
          ],
        )
        ),
      ),
    );
  }
}
