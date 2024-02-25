import 'package:flutter/material.dart';
import '../utils/color_extension.dart';

class OnboardingPage extends StatelessWidget {
  final Map pObj;
  const OnboardingPage({super.key, required this.pObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
        width: media.width,
        height: media.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(pObj["image"].toString(),
                width: media.width,
                height: media.height * 0.65,
                fit: BoxFit.fitWidth),
            SizedBox(height: media.width * 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(pObj["title"].toString(),
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(pObj["subtitle"].toString(),
                  style: TextStyle(color: TColor.grey, fontSize: 14)),
            )
          ],
        ));
  }
}
