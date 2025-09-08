import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/Language.dart';
import 'package:userapp/generated/l10n.dart';
import '../model/doctors_model.dart';
import '../services/configuration_service.dart';
import '../controller/depratment_controller.dart';
import '../controller/doctors_controller.dart';
import '../helpers/route_helper.dart';
import '../model/department_model.dart';
import '../utilities/api_content.dart';
import '../utilities/colors_constant.dart';
import '../utilities/image_constants.dart';
import '../utilities/sharedpreference_constants.dart';
import '../widget/app_bar_widget.dart';
import '../widget/button_widget.dart';
import '../widget/error_widget.dart';
import '../widget/image_box_widget.dart';
import '../widget/loading_Indicator_widget.dart';
import '../widget/no_data_widgets.dart';
import '../widget/search_box_widget.dart';

import 'auth/login_page.dart';

class DoctorsListPage extends StatefulWidget {
  final String? selectedDeptId;
  final String? selectedDeptTitle;

  const DoctorsListPage(
      {super.key, this.selectedDeptId, this.selectedDeptTitle});

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  final DoctorsController _doctorsController = Get.put(DoctorsController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchTextController = TextEditingController();
  final DepartmentController _departmentController =
      Get.put(DepartmentController(), tag: "department");
  int? selectedDeptId;
  String? selectedDeptTitle;
  bool stopBooking = false;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.selectedDeptId != "" && widget.selectedDeptTitle != "") {
      selectedDeptId = int.parse(widget.selectedDeptId ?? "");
      selectedDeptTitle = widget.selectedDeptTitle;
    }

    _doctorsController.getData("");
    getAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgColor,
      // appBar: IAppBar.commonAppBar(title:  S.of(context).LDoctorAmr),
      body: _isLoading ? const ILoadingIndicatorWidget() : _buildBody(),
    );
  }

  // build body ui
  _buildBody() {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      children: [
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: ColorResources.primaryColor.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: _searchTextController,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: S.of(context).LSearchPlaceholder,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: ColorResources.primaryColor,
                size: 24,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onSubmitted: (value) {
              _doctorsController.getData(_searchTextController.text);
            },
          ),
        ),
        const SizedBox(height: 20),
        _buildDepartment(),
        selectedDeptTitle == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 20),
                child: Row(
                  children: [
                    RichText(
                        text: TextSpan(
                      text: S.of(context).LShowingdoctorfrom,
                      style: const TextStyle(
                          color: ColorResources.primaryFontColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      //  children:  <TextSpan>[
                      //   TextSpan(text: '$selectedDeptTitle', style:const TextStyle(
                      //       color: ColorResources.primaryColor,
                      //       fontWeight: FontWeight.w600,
                      //        fontSize: 14
                      //    ),),
                      //    const TextSpan(text:" department",
                      //    style:  TextStyle(
                      //        color: ColorResources.primaryFontColor,
                      //        fontWeight: FontWeight.w600,
                      //        fontSize: 14
                      //    ),)
                      //  ],
                      //  ),
                      //  ),
                      //  IconButton(onPressed: (){
                      //    setState(() {
                      //      selectedDeptId=null;
                      //      selectedDeptTitle=null;
                      //    });
                      //  }, icon: const Icon(Icons.remove_circle,color: ColorResources.btnColor,
                      //  size: 24,
                    ))
                  ],
                ),
              ),
        Obx(() {
          if (!_doctorsController.isError.value) {
            // if no any error
            if (_doctorsController.isLoading.value) {
              return const IVerticalListLongLoadingWidget();
            } else if (_doctorsController.dataList.isEmpty) {
              return const NoDataWidget();
            } else {
              return _buildDrList(_doctorsController.dataList);
            }
          } else {
            return const IErrorWidget();
          } //Error svg
        })
      ],
    );
  }

  // build dr list ui
  _buildDrList(List dataList) {
    return Column(
      children:
          dataList.where((item) => item != null).map<Widget>((doctorsModel) {
        if (doctorsModel == null || !showDoctor(doctorsModel)) {
          return Container();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Card(
            color: const Color(0xFF1A1A1A),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color: ColorResources.primaryColor.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor Info (Left Side)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Doctor Name
                            Text(
                              "د. ${doctorsModel.fName ?? "--"} ${doctorsModel.lName ?? "--"}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: ColorResources.primaryColor,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Specialization
                            Text(
                              doctorsModel.specialization ?? "",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            // Rating Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "(${doctorsModel.numberOfReview ?? 0} تقييم) ${doctorsModel.averageRating?.toStringAsFixed(1) ?? "0.0"}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    final rating =
                                        doctorsModel.averageRating ?? 0.0;
                                    return Icon(
                                      Icons.star,
                                      color: starIndex < rating.floor()
                                          ? ColorResources.primaryColor
                                          : Colors.grey[600],
                                      size: 15,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Doctor Avatar (Right Side)
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: ColorResources.primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: ColorResources.primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: doctorsModel.image != null && doctorsModel.image!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: ImageBoxFillWidget(
                                  imageUrl: "${ApiContents.imageUrl}/${doctorsModel.image}",
                                  boxFit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text(
                                  "د.${doctorsModel.fName?.substring(0, 1) ?? "أ"}",
                                  style: const TextStyle(
                                    color: ColorResources.primaryColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Bottom Section with Info and Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Book Now Button (Left Side)
                      SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width / 4,
                        child: SmallButtonsWidget(
                          titleFontSize: 12,
                          title: S.of(context).LBookNow,
                          onPressed: stopBooking ||
                                  (doctorsModel.stopBooking ?? 0) == 1
                              ? null
                              : () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  final loggedIn = preferences.getBool(
                                          SharedPreferencesConstants.login) ??
                                      false;
                                  final userId = preferences.getString(
                                      SharedPreferencesConstants.uid);
                                  if (loggedIn &&
                                      userId != null &&
                                      userId.isNotEmpty) {
                                    Get.toNamed(
                                        RouteHelper.getDoctorsDetailsPageRoute(
                                            doctId: (doctorsModel.id ?? 0)
                                                .toString()));
                                  } else {
                                    Get.to(() => LoginPage(onSuccessLogin: () {
                                          Get.toNamed(RouteHelper
                                              .getDoctorsDetailsPageRoute(
                                                  doctId: (doctorsModel.id ?? 0)
                                                      .toString()));
                                        }));
                                  }
                                },
                          rounderRadius: 25,
                        ),
                      ),
                      // Right side info - horizontal layout
                      Row(
                        children: [
                          // Experience
                          Row(
                            children: [
                              Text(
                                "${doctorsModel.exYear ?? "--"} ${S.of(context).LYear}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.access_time,
                                color: ColorResources.primaryColor,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          // Appointments Done
                          Row(
                            children: [
                              Text(
                                "${doctorsModel.totalAppointmentDone ?? 0}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.medical_services,
                                color: ColorResources.primaryColor,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          // Department/Location
                          Row(
                            children: [
                              Text(
                                selectedDeptTitle ?? "عام",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.location_on,
                                color: ColorResources.primaryColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Status indicator at bottom right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "متاح اليوم",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  // Warning for not accepting appointments
                  if ((doctorsModel.stopBooking ?? 0) == 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                S.of(context).LCurrentnotacceptingappointment,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  _buildDepartment() {
    return Obx(() {
      if (!_departmentController.isError.value) {
        // if no any error
        if (_departmentController.isLoading.value) {
          return const IVerticalListLongLoadingWidget();
        } else if (_departmentController.dataList.isEmpty) {
          return Container();
        } else {
          return _departmentController.dataList.length == 1
              ? Container()
              : _buildDepartmentBox(_departmentController.dataList);
        }
      } else {
        return Container();
      } //Error svg
    });
  }

  _buildDepartmentBox(List dataList) {
    return Card(
      elevation: .1,
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(5),
        title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).LBranches,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  dataList.length < 4
                      ? Container()
                      : Text(
                          S.of(context).LSwipeMore,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                ])),
        subtitle: SizedBox(
          height: 100,
          child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: dataList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final DepartmentModel departmentModel = dataList[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 18, 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedDeptId == departmentModel.id) {
                          selectedDeptId = null;
                          selectedDeptTitle = null;
                        } else {
                          selectedDeptId = departmentModel.id;
                          selectedDeptTitle = departmentModel.title;
                        }
                      });
                      // Get.toNamed(RouteHelper.getSearchProductsPageRoute(initSelectedProductCatId: productCatModel.id.toString()));
                    },
                    child: Column(
                      children: [
                        // departmentModel.image == null ||
                        //     departmentModel.image == "" ?
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          child: Icon(
                            Icons.location_on_sharp,
                            color: ColorResources.primaryColor,
                            size: 35,
                          ),
                        ),
                        //     :
                        // CircleAvatar(
                        //     backgroundColor: Colors.white,
                        //     radius: 25,
                        //     child:
                        //     Container(
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         image: DecorationImage(
                        //           fit: BoxFit.fill,
                        //           image: NetworkImage(
                        //               '${ApiContents.imageUrl}/${departmentModel.image}'
                        //           ),
                        //         ),
                        //       ),
                        //     )
                        // ),
                        const SizedBox(height: 5),
                        Text(
                          LanguageController.to.isArabic.value
                              ? departmentModel.titleAr ?? ""
                              : departmentModel.title ?? "",
                          maxLines: 1, // Limit to 1 line
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: selectedDeptId == departmentModel.id
                                ? ColorResources.primaryColor
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  getAndSetData() async {
    setState(() {
      _isLoading = true;
    });

    final res = await ConfigurationService.getDataById(idName: "stop_booking");
    if (res != null) {
      if (res.value == "true") {
        stopBooking = true;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool showDoctor(DoctorsModel doctorsModel) {
    if (selectedDeptId == null) {
      return true;
    } else if (selectedDeptId != null &&
        selectedDeptId == doctorsModel.deptId) {
      return true;
    } else {
      return false;
    }
  }
}

