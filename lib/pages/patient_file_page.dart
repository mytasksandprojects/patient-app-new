import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/controller/patient_file_controller.dart';
import 'package:userapp/generated/l10n.dart';
import 'package:userapp/helpers/date_time_helper.dart';
import 'package:userapp/model/patient_file_model.dart';

import 'package:userapp/utilities/api_content.dart';
import 'package:userapp/widget/app_bar_widget.dart';
import 'package:userapp/widget/file_upload_dialog.dart';
import 'package:get/get.dart';
import 'package:userapp/widget/loading_Indicator_widget.dart';
import '../utilities/colors_constant.dart';
import '../widget/error_widget.dart';
import '../widget/no_data_widgets.dart';
import '../widget/search_box_widget.dart';

class PatientFilePage extends StatefulWidget {
  final String? patientId;
  const PatientFilePage({super.key,this.patientId});

  @override
  State<PatientFilePage> createState() => _PatientFilePageState();
}

class _PatientFilePageState extends State<PatientFilePage> {
  ScrollController scrollController=ScrollController();
  PatientFileController patientFileController=PatientFileController();
  final TextEditingController _searchTextController=TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    getAndSetData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBar.commonAppBar(title: S.of(context).LFiles),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDialog(),
        backgroundColor: ColorResources.primaryColor,
        icon: const Icon(Icons.upload_file, color: Colors.white),
        label: Text(
          S.of(context).LUploadFile,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body:  ListView(
        padding: const EdgeInsets.all(8),
        controller: scrollController,
        children: [
          const SizedBox(height: 10),
          ISearchBox.buildSearchBox(textEditingController: _searchTextController,labelText:S.of(context).LSearchReport,onFieldSubmitted:(){

            patientFileController.getData(_searchTextController.text);
          }

          ),
          const SizedBox(height: 20),
          Obx(() {
            if (!patientFileController.isError.value) { // if no any error
              if (patientFileController.isLoading.value) {
                return const IVerticalListLongLoadingWidget();
              } else if (patientFileController.dataList.isEmpty) {
                return const NoDataWidget();
              }

              else {
                return _buildList(patientFileController.dataList);
              }
            }else {
              return  const IErrorWidget();
            } //Error svg
          }
          ),
        ],
      )
    );
  }

  Widget _buildList(RxList dataList) {
    return ListView.builder(
      padding: EdgeInsets.zero,
        controller: scrollController,
        shrinkWrap: true,
        itemCount:dataList.length ,
        itemBuilder: (context,index){
          PatientFileModel patientFileModel=dataList[index];
          //   print(testimonialModel.image);
          return getCheckToShow(patientFileModel.patientId.toString())?Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0,
            child: ListTile(
              onTap: ()async {
                if(patientFileModel.fileUrl!=null&&patientFileModel.fileUrl!=""){
                  final fileUrl="${ApiContents.imageUrl}/${patientFileModel.fileUrl}";
                    await launchUrl(Uri.parse(fileUrl));
                }

              },
              trailing: const Icon(Icons.download,
              size: 20,
              color: ColorResources.iconColor,
              ),
              subtitle:   Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 3),
                  Text("${patientFileModel.pFName} ${patientFileModel.pLName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                    ),),
                  const SizedBox(height: 3),
                  Text(DateTimeHelper.getDataFormat(patientFileModel.createdAt??""),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                    ),),
                ],
              ),
              title:     Text(patientFileModel.fileName??"",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14
                ),)
            ),
          ):Container();
        });
  }

  void getAndSetData() async {
    patientFileController.getData("");
  }

  void _showUploadDialog() {
    FileUploadDialog.show(
      context,
      controller: patientFileController,
    );
  }

  bool getCheckToShow(String patientId) {
    if(widget.patientId!=null&&widget.patientId!=""){
      if(widget.patientId==patientId){
        return true;
      }else{
        return false;
      }

    }else{
      return true;
    }
  }
}
