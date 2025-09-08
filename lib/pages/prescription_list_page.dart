import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/generated/l10n.dart';
import '../controller/prescription_controller.dart';
import '../helpers/date_time_helper.dart';
import '../utilities/api_content.dart';
import '../utilities/colors_constant.dart';
import '../widget/app_bar_widget.dart';
import '../model/prescription_model.dart';
import '../widget/loading_Indicator_widget.dart';
import '../widget/no_data_widgets.dart';

class PrescriptionListPage extends StatefulWidget {
  const PrescriptionListPage({super.key});

  @override
  State<PrescriptionListPage> createState() => _PrescriptionListPageState();
}

class _PrescriptionListPageState extends State<PrescriptionListPage> {
  PrescriptionController prescriptionController=Get.put(PrescriptionController());

  @override
  void initState() {
    // TODO: implement initState
    prescriptionController.getDataBYUid();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgColor,
      appBar: IAppBar.commonAppBar(title: S.of(context).LPrescription),
      body: Container(
        decoration: const BoxDecoration(
          color: ColorResources.bgColor,
        ),
        child: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return  Obx(()
    {
      if (!prescriptionController.isError.value) { // if no any error
        if (prescriptionController.isLoading.value) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorResources.gradientStart,
                  ColorResources.gradientEnd
                ],
              ),
            ),
            child: const ILoadingIndicatorWidget(),
          );
        } else {
          return prescriptionController.dataList.isEmpty?const NoDataWidget():
          ListView.builder(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              itemCount:prescriptionController.dataList.length ,
              itemBuilder: (context, index){
                PrescriptionModel prescriptionModel=prescriptionController.dataList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                    onTap: (){
                      launchUrl(Uri.parse("${ApiContents.prescriptionUrl}/${prescriptionModel.id}"),
                          mode: LaunchMode.externalApplication
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ColorResources.darkCardColor,
                        border: Border.all(
                          color: ColorResources.primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Leading Icon Section
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: ColorResources.primaryColor.withOpacity(0.1),
                              border: Border.all(
                                color: ColorResources.primaryColor.withOpacity(0.3),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.medication,
                              color: ColorResources.primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 15),
                          
                          // Content Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Doctor Name and ID
                                Text(
                                  "${prescriptionModel.doctorFName} ${prescriptionModel.doctorLName} #${prescriptionModel.id??"--"}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorResources.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Patient Name
                                Text(
                                  "${prescriptionModel.patientFName} ${prescriptionModel.patientLName}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ColorResources.secondaryFontColor,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // Date Row
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: ColorResources.primaryColor.withOpacity(0.1),
                                    border: Border.all(
                                      color: ColorResources.primaryColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    DateTimeHelper.getDataFormatWithTime(prescriptionModel.createdAt),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: ColorResources.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Download Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorResources.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.download,
                              color: ColorResources.primaryColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

          );

        }
      }else {
        return Container();
      } //Error svg

    });
  }
}
