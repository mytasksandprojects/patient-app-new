import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../utilities/image_constants.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child:
            //Container(color: Colors.red,)
            Image.asset(ImageConstants.logoImage,
            ),
          ),
          const SizedBox(height: 20),
          Text("No Data Found!".tr,style: const TextStyle(
            fontFamily: "Arial",fontWeight:FontWeight.bold,
            color: Colors.white,
            fontSize: 14,
          )),
        ],
      ),
    );
  }
}


