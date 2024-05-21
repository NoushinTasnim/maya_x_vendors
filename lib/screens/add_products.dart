import 'package:flutter/material.dart';
import 'package:maya_x_vendors/colors.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';

import '../components/text_field.dart';
import 'my_products.dart';

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

  final List<String> _options = ['ভারীস্রাব স্যানিটারী ন্যাপকিন', 'নিয়মিতস্রাব স্যানিটারী ন্যাপকিন', 'বেল্ট সিস্টেম স্যানিটারী ন্যাপকিন','অন্যান্য']; // List of options


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
              ],
            ),
          ),
          InkWell(
            onTap: (){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: kSecondaryColor,
                  content: Text("পণ্যটি যুক্ত হয়েছে",),
                ),
              );
            },
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
