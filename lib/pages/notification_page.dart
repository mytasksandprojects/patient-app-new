import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/generated/l10n.dart';
import 'package:userapp/services/patient_files_service.dart';
import '../controller/notification_controller.dart';
import '../model/notification_model.dart';
import '../utilities/api_content.dart';
import '../utilities/colors_constant.dart';
import '../widget/app_bar_widget.dart';
import '../controller/notification_dot_controller.dart';
import '../helpers/date_time_helper.dart';
import '../helpers/route_helper.dart';
import '../services/user_service.dart';
import '../widget/image_box_widget.dart';
import '../widget/loading_Indicator_widget.dart';
import '../widget/no_data_widgets.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoading = false;
  late NotificationController notificationController;

  @override
  void initState() {
    getAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgColor,
      appBar: IAppBar.commonAppBar(title: S.of(context).LNotification),
      body: _isLoading 
          ? Container(
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
            )
          : Container(
              decoration: const BoxDecoration(
                color: ColorResources.bgColor,
              ),
              child: _buildBody(),
            ),
    );
  }

  _buildBody() {
    return Obx(() {
      if (!notificationController.isError.value) {
        if (notificationController.isLoading.value) {
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
        } else if (notificationController.dataList.isEmpty) {
          return const NoDataWidget();
        } else {
          return _buildDataList(notificationController.dataList);
        }
      } else {
        return Container();
      }
    });
  }

  void getAndSetData() async {
    setState(() {
      _isLoading = true;
    });

    final res = await UserService.getDataById();
    if (res != null) {
      notificationController = Get.put(NotificationController(date: res.createdAt ?? ""));
    }
    final NotificationDotController notificationDotController = Get.find(tag: "notification_dot");
    notificationDotController.setDotStatus(false);

    await UserService.updateNotificationLastSeen();
    setState(() {
      _isLoading = false;
    });
  }

  _buildDataList(RxList dataList) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        NotificationModel notificationModel = dataList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: _buildNotificationCard(notificationModel),
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notificationModel) {
    return GestureDetector(
      onTap: notificationModel.image == null || notificationModel.image == ""
          ? () {
              if (notificationModel.fileId != null) {
                Get.toNamed(RouteHelper.getPatientFilePageRoute());
                openFileUrl(notificationModel.fileId.toString());
              } else if (notificationModel.prescriptionId != null) {
                Get.toNamed(RouteHelper.getPrescriptionListPageRoute());
                launchUrl(
                  Uri.parse("${ApiContents.prescriptionUrl}/${notificationModel.prescriptionId}"),
                  mode: LaunchMode.externalApplication,
                );
              } else if (notificationModel.txnId != null) {
                Get.toNamed(RouteHelper.getWalletPageRoute());
              } else if (notificationModel.appointmentId != null) {
                Get.toNamed(RouteHelper.getAppointmentDetailsPageRoute(
                    appId: notificationModel.appointmentId.toString()));
              }
            }
          : () {
              Get.toNamed(RouteHelper.getNotificationDetailsPageRoute(
                  notificationId: notificationModel.id?.toString() ?? ""));
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
            // Leading Icon/Image Section
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
              child: notificationModel.image == null || notificationModel.image == ""
                  ? Icon(
                      _getNotificationIcon(notificationModel),
                      color: ColorResources.primaryColor,
                      size: 24,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ImageBoxFillWidget(
                        imageUrl: "${ApiContents.imageUrl}/${notificationModel.image}",
                        boxFit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(width: 15),
            
            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    notificationModel.title ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorResources.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Body
                  Text(
                    notificationModel.body ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ColorResources.secondaryFontColor,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Time and Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Time
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
                          DateTimeHelper.getDataFormat(notificationModel.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorResources.primaryColor,
                          ),
                        ),
                      ),
                      
                      // Type Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getNotificationColor(notificationModel).withOpacity(0.1),
                          border: Border.all(
                            color: _getNotificationColor(notificationModel).withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getNotificationType(notificationModel),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getNotificationColor(notificationModel),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: ColorResources.primaryColor.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationModel notificationModel) {
    if (notificationModel.fileId != null) {
      return Icons.folder;
    } else if (notificationModel.prescriptionId != null) {
      return Icons.medication;
    } else if (notificationModel.txnId != null) {
      return Icons.payment;
    } else if (notificationModel.appointmentId != null) {
      return Icons.calendar_today;
    }
    return Icons.notifications;
  }

  Color _getNotificationColor(NotificationModel notificationModel) {
    if (notificationModel.fileId != null) {
      return Colors.blue;
    } else if (notificationModel.prescriptionId != null) {
      return Colors.green;
    } else if (notificationModel.txnId != null) {
      return Colors.orange;
    } else if (notificationModel.appointmentId != null) {
      return Colors.purple;
    }
    return ColorResources.primaryColor;
  }

  String _getNotificationType(NotificationModel notificationModel) {
    if (notificationModel.fileId != null) {
      return S.of(context).LFiles;
    } else if (notificationModel.prescriptionId != null) {
      return S.of(context).LPrescription;
    } else if (notificationModel.txnId != null) {
      return  S.of(context).LPayment;
    } else if (notificationModel.appointmentId != null) {
      return S.of(context).LAppointment;
    }
    return S.of(context).LAppointment;
  }

  void openFileUrl(String id) async {
    setState(() {
      _isLoading = true;
    });
    final res = await PatientFilesService.getDataById(id: id);
    if (res != null) {
      if (res.fileUrl != null && res.fileUrl != "") {
        final fileUrl = "${ApiContents.imageUrl}/${res.fileUrl}";
        await launchUrl(Uri.parse(fileUrl));
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}
