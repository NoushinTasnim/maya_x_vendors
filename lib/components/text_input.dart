import 'package:flutter/material.dart';
import 'package:maya_x_vendors/components/text_field.dart';
import 'package:maya_x_vendors/fetch_pixels.dart';

class TextInputFiledsWidget extends StatelessWidget {
  const TextInputFiledsWidget({
    super.key,
    required this.phoneController,
    required this.passwordController,
    this.userController,
  });

  final TextEditingController phoneController;
  final TextEditingController? userController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Column(
      children: [
        userController != null ? Column(
          children: [
            SizedBox(
              height: FetchPixels.getPixelHeight(32),
            ),
            TextFieldWidget(
              iconData: Icons.person_outline,
              text: 'স্টোরের নাম',
              keyboard_type: TextInputType.name,
              textInputController: userController ?? phoneController,
            ),
            SizedBox(
              height: FetchPixels.getPixelHeight(16),
            ),
          ],
        ) : SizedBox(
          height: FetchPixels.getPixelHeight(32),
        ),
        TextFieldWidget(
          text: 'ফোন নম্বর',
          keyboard_type: TextInputType.phone,
          iconData: Icons.phone_outlined,
          textInputController: phoneController,
        ),
        SizedBox(
          height: FetchPixels.getPixelHeight(16),
        ),
        TextFieldWidget(
          iconData: Icons.lock_outline,
          keyboard_type: TextInputType.multiline,
          text: 'পাসওয়ার্ড',
          obscureText: true,
          textInputController: passwordController,
        ),
        SizedBox(
          height: FetchPixels.getPixelHeight(16),
        ),
      ],
    );
  }
}