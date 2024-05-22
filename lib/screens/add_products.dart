import 'package:flutter/material.dart';
import 'package:maya_x_vendors/colors.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../components/text_field.dart';
import 'my_products.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../model/Vendor_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productAmountController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();

  String? _selectedOption; // State variable to keep track of the selected option
  File? _imageFile;

  final List<String> _options = ['ভারীস্রাব স্যানিটারী ন্যাপকিন', 'নিয়মিতস্রাব স্যানিটারী ন্যাপকিন', 'বেল্ট সিস্টেম স্যানিটারী ন্যাপকিন','অন্যান্য']; // List of options

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Usermodel user = Usermodel();

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('product_images').child(fileName);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kSecondaryColor,
          content: Text("Image upload failed: $e"),
        ),
      );
      return null;
    }
  }

  void _addProduct() async {
    if (_selectedOption != null &&
        _productNameController.text.isNotEmpty &&
        _productAmountController.text.isNotEmpty &&
        _productDescriptionController.text.isNotEmpty &&
        _imageFile != null) {

      try {
        String? imageURL = await _uploadImage(_imageFile!);
        if (imageURL == null) return;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('categories')
            .where('name', isEqualTo: _selectedOption)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          String categoryId = querySnapshot.docs.first.id;
          DocumentReference newDocRef = FirebaseFirestore.instance
              .collection('categories')
              .doc(categoryId)
              .collection('products')
              .doc();

          String uniqueId = newDocRef.id;
          int uniqueIndex = DateTime.now().millisecondsSinceEpoch;


          Map<String, dynamic> productData = {
            'id': uniqueId,
            'index': uniqueIndex,
            'name': _productNameController.text,
            'amount': _productAmountController.text,
            'image': imageURL,
            'details': _productDescriptionController.text,
            'vendor': user.getShopName(),
          };

          await newDocRef.set(productData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: kSecondaryColor,
              content: Text("পণ্যটি যুক্ত হয়েছে"),
            ),
          );

          _productNameController.clear();
          _productAmountController.clear();
          _productDescriptionController.clear();
          setState(() {
            _imageFile = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: kSecondaryColor,
              content: Text("পণ্যটি যোগ করতে ব্যর্থ হয়েছে: বিভাগ পাওয়া যায়নি"),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: kSecondaryColor,
            content: Text("পণ্যটি যোগ করতে ব্যর্থ হয়েছে: $e"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kSecondaryColor,
          content: Text("অনুগ্রহ করে সব ফিল্ড পূরণ করুন"),
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kAccentColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
          ),
        ),
        title: const Text(
          'নতুন পণ্য',
          style: TextStyle(
            fontFamily: 'Kalpurush',
            color: kPrimaryColor,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(FetchPixels.getScale()*16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: FetchPixels.getPixelHeight(16),
                ),
                Text(
                  'পণ্যের বিবরণী',
                  style: TextStyle(
                    fontFamily: 'Kalpurush',
                    color: kSecondaryColor,
                    fontSize: FetchPixels.getTextScale()*20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: FetchPixels.getPixelHeight(16),
                ),
                Center(
                  child: Container(
                    width: double.infinity, // Make the container take full width
                    padding: EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(8),), // Optional: Add horizontal padding
                    child: DropdownButton<String>(
                      value: _selectedOption, // The currently selected item
                      hint: Text(
                        'পণ্যের ধরণ নির্বাচন করুন',
                        style: TextStyle(
                          fontFamily: 'Kalpurush',
                          color: kSecondaryColor,
                        ),
                      ),
                      isExpanded: true, // Ensure the dropdown button fills the width of its parent
                      items: _options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue; // Update the selected item
                        });
                      },
                    ),
                  ),
                ),
                TextFieldWidget(
                  iconData: Icons.card_giftcard,
                  keyboard_type: TextInputType.name,
                  text: 'পণ্যের নাম',
                  obscureText: false,
                  textInputController: _productNameController,
                ),
                SizedBox(
                  height: FetchPixels.getPixelHeight(16),
                ),
                TextFieldWidget(
                  iconData: Icons.description,
                  keyboard_type: TextInputType.number,
                  text: 'পণ্যের মূল্য',
                  obscureText: false,
                  textInputController: _productAmountController,
                ),
                SizedBox(
                  height: FetchPixels.getPixelHeight(16),
                ),
                TextFieldWidget(
                  iconData: Icons.attach_money,
                  keyboard_type: TextInputType.multiline,
                  text: 'পণ্যের বিবরণী',
                  obscureText: false,
                  textInputController: _productDescriptionController,
                ),
                SizedBox(
                  height: FetchPixels.getPixelHeight(16),
                ),
                TextButton.icon(
                  icon: Icon(Icons.image, color: kSecondaryColor),
                  label: Text(
                    'ছবি নির্বাচন করুন',
                    style: TextStyle(
                      fontFamily: 'Kalpurush',
                      color: kSecondaryColor,
                    ),
                  ),
                  onPressed: _pickImage,
                ),
                if (_imageFile != null)
                  Image.file(
                    _imageFile!,
                    height: 200,
                  ),
              ],
            ),
          ),
          InkWell(
            // onTap: (){
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(
            //       backgroundColor: kSecondaryColor,
            //       content: Text("পণ্যটি যুক্ত হয়েছে",),
            //     ),
            //   );
            // },
            onTap: _addProduct,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(FetchPixels.getScale()*16,),
              decoration: BoxDecoration(
                color: kAccentColor,
                borderRadius: BorderRadius.circular(FetchPixels.getScale()*16)
              ),
              child: Center(
                child: Text(
                  'পণ্য যোগ করুন',
                  style: TextStyle(
                    fontFamily: 'Kalpurush',
                    color: kPrimaryColor,
                    fontSize: FetchPixels.getTextScale()*16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
