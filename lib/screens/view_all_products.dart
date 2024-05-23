import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';
import 'package:maya_x_vendors/screens/add_products.dart';
import 'package:maya_x_vendors/screens/my_products.dart';

import '../colors.dart';
import '../components/product_card.dart';
import '../model/Vendor_model.dart';
import '../model/category.dart';
import '../model/load_from_json.dart';
import '../model/product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController _searchController = TextEditingController();
  late Future<List<Category>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = loadCategories();
    fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  Usermodel user = Usermodel();

  Future<void> fetchData() async {
    if (user.getShopName() =='') {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        try {
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('user').doc(uid).get();

          if (documentSnapshot.exists) {
            final data = documentSnapshot.data() as Map<String, dynamic>?;

            if (data != null) {
              setState(() {
                user.name = data['shop name'].toString();
                user.phone = data['phone'].toString();
                user.password = data['password'].toString();
                user.userID = data['userID'].toString();

              });

              print(user.name);
            } else {
              print('No data found in document');
            }
          } else {
            print('Document does not exist in the database');
          }
        } catch (e) {
          print('Error fetching data: $e');
        }
      } else {
        print('User ID is null');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: FetchPixels.getScale()*64.0),
        child: FloatingActionButton(
          backgroundColor: kAccentColor,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProduct()));
          },
          child: Icon(
            Icons.add,
            color: kPrimaryColor,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: kAccentColor,
        automaticallyImplyLeading: false,
        leading: const Icon(
          Icons.menu_rounded,
          color: kPrimaryColor,
        ),
        title: Text(
          user.getShopName(),
          style: TextStyle(
            fontFamily: 'Kalpurush',
            color: kPrimaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(FetchPixels.getScale()*16.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => MyProducts(),
                  ),
                );
              },
              child: Icon(
                Icons.assignment_outlined,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(FetchPixels.getScale()*16),
            child: TextField(
              cursorColor: kSecondaryColor,
              controller: _searchController,
              decoration: InputDecoration(
                focusColor: kSecondaryColor,
                hintText: 'অনুসন্ধান করুন...',
                prefixIcon: Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(FetchPixels.getScale()*16.0)),
                ),
              ),
              onChanged: (value) {
                // Perform search or filter operations here
                print('Search query: $value');
              },
            ),
          ),
          SizedBox(height: FetchPixels.getPixelHeight(16)),
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: _futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: kAccentColor,));
                } else if (snapshot.hasError) {
                  return Center(child: Text('ইন্টারনেট কানেকশন চেক করুন'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('ইন্টারনেট কানেকশন চেক করুন'));
                }

                final categories = snapshot.data!;
                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, categoryIndex) {
                    final category = categories[categoryIndex];
                    final pageController = PageController(
                      viewportFraction: .5,
                      initialPage: 1,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getScale()*16.0),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontFamily: 'Kalpurush',
                              color: kSecondaryColor,
                              fontSize: FetchPixels.getTextScale()*20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: FetchPixels.getScale()*8),
                          child: AspectRatio(
                            aspectRatio: 1.8,
                            child: PageView.builder(
                              onPageChanged: (value) {
                                setState(() {
                                  // Handle page change if necessary
                                });
                              },
                              controller: pageController,
                              physics: ClampingScrollPhysics(),
                              itemCount: category.products.length,
                              itemBuilder: (context, productIndex) {
                                return buildProductCard(
                                  category.products[productIndex],
                                  pageController,
                                  productIndex,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: FetchPixels.getPixelHeight(32)),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductCard(Product product, PageController pageController, int productIndex) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double value = 0;
        if (pageController.position.haveDimensions) {
          value = productIndex - pageController.page!;
          value = (value).clamp(-1, 1);
        }
        double scale = 1 - (value.abs() * 0.33); // Adjust the scale factor as desired

        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: 1,
          child: Transform.scale(
            scale: scale,
            child: ProductCard(
              product: product,
            ),
          ),
        );
      },
    );
  }
}