import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/generated/l10n.dart';
import '../controller/appointment_controller.dart';
import '../model/appointment_model.dart';
import '../widget/loading_Indicator_widget.dart';
import '../helpers/route_helper.dart';
import '../utilities/colors_constant.dart';
import '../widget/error_widget.dart';
import '../widget/no_data_widgets.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {

  String  serviceName ="Offline";
  AppointmentController appointmentController =Get.put(AppointmentController());

  @override
  void initState() {
    super.initState();
    // Defer the API call to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appointmentController.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorResources.bgColor,
        appBar: AppBar(
          // leading: Transform.scale(
          //   scale: .8,
          //   child: Container(
          //     margin: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: ColorResources.darkCardColor.withOpacity(0.9),
          //       border: Border.all(
          //         color: ColorResources.primaryColor.withOpacity(0.3),
          //         width: 1,
          //       ),
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: IconButton(
          //         icon: const Icon(
          //           Icons.arrow_back,
          //           size: 20.0,
          //           color: ColorResources.primaryColor,
          //         ),
          //         onPressed: () => Get.back()),
          //   ),
          // ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            S.of(context).LMyBooking,
            style: const TextStyle(
                color: ColorResources.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          bottom: TabBar(
            indicatorWeight: 1,
            indicatorColor: ColorResources.primaryColor,
            dividerColor: Colors.transparent,
            labelPadding: const EdgeInsets.all(8),
            tabs: [
              Text(
                S.of(context).LUpcoming,
                style: const TextStyle(
                    color: ColorResources.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                S.of(context).LClosed,
                style: const TextStyle(
                    color: ColorResources.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorResources.gradientStart,
                ColorResources.gradientEnd,
              ],
            ),
          ),
          child: Obx(() {
            if (!appointmentController.isError.value) { // if no any error
              if (appointmentController.isLoading.value) {
                return const IVerticalListLongLoadingWidget();
              } else if (appointmentController.dataList.isEmpty) {
                return const NoDataWidget();
              }
              else {
                return
                Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: TabBarView(
                    children: [
                      _upcomingAppointmentList(appointmentController.dataList),
                      _pastAppointmentList(appointmentController.dataList)
                    ],
                  ),
                );

              }
            }else {
              return  const IErrorWidget();
            } //Error svg
          }
          ),
        )
      ),
    );
  }

  _upcomingAppointmentList(List dataList) {
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return dataList[index].status=="Pending"||dataList[index].status=="Confirmed"||dataList[index].status=="Rescheduled"?
          _card( dataList[index]):Container();
        });
  }

  _pastAppointmentList(List dataList) {
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return dataList[index].status=="Completed"||dataList[index].status=="Visited"||dataList[index].status=="Rejected"||dataList[index].status=="Cancelled"? _card( dataList[index]):Container();//_card( true);
        });
  }
  Widget _card(AppointmentModel appointmentModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () async{
         Get.toNamed(RouteHelper.getAppointmentDetailsPageRoute(appId:appointmentModel.id.toString() ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: ColorResources.darkCardColor.withOpacity(0.9),
            border: Border.all(
              color: ColorResources.primaryColor.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _appointmentDate(appointmentModel.date),
                    Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('#${appointmentModel.id}', style: const TextStyle(
                          color: ColorResources.secondaryFontColor,
                          fontFamily: 'OpenSans-Regular',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        )),
                        Row(
                          children:  [
                            Text(S.of(context).name,
                                style: const TextStyle(
                                  color: ColorResources.secondaryFontColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                )),
                            const SizedBox(width: 5),
                            Container(
                              width: MediaQuery.of(context).size.width/2.2,
                              child: Text(
                                  "${appointmentModel.pFName??""} ${appointmentModel.pLName??""}" ,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children:  [
                              Text(S.of(context).time,
                                style: const TextStyle(
                                  color: ColorResources.secondaryFontColor,
                                  fontFamily: 'OpenSans-Regular',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                )),
                            const SizedBox(width: 5),
                            Text(appointmentModel.timeSlot??"",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                )),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                                    height: 1, color: ColorResources.primaryColor.withOpacity(0.3))),
                            Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: appointmentModel.status ==
                                    "Pending"
                                    ? _statusIndicator(Colors.yellowAccent)
                                    : appointmentModel.status ==
                                    "Rescheduled"
                                    ? _statusIndicator(Colors.orangeAccent)
                                    : appointmentModel.status ==
                                    "Rejected"
                                    ? _statusIndicator(Colors.red)
                                    : appointmentModel.status ==
                                    "Confirmed"
                                    ? _statusIndicator(Colors.green)
                                    : appointmentModel.status ==
                                    "Completed"
                                    ? _statusIndicator(Colors.green)
                                    :appointmentModel.status ==
                                    "Cancelled"
                                    ? _statusIndicator(Colors.red)
                                    :appointmentModel.status ==
                                    "Visited"
                                    ? _statusIndicator(Colors.green)
                                    :null),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                              child: Text(
                                appointmentModel.status??"--",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                   Text(
                                      appointmentModel.type??"--",
                                      style: const TextStyle(
                                        color: ColorResources.secondaryFontColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      )),
                                   Text("${S.of(context).LDoctor} ${appointmentModel.doctFName??"--"} ${appointmentModel.doctLName??"--"}",
                                      style: const TextStyle(
                                        color: ColorResources.secondaryFontColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      )),
                                  Text(
                                      appointmentModel.departmentTitle??"--",
                                      style: const TextStyle(
                                        color: ColorResources.secondaryFontColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      )),
                                ],
                              ),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorResources.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15.0)),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Center(
                                    child: Text(S.of(context).LRebook,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0f0f0f),
                                          fontWeight: FontWeight.w600,
                                        ))),
                                onPressed: () {
                                  // Debug print to see what values we have
                                  print("DEBUG: appointmentModel.doctorId = ${appointmentModel.doctorId}");
                                  print("DEBUG: appointmentModel.id = ${appointmentModel.id}");

                                  if(appointmentModel.doctorId != null && appointmentModel.doctorId != 0) {
                                    // Use doctorId if available and not 0 - Direct to doctor details
                                    Get.toNamed(RouteHelper.getDoctorsDetailsPageRoute(doctId: appointmentModel.doctorId!.toString()));
                                  } else {
                                    // Fallback: Navigate to appointment details page which has working rebook functionality
                                    Get.toNamed(RouteHelper.getAppointmentDetailsPageRoute(appId: appointmentModel.id.toString()));
                                  }
                                })
                            //:Container(),
                          ],
                        ),
                        //  const Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Text("Token A - 12",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           color: ColorResources.primaryColor),
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }
  Widget _appointmentDate(date) {
  //  print(date);
    var appointmentDate = date.split("-");
    String appointmentMonth="";
    switch (int.parse(appointmentDate[1])) {
      case 1:
        appointmentMonth = "JAN";
        break;
      case 2:
        appointmentMonth = "FEB";
        break;
      case 3:
        appointmentMonth = "MARCH";
        break;
      case 4:
        appointmentMonth = "APRIL";
        break;
      case 5:
        appointmentMonth = "MAY";
        break;
      case 6:
        appointmentMonth = "JUN";
        break;
      case 7:
        appointmentMonth = "JULY";
        break;
      case 8:
        appointmentMonth = "AUG";
        break;
      case 9:
        appointmentMonth = "SEP";
        break;
      case 10:
        appointmentMonth = "OCT";
        break;
      case 11:
        appointmentMonth = "NOV";
        break;
      case 12:
        appointmentMonth = "DEC";
        break;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(right: 15,left: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            ColorResources.primaryColor,
            ColorResources.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(appointmentMonth,
              style: const TextStyle(
                color: Color(0xFF0f0f0f),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              )),
          Text(appointmentDate[2],
              style: const TextStyle(
                color: Color(0xFF0f0f0f),
                fontWeight: FontWeight.w700,
                fontSize: 32,
              )),
          Text(appointmentDate[0],
              style: const TextStyle(
                color: Color(0xFF0f0f0f),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              )),
        ],
      ),
    );
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 4, backgroundColor: color);
  }
}
