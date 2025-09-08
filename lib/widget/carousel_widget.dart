import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../widget/image_box_widget.dart';
import '../utilities/colors_constant.dart';

class CarouselSliderWidget extends StatefulWidget {
   final List?  imagesUrl;
   const CarouselSliderWidget({super.key,this.imagesUrl});

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();

}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    // DeviceType deviceType = getDeviceType(MediaQuery.of(context));
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * .2,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CarouselSlider.builder(
                itemCount:widget.imagesUrl?.length??0,// brDetails["brImg"].length,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * .2,
                  viewportFraction: 1,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  onPageChanged: _callbackFunction,
                ),
                itemBuilder: (ctx, index, realIdx) {
                  return ImageBoxFillWidget(imageUrl:widget.imagesUrl?[index]??"");
                },
              ),
            ),
            Positioned(
              top: 0,
                right: 0,
                child: SizedBox(
                  height: 30,
                 // width: double.maxFinite,
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                       // padding: const EdgeInsets.all(),
                        itemCount:widget.imagesUrl?.length??0,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              backgroundColor: ColorResources.greyBtnColor,//primaryColor,
                              radius: _currentIndex == index ? 6.0 : 4,
                              // child: CircleAvatar(
                              //   backgroundColor: Colors.white,
                              //   radius: _currentIndex == index ? 6.0 : 4,
                              //
                              // ),
                            ),
                          );
                        }),
                  ),
                )),

          ],
        ),
      ),
    );
  }
  _callbackFunction(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }
}
class CarouselSliderProductWidget extends StatefulWidget {
  final List?  imagesUrl;
  const CarouselSliderProductWidget({super.key,this.imagesUrl});

  @override
  State<CarouselSliderProductWidget> createState() => _CarouselSliderProductWidgetWidgetState();

}

class _CarouselSliderProductWidgetWidgetState extends State<CarouselSliderProductWidget> {
  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    // DeviceType deviceType = getDeviceType(MediaQuery.of(context));
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * .3,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CarouselSlider.builder(
                itemCount:widget.imagesUrl?.length??0,// brDetails["brImg"].length,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * .3,
                  viewportFraction: 1,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  onPageChanged: _callbackFunction,
                ),
                itemBuilder: (ctx, index, realIdx) {
                  return ImageBoxFillWidget(imageUrl:widget.imagesUrl?[index]??"");
                },
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  height: 30,
                  // width: double.maxFinite,
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        // padding: const EdgeInsets.all(),
                        itemCount:widget.imagesUrl?.length??0,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              backgroundColor: ColorResources.greyBtnColor,//primaryColor,
                              radius: _currentIndex == index ? 6.0 : 4,
                              // child: CircleAvatar(
                              //   backgroundColor: Colors.white,
                              //   radius: _currentIndex == index ? 6.0 : 4,
                              //
                              // ),
                            ),
                          );
                        }),
                  ),
                )),

          ],
        ),
      ),
    );
  }
  _callbackFunction(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }
}