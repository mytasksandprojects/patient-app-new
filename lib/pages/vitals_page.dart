import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/generated/l10n.dart';
import '../helpers/route_helper.dart';
import '../helpers/vital_helper.dart';
import '../widget/app_bar_widget.dart';
import '../utilities/colors_constant.dart';

class VitalsPage extends StatefulWidget {
  const VitalsPage({super.key});

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  final _listVitals=VitalHelper.listVitals;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgColor,
      appBar: AppBar(
        leading: Transform.scale(
          scale: .8,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorResources.darkCardColor.withOpacity(0.9),
              border: Border.all(
                color: ColorResources.primaryColor.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 20.0,
                  color: ColorResources.primaryColor,
                ),
                onPressed: () => Get.back()),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          S.of(context).LVitals,
          style: const TextStyle(
              color: ColorResources.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          // Transform.scale(
          //   scale: .8,
          //   child: Container(
          //     margin: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: ColorResources.primaryColor.withOpacity(0.1),
          //       border: Border.all(
          //         color: ColorResources.primaryColor.withOpacity(0.3),
          //         width: 1,
          //       ),
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: IconButton(
          //         onPressed: () {
          //           // Add new vital reading functionality
          //         },
          //         icon: const Icon(
          //           Icons.add,
          //           size: 20,
          //           color: ColorResources.primaryColor,
          //         )),
          //   ),
          // )
        ],
      ),
      body: buildList(),
    );
  }

  buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _listVitals.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: ColorResources.darkCardColor.withOpacity(0.9),
              border: Border.all(
                color: ColorResources.primaryColor.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              onTap: () {
                Get.toNamed(RouteHelper.getVitalsDetailsPageRoute(
                    notificationId: _listVitals[index]));
              },
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      ColorResources.primaryColor,
                      ColorResources.secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _getVitalIcon(_listVitals[index]),
                  size: 24,
                  color: const Color(0xFF0f0f0f),
                ),
              ),
              title: Text(
                _listVitals[index].replaceAll("_", " "),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                _getVitalSubtitle(_listVitals[index]),
                style: const TextStyle(
                  fontSize: 12,
                  color: ColorResources.secondaryFontColor,
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorResources.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: ColorResources.primaryColor,
                  size: 16,
                ),
              ),
            ),
          );
        });
  }

  IconData _getVitalIcon(String vitalName) {
    final name = vitalName.toLowerCase();
    if (name.contains('heart') || name.contains('pulse') || name.contains('نبض')) {
      return Icons.favorite;
    } else if (name.contains('blood') || name.contains('pressure') || name.contains('ضغط')) {
      return Icons.bloodtype;
    } else if (name.contains('temperature') || name.contains('حرارة')) {
      return Icons.thermostat;
    } else if (name.contains('oxygen') || name.contains('أكسجين')) {
      return Icons.air;
    } else if (name.contains('sugar') || name.contains('glucose') || name.contains('سكر')) {
      return Icons.water_drop;
    } else if (name.contains('weight') || name.contains('وزن')) {
      return Icons.monitor_weight;
    } else {
      return Icons.health_and_safety;
    }
  }

  String _getVitalSubtitle(String vitalName) {
    final name = vitalName.toLowerCase();
    if (name.contains('heart') || name.contains('pulse') || name.contains('نبض')) {
      return "Monitor your heart rate";
    } else if (name.contains('blood') || name.contains('pressure') || name.contains('ضغط')) {
      return "Track blood pressure";
    } else if (name.contains('temperature') || name.contains('حرارة')) {
      return "Body temperature readings";
    } else if (name.contains('oxygen') || name.contains('أكسجين')) {
      return "Oxygen saturation levels";
    } else if (name.contains('sugar') || name.contains('glucose') || name.contains('سكر')) {
      return "Blood glucose monitoring";
    } else if (name.contains('weight') || name.contains('وزن')) {
      return "Weight measurements";
    } else {
      return "Health monitoring";
    }
  }
}
