import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_bar_code/qr/qr.dart';
import 'package:userapp/generated/l10n.dart';
import 'package:userapp/helpers/date_time_helper.dart';
import 'package:userapp/helpers/route_helper.dart';
import 'package:userapp/model/appointment_model.dart';
import 'package:userapp/services/appointment_service.dart';
import 'package:userapp/utilities/colors_constant.dart';
import 'package:userapp/widget/app_bar_widget.dart';
import 'package:userapp/widget/button_widget.dart';
import 'package:userapp/widget/loading_Indicator_widget.dart';
import 'package:userapp/widget/error_widget.dart';

class AppointmentSuccessPage extends StatefulWidget {
  final String appointmentId;

  const AppointmentSuccessPage({
    super.key,
    required this.appointmentId,
  });

  @override
  State<AppointmentSuccessPage> createState() => _AppointmentSuccessPageState();
}

class _AppointmentSuccessPageState extends State<AppointmentSuccessPage> {
  AppointmentModel? appointmentDetails;
  bool isLoading = true;
  bool hasError = false;
  String qrData = "";

  @override
  void initState() {
    super.initState();
    _loadAppointmentDetails();
  }

  Future<void> _loadAppointmentDetails() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final appointment = await AppointmentService.getDataById(
        appId: widget.appointmentId,
      );

      if (appointment != null) {
        setState(() {
          appointmentDetails = appointment;
          qrData = _generateQRData(appointment);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  String _generateQRData(AppointmentModel appointment) {
    final qrDataMap = {
      "appointment_id": appointment.id,
      "date": appointment.date,
      "time": appointment.timeSlot,
    };
    return jsonEncode(qrDataMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgColor,
      appBar: IAppBar.commonAppBar(
        title: "Appointment Confirmation",
        showBackButton: false,
      ),
      body: isLoading
          ? const ILoadingIndicatorWidget()
          : hasError
              ? const IErrorWidget()
              : _buildSuccessContent(),
    );
  }

  Widget _buildSuccessContent() {
    if (appointmentDetails == null) {
      return const IErrorWidget();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Success Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  ColorResources.primaryColor,
                  ColorResources.secondaryColor,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 24),

          // Appointment ID
          Text(
            "Appointment ID: #${appointmentDetails!.id}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorResources.primaryColor,
            ),
          ),

          const SizedBox(height: 12),

          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              appointmentDetails!.type?.toUpperCase() ?? "APPOINTMENT",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // QR Code Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // QR Code
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ColorResources.primaryColor.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: QRCode(
                    data: qrData,
                    size: 200,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Success Message
          Text(
            "Your Appointment Booked Successfully!",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Visit the clinic and scan the provided QR code to instantly generate your appointment queue number",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),

          // Appointment Details Card
          Container(
            decoration: BoxDecoration(
              color: ColorResources.darkCardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorResources.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDetailRow(
                  "Doctor",
                  appointmentDetails!.doctFName != null &&
                          appointmentDetails!.doctLName != null
                      ? "Dr. ${appointmentDetails!.doctFName} ${appointmentDetails!.doctLName}"
                      : "Dr. ${appointmentDetails!.doctorId}",
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  "Date & Time",
                  "${DateTimeHelper.getDataFormat(appointmentDetails!.date ?? "")} ${DateTimeHelper.convertTo12HourFormat(appointmentDetails!.timeSlot ?? "")}",
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  "Patient Name",
                  appointmentDetails!.pFName != null &&
                          appointmentDetails!.pLName != null
                      ? "${appointmentDetails!.pFName} ${appointmentDetails!.pLName}"
                      : "Patient",
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          Column(
            children: [
              SmallButtonsWidget(
                title: "View My Appointments",
                onPressed: () {
                  Get.offNamedUntil(
                    RouteHelper.getMyBookingPageRoute(),
                    ModalRoute.withName('/HomePage'),
                  );
                },
              ),
              const SizedBox(height: 12),
              SmallButtonsWidget(
                title: "Back to Home",
                onPressed: () {
                  Get.offNamedUntil(
                    RouteHelper.getHomePageRoute(),
                    ModalRoute.withName('/HomePage'),
                  );
                },
                backgroundColor: Colors.transparent,
                borderColor: ColorResources.primaryColor,
                textColor: ColorResources.primaryColor,
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
