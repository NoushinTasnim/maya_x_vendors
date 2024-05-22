import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';
import '../colors.dart';
import '../model/product.dart';
import '../screens/details_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Padding(
      padding: EdgeInsets.all(FetchPixels.getScale()*8.0),
      child: OpenContainer(
        closedColor: Colors.white,
        closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FetchPixels.getScale()*8),
            side: BorderSide(
                color: kAccentColor,
                width: 1
            )
        ),
        openColor: Colors.transparent,
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: (context, action) => Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(FetchPixels.getScale()*16),
                child: Image(
                  height: FetchPixels.getPixelHeight(150),
                  image: NetworkImage(product.image),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(FetchPixels.getScale()*10),
                decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(FetchPixels.getScale()*8)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                          fontFamily: 'Kalpursh',
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: FetchPixels.getTextScale()*12
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.amount,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: FetchPixels.getTextScale()*16
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        openBuilder: (context, action) => DetailsScreen(product: product),
      ),
    );
  }
}