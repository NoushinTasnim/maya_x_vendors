import 'package:flutter/material.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';
import 'package:maya_x_vendors/screens/my_products.dart';
import '../colors.dart';
import '../model/product.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>MyProducts())
          );
        },
        backgroundColor: kAccentColor,
        child: const Icon(
          Icons.shopping_cart_outlined,
          color: kPrimaryColor,
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
            onTap:(){
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: kAccentColor,
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: FetchPixels.getPixelHeight(300),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: kSecondaryColor.withOpacity(0.5),
                      blurRadius: 48,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(FetchPixels.getScale()*64),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(FetchPixels.getScale()*64),
                  ),
                  child: Image.asset(
                    product.image,
                    width: double.infinity,
                    height: FetchPixels.getPixelHeight(200),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(FetchPixels.getScale()*16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: TextStyle(
                              fontFamily: 'Kalpurush',
                              color: kAccentColor,
                              fontSize: FetchPixels.getTextScale()*20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          product.amount,
                          style: TextStyle(
                            color: kAccentColor,
                            fontSize: FetchPixels.getTextScale()*24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(FetchPixels.getScale()*16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'পণ্যের বিবরণী',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: FetchPixels.getTextScale()*18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(8), horizontal: FetchPixels.getPixelWidth(16)),
                    child: Text(
                      'Introducing the Fiddle Leaf Fig, a stunning indoor plant that adds a touch of elegance to any space. With its large, glossy leaves and tall stature, this plant is a true statement piece. The Fiddle Leaf Fig is known for its air-purifying qualities, making it not only beautiful but also beneficial for your indoor environment. Its lush green foliage brings a sense of freshness and serenity, creating a calming atmosphere. Whether placed in a living room, office, or bedroom, the Fiddle Leaf Fig is sure to be a conversation starter and a source of natural beauty.',
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: FetchPixels.getTextScale()*16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}